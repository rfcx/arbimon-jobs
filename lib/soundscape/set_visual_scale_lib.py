import MySQLdb
import MySQLdb.cursors
from a2pyutils import colors
from contextlib import closing
from a2pyutils.config import Config
from a2pyutils import tempfilecache
import a2pyutils.palette
import soundscape
import sys
import a2pyutils.storage


def exit_error(msg, code=-1, log=None):
    print '<<<ERROR>>>\n{}\n<<<\ERROR>>>'.format(msg)
    if log:
        log.write('\n<<<ERROR>>>\n{}\n<<<\ERROR>>>'.format(msg))
    sys.exit(code)


def get_db(config):
    db = None
    try:
        db = MySQLdb.connect(
            host=config[0], user=config[1], passwd=config[2], db=config[3],
            cursorclass=MySQLdb.cursors.DictCursor
        )
    except MySQLdb.Error as e:
        exit_error("cannot connect to database.")
    if not db:
        exit_error("cannot connect to database.")
    return db


def get_sc_data(db, soundscape_id):
    sc_data = None
    with closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT S.uri, S.playlist_id, SAT.identifier as aggregation
                FROM soundscapes S
                JOIN soundscape_aggregation_types SAT ON S.soundscape_aggregation_type_id = SAT.soundscape_aggregation_type_id
                WHERE soundscape_id = %s
            """,
                [soundscape_id]
            )
            sc_data = cursor.fetchone()
    if not sc_data:
        exit_error("Soundscape #{} not found".format(soundscape_id))
    return sc_data


def get_norm_vector(db, sc_data):
    aggregation = soundscape.aggregations[sc_data['aggregation']]
    norm_vector = {}
    date_parts = [
        'DATE_FORMAT(R.datetime, "{}")'.format(dp)
        for dp in aggregation['date']
    ]
    with closing(db.cursor()) as cursor:
            cursor.execute('''
                SELECT {} , COUNT(*) as count
                FROM `playlist_recordings` PR
                JOIN `recordings` R ON R.recording_id = PR.recording_id
                WHERE PR.playlist_id = {}
                GROUP BY {}
            '''.format(
                ', '.join([
                    "{} as dp_{}".format(d, i)
                    for i, d in enumerate(date_parts)
                ]),
                int(sc_data['playlist_id']),
                ', '.join(date_parts)
            ))
            for row in cursor:
                idx = sum([
                    int(row['dp_{}'.format(i)]) * p
                    for i, p in enumerate(aggregation['projection'])
                ])
                norm_vector[idx] = row['count']
    return norm_vector


def get_scidx_file(scidx_uri, file_cache, storage):
    scidx_file = None
    try:
        scidx_file = file_cache.fetch(scidx_uri)
        if isinstance(scidx_file, tempfilecache.CacheMiss):
            finp = storage.get_file(scidx_uri)
            scidx_file.set_file_data(finp.read())
    except a2pyutils.storage.StorageError as se:
        exit_error('cannot not retrieve scidx_file. error:'+se.message)
    if not scidx_file:
        exit_error('cannot not retrieve scidx_file.')
    return scidx_file


def write_image(img_file, scidx_file, clip_max, palette_id, norm_vector=None):
    try:
        sc = soundscape.Soundscape.read_from_index(scidx_file['path'])
        if clip_max is not None:
            sc.stats['max_count'] = clip_max
        if norm_vector is not None:
            sc.norm_vector = norm_vector
        sc.write_image(img_file, a2pyutils.palette.get_palette(palette_id))
    except:
        exit_error('cannot write image file.')


def upload_image(img_uri, img_file, storage):
    try:
        with open(img_file, 'rb') as finp:
            storage.put_file(img_uri, finp.read(), acl='public-read')
    except:
        exit_error('cannot upload image file.')


def update_db(db, clip_max, palette_id, soundscape_id, normalized):
    try:
        with closing(db.cursor()) as cursor:
            cursor.execute("""
                UPDATE `soundscapes`
                SET visual_max_value = %s, visual_palette = %s,
                    normalized = %s
                WHERE soundscape_id = %s
            """, [clip_max, palette_id, int(normalized), soundscape_id])
            db.commit()
    except:
        print 'WARNING: Cannot update database soundscape information'


def run(soundscape_id, clip_max, palette_id, normalized=0):
    configuration = Config()
    config = configuration.data()

    db = get_db(config)

    file_cache = tempfilecache.Cache(config=configuration)

    sc_data = get_sc_data(db, soundscape_id)
    norm_vector = get_norm_vector(db, sc_data) if normalized else None

    storage = a2pyutils.storage.BotoBucketStorage(**configuration.awsConfig)

    img_uri = sc_data['uri']
    scidx_uri = sc_data['uri'].replace('image.png', 'index.scidx')
    scidx_file = get_scidx_file(scidx_uri, file_cache, storage)

    img_file = file_cache.key2File(img_uri)

    write_image(img_file, scidx_file, clip_max, palette_id, norm_vector)

    upload_image(img_uri, img_file, storage)

    update_db(db, clip_max, palette_id, soundscape_id, normalized)

    db.close()

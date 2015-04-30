from set_visual_scale_lib import *
from a2audio.classification_lib import *
from contextlib import closing

def get_soundscape_job_data(db,job_id):
    job = None
    try:
        with closing(db.cursor()) as cursor:
            cursor.execute("""
            SELECT JP.playlist_id, JP.max_hertz, JP.bin_size,
                JP.soundscape_aggregation_type_id,
                SAT.identifier as aggregation, JP.threshold,
                J.project_id, J.user_id, JP.name, JP.frequency
            FROM jobs J
            JOIN job_params_soundscape JP ON J.job_id = JP.job_id
            JOIN soundscape_aggregation_types SAT ON
                SAT.soundscape_aggregation_type_id = JP.soundscape_aggregation_type_id
            WHERE J.job_id = {0}
            LIMIT 1
            """.format(job_id))
        
            job = cursor.fetchone()
    except:
        exit_error("Could not query database with soundscape job #{}".format(jobId))
    if not job:
        exit_error("Could not find soundscape job #{}".format(jobId))
    return [job['playlist_id'],job['max_hertz'],job['bin_size'],job['soundscape_aggregation_type_id']
            ,job['aggregation'],job['threshold'],job['project_id'],job['user_id']
            ,job['name'],job['frequency']]

def run_soundscape(job_id):
    configuration = Config()
    config = configuration.data()

    log = Logger(job_id, 'playlist2soundscape.py', 'main')
    log.also_print = True
    
    db = get_db(config)
    
    (
        playlist_id, max_hertz, bin_size, agrrid, agr_ident,
        threshold, pid, uid, name, frequency
    ) = get_soundscape_job_data(db,job_id)
    

import boto
from a2pyutils.config import Config
import sys
import os
import a2pyutils.storage
from soundscape.set_visual_scale_lib import get_db
from contextlib import closing


idss = [
    783,
    784,
    785,
    786,
    787,
    788,
    789,
    790,
    791,
    792,
    793
    ]

folder = "/home/rafa/recs/project_33/site_"

configuration = Config()
config_dest = configuration.data()
config_source = list(config_dest)
config_source[4] = 'a2-rafa'
db = get_db(config_dest)

for site_id in idss:
    uris = []
    recss =  os.listdir(folder+str(site_id)+"/" )
    for ee in recss:
        with closing(db.cursor()) as cursor:
            cursor.execute("INSERT INTO `recordings` ( `site_id`, `uri`, `datetime`, `mic`, `recorder`, `version`, `sample_rate`, `precision`, `duration`, `samples`, `file_size`, `bit_rate`, `sample_encoding`) VALUES("+str(site_id)+", 'project_33/site_"+str(site_id)+"/"+str(ee)+"', '2010-12-14 10:29:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC')")
            db.commit()
        
db.close()

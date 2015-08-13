#! .env/bin/python

import sys

sys.path.append("/home/rafa/node/arbimon2-jobs-stable/lib/")

local_storage_folder="/home/rafa/recs/"

from a2audio.training_lib import run_training
from soundscape.set_visual_scale_lib import get_db
from a2pyutils.config import Config
import json
from contextlib import closing

configuration = Config()
config_local = configuration.data()
db_local = get_db(config_local)

config_remote = list(config_local)
config_remote[0] = '54.86.171.3'
db_remote = get_db(config_remote)
                    
if len(sys.argv) < 3:
    print 'need more params'
    sys.exit(1)
    
remote_training_id = sys.argv[1]
local_training_id = sys.argv[2]

remote_data = []
with closing(db_remote.cursor()) as cursor:    
    cursor.execute("""
    SELECT `songtype_id`,`x1`,`y1`,`x2`,`y2`,ts.`uri` as roiuri ,r.`uri` as recuri
    FROM `training_set_roi_set_data` ts,`recordings` r
    where `training_set_id` = %s and r.`recording_id` = ts.`recording_id`
    """, [str(remote_training_id)])
    total_rows = int(cursor.rowcount)
    db_remote.commit()
    for i in range(total_rows):
        row = cursor.fetchone()
        remote_data.append(row)

local_species = None
songType = None
with closing(db_local.cursor()) as cursor:    
    cursor.execute("""SELECT `species_id`, `songtype_id`
                   FROM `training_sets_roi_set`
                   WHERE `training_set_id` = %s""", [str(local_training_id)])
    db_local.commit()
    row = cursor.fetchone()
    local_species = row['species_id']
    songType = row['songtype_id']

for row in remote_data:
    recuri = row['recuri'].split('/')
    recname = recuri[len(recuri)-1]
    rowrecid = None
    with closing(db_local.cursor()) as cursor:    
        cursor.execute("SELECT `recording_id` FROM `recordings` WHERE `uri` like '%"+str(recname)+"%'")
        db_local.commit()
        if int(cursor.rowcount) > 0:
            rowrecid = cursor.fetchone()
      
    if rowrecid is not None:
        print "rowrecid",rowrecid
        print [str(local_training_id),str(rowrecid),str(local_species),str(songType),str(row['x1']),str(row['y1']),str(row['x2']),str(row['y2']),str(row['roiuri'])]
        with closing(db_local.cursor()) as cursor:    
            cursor.execute("""INSERT INTO `training_set_roi_set_data`
            ( `training_set_id`, `recording_id`, `species_id`, `songtype_id`, `x1`, `y1`, `x2`, `y2`, `uri`)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
            [str(local_training_id),str(rowrecid['recording_id']),str(local_species),str(songType),str(row['x1']),str(row['y1']),str(row['x2']),str(row['y2']),str(row['roiuri'])])
            db_local.commit()
        
    recuri = None
    recname = None
    rowrecid = None
    

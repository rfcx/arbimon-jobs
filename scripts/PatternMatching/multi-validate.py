#! .env/bin/python

import sys
from a2audio.training_lib import run_training
from soundscape.set_visual_scale_lib import get_db
from a2pyutils.config import Config
import json
from contextlib import closing

model_Types = [1,2,3,4]

if len(sys.argv) > 1:
    model_Types=[]
    model_Types.append(int(sys.argv[1]))
    
configuration = Config()
config = configuration.data()
db = get_db(config)

validation_data = None

with open('scripts/data/validation_data.json') as fd:
    validation_data = json.load(fd)

rows = []
for model_type in model_Types:
    job_ids = []
    for i in range(len(validation_data)):
        r = validation_data[i]
        with closing(db.cursor()) as cursor:
            cursor.execute("""INSERT INTO `jobs`
                            ( `job_type_id`, `date_created`, `last_update`, `project_id`,
                            `user_id`, `uri`)
                            VALUES
                            (1,now(),now(),33,
                            1,'')
                            """)
            db.commit()
            jobId = cursor.lastrowid
            job_ids.append(jobId)
            cursor.execute("""INSERT INTO `job_params_training`
                (`job_id`, `model_type_id`, `training_set_id`, `use_in_training_present`,
                `use_in_training_notpresent`, `use_in_validation_present`, `use_in_validation_notpresent`, `name`)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)""",
                [jobId, str( model_type),
                 r['t_set'] , r['present'] , r['not_present'],
                 r['absent'],r['not_absent'] , r['name']
                 ])
            db.commit()
    
    
    for i in range(len(validation_data)):
        r = validation_data[i]
        j = job_ids[i]
        retVal = run_training(int(j),False)
        row = None
        row1= None
        if retVal:
            with closing(db.cursor()) as cursor:    
                cursor.execute("SELECT  `totaln`, `pos_n`, `neg_n`, `k_folds`, `accuracy`, `precision`, `sensitivity`, `specificity`  FROM `k_fold_Validations` WHERE `job_id` = "+str(j))
                row = cursor.fetchone()
                db.commit()
            with closing(db.cursor()) as cursor:    
                cursor.execute("select avg(exec_time) as time from recanalizer_stats where job_id = "+str(j)+"")
                row1 = cursor.fetchone()
                db.commit()        
            rows.append(','.join([str(model_type),r['name'],str(row['totaln']),str(row['pos_n']),str(row['neg_n']),str(row['k_folds']),str(row['accuracy']),str(row['precision']),str(row['sensitivity']),str(row['specificity']),str(row1['time'])]))
            row = None
            row1 = None
        else:
            print 'job failed'

print ','.join(['model_type','species','total_n','pos','neg','k','accuracy','precision','sensitivity','specificity','exec_time'])
for r in rows:
    print r

#!/usr/bin/env python

import sys
sys.path.append('/home/rafa/node/arbimon2-jobs-master-old/lib')
import shutil
import os
import json
from contextlib import closing
import MySQLdb
import tempfile
from a2pyutils.config import Config
from a2pyutils.logger import Logger

jobId = int(sys.argv[1].strip("'").strip(" "))
expectedRecordings = int(sys.argv[2].strip("'").strip(" "))

log = Logger(int(jobId), 'classificationresults.py', 'reducer')
log.write('script started')

currDir = os.path.dirname(os.path.abspath(__file__))
configuration = Config()
config = configuration.data()
log.write('configuration loaded')
log.write('trying database connection')
try:
    db = MySQLdb.connect(
        host=config[0], user=config[1], passwd=config[2], db=config[3])
except MySQLdb.Error as e:
    log.write('fatal error cannot connect to database.')
    quit()
log.write('database connection succesful')

tempFolders = str(configuration.pathConfig['tempDir'])
minVectorVal = 9999999.0
maxVectorVal = -9999999.0
print 'results'
log.write(
    'start cycle to gather results (expected:'+str(expectedRecordings)+')')
processedCount = 0
for line in sys.stdin:
    print line
    line = line.strip('\n')
    recId, presence, jId, species, songtype, minV, maxV = line.split(';')
    minV = minV.strip('\n')
    maxV = maxV.strip('\n')
    minV = float(minV.strip(' '))
    maxV = float(maxV.strip(' '))
    if minVectorVal > float(minV):
        minVectorVal = minV
    if maxVectorVal < float(maxV):
        maxVectorVal = maxV
    recId = int(recId.strip(' '))
    presence = int(presence.strip(' '))
    jId = int(jId.strip(' '))
    species = int(species.strip(' '))
    songtype = int(songtype.strip(' '))
    with closing(db.cursor()) as cursor:
        cursor.execute("""
            INSERT INTO `classification_results` (
                job_id, recording_id, species_id, songtype_id, present,
                max_vector_value
            ) VALUES (%s, %s, %s, %s, %s,
                %s
            )
        """, [jId, recId, species, songtype, presence, maxV])
        db.commit()
    processedCount = processedCount + 1
log.write('processed '+str(processedCount)+' of '+str(expectedRecordings))
log.write('end cycle to gather results')
log.write('saving stats to database')
jsonStats = json.dumps({"minv": minVectorVal, "maxv": maxVectorVal})
with closing(db.cursor()) as cursor:
    cursor.execute("""
        INSERT INTO `classification_stats` (`job_id`, `json_stats`)
        VALUES (%s, %s)
    """, [jobId, jsonStats])
    db.commit()
    cursor.execute("""
        UPDATE `jobs`
        SET `progress` = `progress_steps`, `completed` = 1,
            state="completed", `last_update` = now()
        WHERE `job_id` = %s
    """, [jobId])
    db.commit()

db.close()
log.write('removing working folder')
shutil.rmtree(tempFolders+"/classification_"+str(jobId))
print 'ended'

log.close()

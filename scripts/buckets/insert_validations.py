import sys
sys.path.append("/home/rafa/node/arbimon2-jobs-stable/lib")
from a2pyutils.config import Config
import os
from soundscape.set_visual_scale_lib import get_db
from contextlib import closing

if len(sys.argv)<3:
    print "need a validation list file , and local specie id"
    exit(1)

print 'start'

configuration = Config()
config_source = configuration.data()

speciedId = int(sys.argv[2])

with open(sys.argv[1]) as f:
    content = f.readlines()

db = get_db(config_source)

c = 0
for filename in content:
    filename = filename.strip("\n")
    recnamePart = filename.split(",")
    bucketKey = recnamePart[0]
    press = recnamePart[3]
    recnamePart = bucketKey.split("/")
    recName = recnamePart[len(recnamePart)-1]
   # print recName , press
    rid = None
    q="""SELECT `recording_id` as rid FROM `recordings` WHERE `uri` like '%"""+recName+"""'"""
    with closing(db.cursor()) as cursor:
        cursor.execute(q)
        row = cursor.fetchone()
        rid = row['rid']
    with closing(db.cursor()) as cursor:
        cursor.execute(""" INSERT INTO `recording_validations` ( `recording_id`, `project_id`, `user_id`, `species_id`, `songtype_id`, `present`) 
        VALUES (%s,33,1,%s,1,%s) ; """ , [str(rid),str(speciedId),str(press)])
        db.commit()
        c = c + 1
print "processed ", c
        
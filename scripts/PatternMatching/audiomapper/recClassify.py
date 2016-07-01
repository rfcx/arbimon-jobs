#!/usr/bin/env python

import sys
sys.path.append('/home/rafa/node/arbimon2-jobs-master-old/lib')
import csv
from a2audio.recanalizer import Recanalizer
import cPickle as pickle
import tempfile
import boto
import os
import math
import time
import multiprocessing
from joblib import Parallel, delayed
from contextlib import closing
import MySQLdb
from boto.s3.connection import S3Connection
from a2pyutils.config import EnvironmentConfig
from a2pyutils.logger import Logger


start_time_all = time.time()
logWorkers = True
num_cores = multiprocessing.cpu_count()

jobId = int(sys.argv[1].strip("'").strip(" "))
modelUri = sys.argv[2].strip("'").strip(" ")
ssim = False
searchMatch = False
if sys.argv[3].strip("'").strip(" ") == 'True':
    ssim = True

if sys.argv[4].strip("'").strip(" ") == 'True':
    searchMatch = True

log = Logger(int(jobId), 'recClassify.py', 'worker')
log.write('script started')

if searchMatch:
    log.write('using search match')
else:
    if ssim:
        log.write('using ssim '+str(ssim)+str(sys.argv[3].strip("'").strip(" ")))
    else:
        log.write('not using ssim '+str(ssim))

configuration = EnvironmentConfig()
config = configuration.data()
log.write('configuration loaded')

models = {}
tempFolders = str(configuration.pathConfig['temp_dir'])
currDir = os.path.dirname(os.path.abspath(__file__))

log.write('trying database connection')
db = None
try:
    db = MySQLdb.connect(
        host=config[0], user=config[1], passwd=config[2], db=config[3])
except MySQLdb.Error as e:
    log.write('fatal error cannot connect to database.')
    quit()
log.write('database connection succesful')
bucketName = config[4]
awsKeyId = config[5]
awsKeySecret = config[6]
log.write('tring connection to bucket')

start_time = time.time()

conn = S3Connection(awsKeyId, awsKeySecret)

try:
    bucket = conn.get_bucket(bucketName)
except Exception, ex:
    log.write('fatal error cannot connect to bucket ')
    with closing(db.cursor()) as cursor:
        cursor.execute("""
            UPDATE `jobs` set `remarks` = %s
            WHERE `job_id` = %
        """, ["Error: connecting to bucket.", jobId])
        db.commit()
    quit()
log.write('connect to bucket  succesful')

log.write('bucket config took:'+str(time.time()-start_time))

tempFolder = tempFolders+"/classification_"+str(jobId)+"/"
modelLocal = tempFolder+'model.mod'
log.write('fetching model from bucket ('+modelUri+') to ('+modelLocal+')')
start_time = time.time()

key = bucket.get_key(modelUri)
key.get_contents_to_filename(modelLocal)
mod = None
if os.path.isfile(modelLocal):
    mod = pickle.load(open(modelLocal, "rb"))
    log.write('model was loaded to memory')
else:
    log.write('fatal error cannot load model')
    quit()
log.write('model retrieve took:'+str(time.time()-start_time))

linesProcessed = 0
missedRecs = 0
# reads lines from stdin
log.write(
    'start processing cycle. configuration took:' +
    str(time.time()-start_time_all))
# for line in sys.stdin:


def processLine(line, bucket, mod, config, logWorkers, bucketNam, ssimFlag):
    global jobId
    start_time_all = time.time()
    log = Logger(int(jobId), 'recClassify.py', 'worker-thread', logWorkers)

    log.write('worker-thread started')

    try:
        db = MySQLdb.connect(
            host=config[0], user=config[1], passwd=config[2], db=config[3]
        )
    except MySQLdb.Error as e:
        log.write('fatal error cannot connect to database.')
        return 0

    # remove white space
    line = line.strip(' ')
    line = line.strip('\n')

    # split the line into variables
    recUri, modelUri, recId, jobId, species, songtype = line.split(',')
    recId = int(recId.strip())
    log.write('new subprocess:'+recUri)
    tempFolders = str(configuration.pathConfig['temp_dir'])
    tempFolder = tempFolders+"/classification_"+str(jobId)+"/"

    # get rec from URI and compute feature vector using the spec vocalization
    start_time = time.time()
    log.write(str(type(bucket)))

    recAnalized = Recanalizer(
        recUri,
        mod[1],
        float(mod[2]),
        float(mod[3]),
        tempFolder,
        str(bucketNam),
        log,
        False,
        ssimFlag,
        searchMatch
    )

    log.time_delta("recAnalized", start_time)
    with closing(db.cursor()) as cursor:
        cursor.execute("""
            UPDATE `jobs`
            SET `progress` = `progress` + 1 ,last_update = now()
            WHERE `job_id` = %s
        """, [jobId])
        db.commit()

    if recAnalized.status == 'Processed':
        log.write('rec processed')
        noErrorFlag = True
        fets = None
        try:
            fets = recAnalized.features()
        except:
            log.write('error predicting on recording: '+recUri)
            with closing(db.cursor()) as cursor:
                cursor.execute("""
                    INSERT INTO `recordings_errors`
                        (`recording_id`, `job_id`)
                    VALUES (%s, %s)
                """, [recId, jobId])
                db.commit()
            noErrorFlag = False
        if noErrorFlag:
            featvector = recAnalized.getVector()
            recName = recUri.split('/')
            recName = recName[len(recName)-1]
            vectorLocal = tempFolder+recName+'.vector'
            start_time = time.time()
            myfileWrite = open(vectorLocal, 'wb')
            wr = csv.writer(myfileWrite)
            wr.writerow(featvector)
            myfileWrite.close()
            log.time_delta("wrote vector file", start_time)
            if not os.path.isfile(vectorLocal):
                log.write('error writing: '+vectorLocal)
                with closing(db.cursor()) as cursor:
                    cursor.execute("""
                        INSERT INTO `recordings_errors`(`recording_id`, `job_id`)
                        VALUES (%s, %s)
                    """, [recId, jobId])
                    db.commit()
                log.time_delta("function exec", start_time_all)
                return 0
            else:
                start_time = time.time()
                vectorUri = '{}/classification_{}_{}.vector'.format(
                    modelUri.replace('.mod', ''), jobId, recName
                )
                log.write(str(type(bucket)))
                k = bucket.new_key(vectorUri)
                k.set_contents_from_filename(vectorLocal)
                k.set_acl('public-read')
                if noErrorFlag:
                    clf = mod[0]
                    log.time_delta("uploaded vector file", start_time)
                    start_time = time.time()
                    try:
                        res = clf.predict([
                            float(fets[0]),
                            float(fets[1]),
                            float(fets[2]),
                            float(fets[3]),
                            float(fets[4]),
                            float(fets[5])
                        ])
                    except:
                        log.write('error predicting on recording: '+recUri)
                        with closing(db.cursor()) as cursor:
                            cursor.execute("""
                                INSERT INTO `recordings_errors`
                                    (`recording_id`, `job_id`)
                                VALUES (%s, %s)
                            """, [recId, jobId])
                            db.commit()
                        noErrorFlag = False
                    log.time_delta("prediction", start_time)
                if noErrorFlag:
                    print recId, ";", res[0], ";", jobId, ";", species, ";",
                    print songtype, ";", min(featvector), ";", max(featvector)
                    sys.stdout.flush()
                    log.time_delta("function exec", start_time_all)
                    return 1
                else:
                    log.write('error clf.predict(fets) failed')
                    insert_rec_error(db, recId, jobId)
                    log.time_delta("function exec", start_time_all)
                    return 0
        else:
            log.write('error recAnalized.features failed')
            insert_rec_error(db, recId, jobId)
            log.time_delta("function exec", start_time_all)
            return 0
    else:
        log.write('error processing recording: '+recUri)
        log.time_delta("function exec", start_time_all)
        insert_rec_error(db, recId, jobId)
        return 0


def insert_rec_error(db, recId, jobId):
    with closing(db.cursor()) as cursor:
        cursor.execute("""
            INSERT INTO `recordings_errors`(`recording_id`, `job_id`)
            VALUES (%s, %s)
        """, [recId, jobId])
        db.commit()


resultsParallel = Parallel(n_jobs=num_cores)(
    delayed(processLine)(line, bucket, mod, config, logWorkers, bucketName, ssim)
    for line in sys.stdin
)
log.write('this worker processed '+str(sum(resultsParallel))+' recordings')
log.write('end processing cycle')
log.close()

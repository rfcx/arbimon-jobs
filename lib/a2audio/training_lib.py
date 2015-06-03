import MySQLdb
from a2audio.roizer import Roizer
from contextlib import closing
import boto.s3.connection
from a2audio.recanalizer import Recanalizer
import csv
from a2pyutils.logger import Logger
import os
import shutil


def cancelStatus(db,jobId,rmFolder=None,quitj=True):
    status = None
    with closing(db.cursor()) as cursor:
        cursor.execute('select `cancel_requested` from`jobs`  where `job_id` = '+str(jobId))
        db.commit()
        status = cursor.fetchone()
        if status:
            if 'cancel_requested' in status:
                status = status['cancel_requested']
            else:
                status  = status[0]
        else:
            return False
        if status and int(status) > 0:
            cursor.execute('update `jobs` set `state`="canceled" where `job_id` = '+str(jobId))
            db.commit()
            print 'job canceled'
            if rmFolder:
                if os.path.exists(rmFolder):
                    shutil.rmtree(rmFolder)
            if quitj:
                quit()
            else:
                return True
        else:
            return False
        
def roigen(line,config,tempFolder,currDir ,jobId,useSsim,bIndex):
    jobId = int(jobId)
    log = Logger(jobId, 'training.py', 'roigen')
    log.also_print = True
    db = MySQLdb.connect(host=config[0], user=config[1], passwd=config[2],db=config[3])
    if len(line) < 8:
        db.close()
        log.write("roigen: not enough params")
        return 'err'
    cancelStatus(db,jobId,tempFolder)
    recId = int(line[0])
    roispeciesId = int(line[1])
    roisongtypeId= int(line[2])
    initTime = float(line[3])
    endingTime = float(line[4])
    lowFreq = float(line[5])
    highFreq = float(line[6])
    recuri = line[7]
    log.write("roigen: processing "+recuri)
    log.write("roigen: cutting at "+str(initTime)+" to "+str(endingTime)+ " and filtering from "+str(lowFreq)+" to " + str(highFreq))
    roi = Roizer(recuri,tempFolder,str(config[4]),initTime,endingTime,lowFreq,highFreq,log,useSsim,bIndex)
    with closing(db.cursor()) as cursor:
        cursor.execute('update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = '+str(jobId))
        db.commit()
    if "NoAudio" in roi.status:
        log.write("roigen: no audio err " + str(recuri))
        with closing(db.cursor()) as cursor:
            cursor.execute('INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES ('+str(recId)+','+str(jobId)+') ')
            db.commit()
        db.close()
        return 'err'
    else:
        log.write("roigen: done")
        db.close()
        return [roi,str(roispeciesId)+"_"+str(roisongtypeId)]

def insertRecError(db,jobId,recId):
    with closing(db.cursor()) as cursor:
        cursor.execute('INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES ('+str(recId)+','+str(jobId)+') ')
        db.commit()
    db.close()
    db = None
    
def recnilize(line,config,workingFolder,currDir,jobId,pattern,useSsim,useRansac,log=None,bIndex=0):
    if log:
        log.write('analyzing one recording')
    if len(config) < 7:
        log.write('error analyzing: config is wrong')
        return 'err'
    recId = int(line[5])
    bucketName = config[4]
    awsKeyId = config[5]
    awsKeySecret = config[6]
    db = None
    conn = None
    bucket = None
    #try:
    db = MySQLdb.connect(host=config[0], user=config[1], passwd=config[2],db=config[3])
    conn = boto.s3.connection.S3Connection(awsKeyId, awsKeySecret)
    bucket = conn.get_bucket(bucketName)
    #except:
        #log.write('error analyzing: db or conn are wrong')
        #return 'err'
    with closing(db.cursor()) as cursor:
        cursor.execute('update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = '+str(jobId))
        db.commit()
    pid = None
    cancelStatus(db,jobId,workingFolder)
    with closing(db.cursor()) as cursor:
        cursor.execute('SELECT `project_id` FROM `jobs` WHERE `job_id` =  '+str(jobId))
        db.commit()
        rowpid = cursor.fetchone()
        try:
            pid = rowpid[0]
        except:
            pid = None
    if pid is None:
        insertRecError(db,jobId,recId)
        log.write('error analyzing: pid is wrong')
        return 'err'
    bucketBase = 'project_'+str(pid)+'/training_vectors/job_'+str(jobId)+'/'
    recAnalized = None
   # try:
    recAnalized = Recanalizer(line[0] , pattern[0] ,pattern[2] , pattern[3] ,workingFolder,str(bucketName),log,False,useSsim,step=16,oldModel =False,numsoffeats=41,ransakit=useRansac,bIndex=bIndex)
    #except:
        #log.write('error analyzing: Recanalizer is wrong')
        #insertRecError(db,jobId,recId)
        #return 'err'
    if recAnalized.status == 'Processed':
        recName = line[0].split('/')
        recName = recName[len(recName)-1]
        vectorUri = bucketBase+recName 
        fets = recAnalized.features()
        vector = recAnalized.getVector()
        vectorFile = workingFolder+recName
        myfileWrite = open(vectorFile, 'wb')
        wr = csv.writer(myfileWrite)
        wr.writerow(vector)
        myfileWrite.close()       
        k = bucket.new_key(vectorUri)
        k.set_contents_from_filename(vectorFile)
        k.set_acl('public-read')
        infos = []
        infos.append(line[4])
        infos.append(line[3])
        infos.append(pattern[4])
        infos.append(pattern[2])
        infos.append(pattern[3])
        infos.append(pattern[1])
        infos.append(line[0])
        db.close()
        return {"fets":fets,"info":infos}
    else:
        log.write('error analyzing: recording cannot be analized. status: '+str(recAnalized.status))
        insertRecError(db,jobId,recId)
        log.write(line[0])
        return 'err'

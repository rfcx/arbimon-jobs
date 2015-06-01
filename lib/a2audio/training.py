import MySQLdb
from a2audio.roizer import Roizer
from contextlib import closing
from boto.s3.connection import S3Connection
from a2audio.recanalizer import Recanalizer
import csv


def roigen(line, config, tempFolder, currDir, jobId):
    db = MySQLdb.connect(host=config[0], user=config[1], passwd=config[2],db=config[3])
    if len(line) < 8:
        db.close()
        return 'err'
    recId = int(line[0])
    roispeciesId = int(line[1])
    roisongtypeId= int(line[2])
    initTime = float(line[3])
    endingTime = float(line[4])
    lowFreq = float(line[5])
    highFreq = float(line[6])
    recuri = line[7]
    roi = Roizer(recuri,tempFolder,str(config[4]),initTime,endingTime,lowFreq,highFreq)
    
    with closing(db.cursor()) as cursor:
        cursor.execute('update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = '+str(jobId))
        db.commit()
        
    if "NoAudio" in roi.status:
        with closing(db.cursor()) as cursor:
            cursor.execute('INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES ('+str(recId)+','+str(jobId)+') ')
            db.commit()
        db.close()
        return 'err'
    else:            
        db.close()
        return [roi,str(roispeciesId)+"_"+str(roisongtypeId)]


def recnilize(line, config, workingFolder, currDir, jobId, pattern):
    bucketName = config[4]
    awsKeyId = config[5]
    awsKeySecret = config[6]
    db = MySQLdb.connect(host=config[0], user=config[1], passwd=config[2], db=config[3])
    conn = S3Connection(awsKeyId, awsKeySecret)
    bucket = conn.get_bucket(bucketName)
    pid = None
    with closing(db.cursor()) as cursor:
        cursor.execute('SELECT `project_id` FROM `jobs` WHERE `job_id` =  '+str(jobId))
        db.commit()
        rowpid = cursor.fetchone()
        pid = rowpid[0]
    if pid is None:
        return 'err project not found'
    bucketBase = 'project_'+str(pid)+'/training_vectors/job_'+str(jobId)+'/'
    recAnalized = Recanalizer(line[0], pattern[0], pattern[2], pattern[3], workingFolder, str(bucketName), None)
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
        fets.append(line[4])
        fets.append(line[3])
        fets.append(pattern[4])
        fets.append(pattern[2])
        fets.append(pattern[3])
        fets.append(pattern[1])
        fets.append(line[0])
        db.close()
        return fets
    else:
        db.close()
        return 'err ' + recAnalized.status

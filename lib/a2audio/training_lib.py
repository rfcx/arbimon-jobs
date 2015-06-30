import MySQLdb
from a2audio.roizer import Roizer
from contextlib import closing
import boto.s3.connection
from a2audio.recanalizer import Recanalizer
import csv
from a2pyutils.logger import Logger
import os
import shutil
from a2pyutils.config import Config
from soundscape.set_visual_scale_lib import *
from classification_lib import create_temp_dir
import time
import multiprocessing
import csv
from a2pyutils.jobs_lib import cancelStatus
import numpy

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
    try:
        db = MySQLdb.connect(host=config[0], user=config[1], passwd=config[2],db=config[3])
        conn = boto.s3.connection.S3Connection(awsKeyId, awsKeySecret)
        bucket = conn.get_bucket(bucketName)
    except:
        log.write('error analyzing: db or conn are wrong')
        return 'err'
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
    try:
        recAnalized = Recanalizer(line[0] , pattern[0] ,pattern[2] , pattern[3] ,workingFolder,str(bucketName),log,False,useSsim,step=16,oldModel =False,numsoffeats=41,ransakit=useRansac,bIndex=bIndex)
    except:
        log.write('error analyzing: Recanalizer is wrong')
        insertRecError(db,jobId,recId)
        return 'err'
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
        db.close()
        return 'err'

def get_training_job_data(db,jobId):
    try:
        with closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT J.`project_id`, J.`user_id`,
                    JP.model_type_id, JP.training_set_id,
                    JP.validation_set_id, JP.trained_model_id,
                    JP.use_in_training_present,
                    JP.use_in_training_notpresent,
                    JP.use_in_validation_present,
                    JP.use_in_validation_notpresent,
                    JP.name,
                    MT.usesSsim,
                    J.ncpu,
                    MT.usesRansac
                FROM `jobs` J
                JOIN `job_params_training` JP ON JP.job_id = J.job_id , `model_types` MT
                WHERE J.`job_id` = %s and MT.`model_type_id` =  JP.`model_type_id`
            """, [jobId])
            row = cursor.fetchone()
    except:
        exit_error("Could not query database with training job #{}".format(jobId))
    if not row:
        exit_error("Could not find training job #{}".format(jobId))
        
    return  [row['project_id'],
             row['user_id'],
             row['model_type_id'],
             row['training_set_id'],
             row['validation_set_id'],
             row['trained_model_id'],
             row['use_in_training_present'],
             row['use_in_training_notpresent'],
             row['use_in_validation_present'],
             row['use_in_validation_notpresent'],
             row['name'],
             row['usesSsim'],
             row['ncpu'],
             row['usesRansac']
            ]

def get_job_model_type(db,jobId):
    try:
        with closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT JP.model_type_id
                FROM `jobs` J
                JOIN `job_params_training` JP ON JP.job_id = J.job_id , `model_types` MT
                WHERE J.`job_id` = %s
            """, [jobId])
            row = cursor.fetchone()
    except:
        exit_error("Could not query database with training job #{}".format(jobId))
    if not row:
        exit_error("Could not find training job #{}".format(jobId))
        
    return int(row['model_type_id'])

def get_training_recordings(jobId,training_set_id,workingFolder,log,config):
    db = get_db(config,cursor=False)
    trainingData = []
    """ Training data file creation """
    try:
        with closing(db.cursor()) as cursor:
            # create training file
            cursor.execute("""
                SELECT r.`recording_id`, ts.`species_id`, ts.`songtype_id`,
                    ts.`x1`, ts.`x2`, ts.`y1`, ts.`y2`, r.`uri`
                FROM `training_set_roi_set_data` ts, `recordings` r
                WHERE r.`recording_id` = ts.`recording_id`
                  AND ts.`training_set_id` = %s
            """, [training_set_id])
            db.commit()
            trainingFileName = os.path.join(
                workingFolder,
                'training_{}_{}.csv'.format(jobId, training_set_id)
            )
            # write training file to temporary folder
            banwds = []
            with open(trainingFileName, 'wb') as csvfile:
                spamwriter = csv.writer(csvfile, delimiter=',')
                numTrainingRows = int(cursor.rowcount)
                progress_steps = numTrainingRows
                for x in range(0, numTrainingRows):
                    rowTraining = cursor.fetchone()
                    banwds.append(float(rowTraining[6])-float(rowTraining[5]))
                    trainingData.append(rowTraining)
                    spamwriter.writerow(rowTraining[0:7+1] + (jobId,))
            meanBand = numpy.mean(banwds)
            maxBand = numpy.max(banwds)
            cursor.execute("""
                SELECT DISTINCT `recording_id`
                FROM `training_set_roi_set_data`
                where `training_set_id` = %s
            """, [training_set_id])
            db.commit()
    
            numrecordingsIds = int(cursor.rowcount)
            recordingsIds = []
            for x in range(0, numrecordingsIds):
                rowRec = cursor.fetchone()
                recordingsIds.append(rowRec[0])
    
            cursor.execute("""
                SELECT DISTINCT `species_id`, `songtype_id`
                FROM `training_set_roi_set_data`
                WHERE `training_set_id` = %s
            """, [training_set_id])
            db.commit()
    
            numSpeciesSongtype = int(cursor.rowcount)
            speciesSongtype = []
            for x in range(0, numSpeciesSongtype):
                rowSpecies = cursor.fetchone()
                speciesSongtype.append([rowSpecies[0], rowSpecies[1]])
    except:
        exit_error('cannot create training csvs files or access training data from db',-1,log)
        
    cancelStatus(db,jobId,workingFolder)
    
    db.close()
    
    return trainingData

def train_pattern_matching(db,jobId,log,config):
    (
        project_id, user_id,
        model_type_id, training_set_id,
        validation_set_id, trained_model_id,
        use_in_training_present,
        use_in_training_notpresent,
        use_in_validation_present,
        use_in_validation_notpresent,
        name,
        ssim_flag,
        ncpu,
        ransac_flag
    ) = get_training_job_data(db,jobId)
    num_cores = multiprocessing.cpu_count()
    if int(ncpu) > 0:
        num_cores = int(ncpu)
    progress_steps = 0
    workingFolder = create_temp_dir(jobId,log)
    
    cancelStatus(db,jobId,workingFolder)
    
    training_recordings = get_training_recordings(jobId,training_set_id,workingFolder,log,config)
    
    cancelStatus(db,jobId,workingFolder)
    
def run_training(jobId):
    try:
        retValue = False
        start_time = time.time()   
        log = Logger(jobId, 'training.py', 'main')
        log.also_print = True    
        configuration = Config()
        config = configuration.data()
        bucketName = config[4]
        db = get_db(config)
        log.write('database connection succesful')
        model_type_id = get_job_model_type(db,jobId)
        log.write('job data fetched.')
    except:
        return False
    if model_type_id in [1,2,3]:
        log.write("Pattern Matching (modified Alvarez thesis)")
        retValue = train_pattern_matching(db,jobId,log,config)
        db.close()
        return retValue
    elif model_type_id in [4,5,6,7,8,9]:
        pass
        """Entry point for new model types"""
    else:
        log.write("Unkown model type")
        db.close()
        return False

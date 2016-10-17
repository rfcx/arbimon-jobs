from a2pyutils.logger import Logger
from a2pyutils.config import EnvironmentConfig
from a2audio.recanalizer import Recanalizer
from a2pyutils.jobs_lib import cancelStatus
from soundscape.set_visual_scale_lib import *
import time
import MySQLdb
import contextlib
import tempfile
import shutil
import os
import multiprocessing
from joblib import Parallel, delayed
import cPickle as pickle
import csv
import json
import sys

classificationCanceled =False

def get_classification_job_data(db,jobId):
    try:
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT J.`project_id`, J.`user_id`,
                    JP.model_id, JP.playlist_id,
                    JP.name , J.ncpu
                FROM `jobs` J
                JOIN `job_params_classification` JP ON JP.job_id = J.job_id
                WHERE J.`job_id` = %s
            """, [jobId])
            row = cursor.fetchone()
    except:
        exit_error("Could not query database with classification job #{}".format(jobId))
    if not row:
        exit_error("Could not find classification job #{}".format(jobId))
    return [row['model_id'],row['project_id'],row['user_id'],row['name'],row['playlist_id'],row['ncpu']]

def get_model_params(db,classifierId,log):
    try:
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT m.`model_type_id`,m.`uri`,ts.`species_id`,ts.`songtype_id`
                FROM `models`m ,`training_sets_roi_set` ts
                WHERE m.`training_set_id` = ts.`training_set_id`
                  AND `model_id` = %s
            """, [classifierId])
            db.commit()
            numrows = int(cursor.rowcount)
            if numrows < 1:
                exit_error('fatal error cannot fetch model params (classifier_id:' + str(classifierId) + ')',-1,log)
            row = cursor.fetchone()
    except:
        exit_error("Could not query database for model params")    
    return [row['model_type_id'],row['uri'],row['species_id'],row['songtype_id']]

def create_temp_dir(jobId,log):
    try:
        tempFolders = tempfile.gettempdir()
        workingFolder = tempFolders+"/job_"+str(jobId)+'/'
        if os.path.exists(workingFolder):
            shutil.rmtree(workingFolder)
        os.makedirs(workingFolder)
    except:
        exit_error("Could not create temporary directory")
    if not os.path.exists(workingFolder):
        exit_error('fatal error creating directory',-1,log)
    return workingFolder

def get_playlist(db,playlistId,log):
    try:
        recsToClassify = []
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                SELECT R.`recording_id`, R.`uri`
                FROM `recordings` R, `playlist_recordings` PR
                WHERE R.`recording_id` = PR.`recording_id`
                  AND PR.`playlist_id` = %s
            """, [playlistId])
            db.commit()
            numrows = int(cursor.rowcount)
            for x in range(0, numrows):
               rowclassification = cursor.fetchone()
               recsToClassify.append(rowclassification)
    except:
        exit_error("Could not generate playlist array")
    if len(recsToClassify) < 1:
        exit_error('No recordngs in playlist',-1,log)
    return recsToClassify

def set_progress_params(db,progress_steps, jobId):
    try:
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                UPDATE `jobs`
                SET `progress_steps`=%s, progress=0, state="processing"
                WHERE `job_id` = %s
            """, [progress_steps*2+5, jobId])
            db.commit()
    except:
        exit_error("Could not set progress params")
        
def insert_rec_error(db, recId, jobId):
    try:
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                INSERT INTO `recordings_errors`(`recording_id`, `job_id`)
                VALUES (%s, %s)
            """, [recId, jobId])
            db.commit()
    except:
        exit_error("Could not insert recording error")
        

def classify_rec(rec,mod,workingFolder,log,config,jobId):
    global classificationCanceled
    if classificationCanceled:
        return None
    errorProcessing = False
    db = get_db(config)
    if cancelStatus(db,jobId,workingFolder,False):
        classificationCanceled = True
        quit()
    recAnalized = None
    clfFeatsN = mod[0].n_features_
    log.write('classify_rec try')
    try:
        useSsim = True
        oldModel = False
        useRansac = False
        bIndex = 0
        if len(mod) > 7:
            bIndex  =  mod[7]
        if len(mod) > 6:
            useRansac =  mod[6]
        if len(mod) > 5:
            useSsim =  mod[5]
        else:
            oldModel = True
        recAnalized = Recanalizer(rec['uri'], mod[1], float(mod[2]), float(mod[3]), workingFolder,str(config[4]) ,log,False,useSsim )
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                UPDATE `jobs`
                SET `progress` = `progress` + 1
                WHERE `job_id` = %s
            """, [jobId])
            db.commit()       
    except:
        log.write('error rec analyzed')
        errorProcessing = True
    log.write('finish')
    featvector = None
    fets = None
    if recAnalized.status == 'Processed':
        try:
            featvector = recAnalized.getVector()
            fets = recAnalized.features()
        except:
            errorProcessing = True
    else:
        errorProcessing = True
    res = None
    log.write('FEATS COMPUTED')
    if featvector is not None:
        try:
            clf = mod[0]
            res = clf.predict(fets)
        except:
            errorProcessing = True
    else:
        errorProcessing = True
    if errorProcessing:
        insert_rec_error(db,rec['recording_id'],jobId)
        db.close()
        return None
    else:
        log.write('done processing this rec')
        db.close()
        return {'uri':rec['uri'],'id':rec['recording_id'],'f':featvector,'ft':fets,'r':res[0]}
        
def get_model(model_uri,config,log,workingFolder):
    log.write('reaching bucket.')
    modelLocal = workingFolder+'model.mod'
    bucket = get_bucket(config)
    try:
        log.write('getting aws file key...')
        k = bucket.get_key(model_uri, validate=False)
        log.write('contents to filename...')
        k.get_contents_to_filename(modelLocal)
    except:
        exit_error('fatal error model '+str(model_uri)+' not found in aws',-1,log)
    log.write('model in local file system.')
    mod = None
    log.write('loading model to memory...')
    if os.path.isfile(modelLocal):
        mod = pickle.load(open(modelLocal, "rb"))
    else:
        exit_error('fatal error cannot load model',-1,log)
    log.write('model was loaded to memory.')
    return mod

def write_vector(recUri,tempFolder,featvector):
    vectorLocal = None
    try:
        recName = recUri.split('/')
        recName = recName[len(recName)-1]
        vectorLocal = tempFolder+recName+'.vector'
        myfileWrite = open(vectorLocal, 'wb')
        wr = csv.writer(myfileWrite)
        wr.writerow(featvector)
        myfileWrite.close()
    except:
        return None
    return vectorLocal

def upload_vector(uri,filen,config,rid,db,jobId):
    try:
        bucket = get_bucket(config)
        k = bucket.new_key(uri)
        k.set_contents_from_filename(filen)
        k.set_acl('public-read')
        os.remove(filen)
    except:
        insert_rec_error(db, rid, jobId)

def insert_result_to_db(config,jId, recId, species, songtype, presence, maxV):
    db = None
    try:
        db = get_db(config)
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                INSERT INTO `classification_results` (
                    job_id, recording_id, species_id, songtype_id, present,
                    max_vector_value
                ) VALUES (%s, %s, %s, %s, %s,
                    %s
                )
            """, [jId, recId, species, songtype, presence, maxV])
            db.commit()
    except:
        insert_rec_error(db, recId, jobId)
    db.close()
        
def processResults(res,workingFolder,config,modelUri,jobId,species,songtype,db):
    minVectorVal = 9999999.0
    maxVectorVal = -9999999.0
    processed = 0
    try:
        for r in res:
            with contextlib.closing(db.cursor()) as cursor:
                cursor.execute("""
                    UPDATE `jobs`
                    SET `progress` = `progress` + 1
                    WHERE `job_id` = %s
                """, [jobId])
                db.commit()   
            if r and 'id' in r:
                processed = processed + 1
                recName = r['uri'].split('/')
                recName = recName[len(recName)-1]
                localFile = write_vector(r['uri'],workingFolder,r['f'])
                if localFile is not None:
                    maxv = max(r['f'])
                    minv = min(r['f'])
                    if minVectorVal > float(minv):
                        minVectorVal = minv
                    if maxVectorVal < float(maxv):
                        maxVectorVal = maxv
                    vectorUri = '{}/classification_{}_{}.vector'.format(
                            modelUri.replace('.mod', ''), jobId, recName
                    )
                    upload_vector(vectorUri,localFile,config,r['id'],db,jobId)
                    insert_result_to_db(config,jobId,r['id'], species, songtype,r['r'],maxv)
                else:
                    insert_rec_error(db, r['id'], jobId)
    except:
        exit_error('cannot process results.')
    return {"t":processed,"stats":{"minv": float(minVectorVal), "maxv": float(maxVectorVal)}}
   
def run_pattern_matching(jobId,model_uri,species,songtype,playlistId,log,config,ncpu):
    global classificationCanceled
    db = None
    try:
        db = get_db(config)
        num_cores = multiprocessing.cpu_count()
        if int(ncpu)>0:
            num_cores = int(ncpu)
        log.write('using Pattern Matching algorithm' )
        workingFolder = create_temp_dir(jobId,log)
        log.write('created working directory.')
        recsToClassify = get_playlist(db,playlistId,log)
        log.write('playlist generated.')
        cancelStatus(db,jobId,workingFolder)
        set_progress_params(db,len(recsToClassify), jobId)
        log.write('job progress set to start.')
        mod = get_model(model_uri,config,log,workingFolder)
        cancelStatus(db,jobId,workingFolder)
        log.write('model was fetched.')
    except:
        return False
    log.write('starting parallel for.')
    db.close()
    try:
        resultsParallel = Parallel(n_jobs=num_cores)(
            delayed(classify_rec)(rec,mod,workingFolder,log,config,jobId) for rec in recsToClassify
        )
    except:
        if classificationCanceled:
            log.write('job cancelled')
        return False
    log.write('done parallel execution.')
    db = get_db(config)
    cancelStatus(db,jobId,workingFolder)
    try:
        jsonStats = processResults(resultsParallel,workingFolder,config,model_uri,jobId,species,songtype,db)
    except:
        return False
    log.write('computed stats.')
    shutil.rmtree(workingFolder)
    log.write('removed folder.')
    statsJson = jsonStats['stats']
    if jsonStats['t'] < 1:
        exit_error('no recordings processed.')
    try:
        with contextlib.closing(db.cursor()) as cursor:
            cursor.execute("""
                INSERT INTO `classification_stats` (`job_id`, `json_stats`)
                VALUES (%s, %s)
            """, [jobId, json.dumps(statsJson)])
            db.commit()
            cursor.execute("""
                UPDATE `jobs`
                SET `progress` = `progress_steps`, `completed` = 1,
                    state="completed", `last_update` = now()
                WHERE `job_id` = %s
            """, [jobId])
            db.commit()
        db.close()
        return True
    except:
        db.close()
        return False
    
def run_classification(jobId):
    try:
        start_time = time.time()   
        log = Logger(jobId, 'classification.py', 'main')
        log.also_print = True    
        configuration = EnvironmentConfig()
        config = configuration.data()
        bucketName = config[4]
        db = get_db(config)
        log.write('database connection succesful')
        (
            classifierId, projectId, userId,
            classificationName, playlistId, ncpu   
        ) = get_classification_job_data(db,jobId)
        log.write('job data fetched.')
        model_type_id,model_uri,species,songtype = get_model_params(db,classifierId,log)
        log.write('model params fetched.')
        db.close()
    except:
        return False
    if model_type_id in [4]:
        retValue = run_pattern_matching(jobId,model_uri,species,songtype,playlistId,log,config,ncpu)
        return retValue
    elif model_type_id in [-1]:
        pass
        """Entry point for new model types"""
    else:
        log.write("Unkown model type")
        return False

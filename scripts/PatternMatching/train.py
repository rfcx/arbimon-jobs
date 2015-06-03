#! .env/bin/python

import time
import sys
import tempfile
import os
import csv
import subprocess
import boto
import shutil
import MySQLdb
import json
from boto.s3.connection import S3Connection
from contextlib import closing
from a2audio.training_lib import *
from a2audio.samplerates import band2index
from a2pyutils.config import Config
from a2pyutils.logger import Logger
import multiprocessing
from joblib import Parallel, delayed
from a2audio.roiset import Roiset
from a2audio.model import Model
import numpy
import png
from pylab import *
import cPickle as pickle

USAGE = """Runs a model training job.
{prog} job_id
    job_id - job id in database
""".format(prog=sys.argv[0])

if len(sys.argv) < 2:
    print USAGE
    sys.exit(-1)

jobId = int(sys.argv[1].strip("'"))
modelName = ''
project_id = -1
configuration = Config()
config = configuration.data()
log = Logger(jobId, 'train.py', 'main')
log.also_print = True

log.write('script started with job id:'+str(jobId))

try:
    db = MySQLdb.connect(
        host=config[0], user=config[1],
        passwd=config[2], db=config[3]
    )
except MySQLdb.Error as e:
    log.write("fatal error cannot connect to database.")
    sys.exit(-1)

def exit_error(db,workingFolder,log,jobId,msg):
    with closing(db.cursor()) as cursor:
        cursor.execute('update `jobs` set `remarks` = "Error: '+str(msg)+'" ,`state`="error", `progress` = `progress_steps` ,  `completed` = 1 , `last_update` = now() where `job_id` = '+str(jobId))
        db.commit() 
    log.write(msg)
    if os.path.exists(workingFolder):
        shutil.rmtree(workingFolder)
    sys.exit(-1)
        
currDir = os.path.dirname(os.path.abspath(__file__))
currPython = sys.executable

bucketName = config[4]
awsKeyId = config[5]
awsKeySecret = config[6]

sys.stdout.flush()

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

if not row:
    log.write("Could not find training job #{}".format(jobId))
    sys.exit(-1)

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
) = row
    
num_cores = multiprocessing.cpu_count()
if int(ncpu) > 0:
    num_cores = int(ncpu)

modelName = name
tempFolders = tempfile.gettempdir()
# select the model_type by its id
if model_type_id in [1,2,3]:
    """Pattern Matching (modified Alvarez thesis)"""
    useSsim = bool(int(ssim_flag))
    useRansac = ransac_flag
    if useRansac:
        log.write("Search and Pattern Matching (modified Alvarez thesis) with ssim")
    else:
        if useSsim:
            log.write("Pattern Matching (modified Alvarez thesis) with ssim")
        else:
            log.write("Pattern Matching (modified Alvarez thesis) without ssim")
    progress_steps = 0
    # creating a temporary folder
    workingFolder = tempFolders+"/training_"+str(jobId)+"/"
    if os.path.exists(workingFolder):
        shutil.rmtree(workingFolder)
    os.makedirs(workingFolder)
    if not os.path.exists(workingFolder):
        exit_error(db,workingFolder,log,jobId,'cannot create temporary directory')
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
        exit_error(db,workingFolder,log,jobId,'cannot create training csvs files or access training data from db')
        
    cancelStatus(db,jobId,workingFolder)
    
    modelFilesLocation = tempFolders+"/training_"+str(jobId)+"/"
    project_id = None
    user_id = None
    modelname = None
    valiId = None
    model_type_id = None	
    training_set_id = None
    useTrainingPresent = None
    useTrainingNotPresent = None
    useValidationPresent = None
    useValidationNotPresent = None
    """Get params from database"""
    
    
   # try:
    with closing(db.cursor()) as cursor:
           # save validation to DB

        cursor.execute("SELECT `project_id`,`user_id` FROM `jobs` WHERE `job_id` = "+str(jobId))
        db.commit()
        row = cursor.fetchone()
        project_id = row[0]	
        user_id = row[1] 	
        valiKey = 'project_{}/validations/job_{}.csv'.format(project_id, jobId)
        cursor.execute("SELECT * FROM `job_params_training` WHERE `job_id` = "+str(jobId))
        db.commit()
        row = cursor.fetchone()
        model_type_id = row[1]	
        training_set_id = row[2]
        useTrainingPresent = row[5]
        useTrainingNotPresent = row[6]
        useValidationPresent = row[7]
        useValidationNotPresent = row[8]                  
        modelname = row[9]
        progress_steps = progress_steps + 15
        with closing(db.cursor()) as cursor:
            cursor.execute("""
                INSERT INTO `validation_set`(
                    `validation_set_id`, `project_id`, `user_id`, `name`, `uri`,
                    `params`, `job_id`
                ) VALUES (
                    NULL, %s, %s, %s, %s, %s, %s
                )
            """, [
                project_id, user_id, modelName+" validation", valiKey,
                json.dumps({'name': modelName}),
                jobId
            ])
            db.commit()
            valiId = cursor.lastrowid
            cursor.execute("""
                UPDATE `job_params_training`
                SET `validation_set_id` = %s
                WHERE `job_id` = %s
            """, [cursor.lastrowid, jobId])
            db.commit()
                
    #except:
        #exit_error(db,workingFolder,log,jobId,'error querying database')

    cancelStatus(db,jobId,workingFolder)

    validationData = []
    """ Validation file creation """
    if (1):#try:
        validationFile = workingFolder+'/validation_'+str(jobId)+'.csv'
        with open(validationFile, 'wb') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',')
            for x in range(0, numSpeciesSongtype):
                spst = speciesSongtype[x]
                with closing(db.cursor()) as cursor:
                    cursor.execute("""
                        SELECT r.`uri` , `species_id` , `songtype_id` , `present` , r.`recording_id`
                        FROM `recording_validations` rv, `recordings` r
                        WHERE r.`recording_id` = rv.`recording_id`
                          AND rv.`project_id` = %s
                          AND `species_id` = %s
                          AND `songtype_id` = %s
                          AND present = 1
                          ORDER BY RAND()
                          LIMIT %s
                    """, [project_id, spst[0], spst[1] , (int(useTrainingPresent)+int(useValidationPresent))])
    
                    db.commit()
    
                    numValidationRows = int(cursor.rowcount)

                    progress_steps = progress_steps + numValidationRows
    
                    for x in range(0, numValidationRows):
                        rowValidation = cursor.fetchone()
                        cc = (str(rowValidation[1])+"_"+str(rowValidation[2]))
                        validationData.append([rowValidation[0] ,rowValidation[1] ,rowValidation[2] ,rowValidation[3] , cc ,rowValidation[4]])
                        spamwriter.writerow([rowValidation[0] ,rowValidation[1] ,rowValidation[2] ,rowValidation[3] , cc ,rowValidation[4]])
                        
                with closing(db.cursor()) as cursor:
                    cursor.execute("""
                        SELECT r.`uri` , `species_id` , `songtype_id` , `present` , r.`recording_id`
                        FROM `recording_validations` rv, `recordings` r
                        WHERE r.`recording_id` = rv.`recording_id`
                          AND rv.`project_id` = %s
                          AND `species_id` = %s
                          AND `songtype_id` = %s
                          AND present = 0
                          ORDER BY RAND()
                          LIMIT %s
                    """, [project_id, spst[0], spst[1] , (int(useTrainingNotPresent)+int(useValidationNotPresent))])
    
                    db.commit()
    
                    numValidationRows = int(cursor.rowcount)

                    progress_steps = progress_steps + numValidationRows

                    for x in range(0, numValidationRows):
                        rowValidation = cursor.fetchone()
                        cc = (str(rowValidation[1])+"_"+str(rowValidation[2]))
                        validationData.append([rowValidation[0] ,rowValidation[1] ,rowValidation[2] ,rowValidation[3] , cc ,rowValidation[4]])
                        spamwriter.writerow([rowValidation[0] ,rowValidation[1] ,rowValidation[2] ,rowValidation[3] , cc ,rowValidation[4]])
   
                    cursor.execute("""
                       UPDATE `jobs`
                       SET `progress_steps` = %s, progress=0, state="processing"
                       WHERE `job_id` = %s
                        """, [progress_steps, jobId])
                    db.commit()
                    
        # get Amazon S3 bucket
        conn = S3Connection(awsKeyId, awsKeySecret)
        bucket = conn.get_bucket(bucketName)

        # save validation file to bucket
        k = bucket.new_key(valiKey)
        k.set_contents_from_filename(validationFile)
    
    #except:
        #exit_error(db,workingFolder,log,jobId,'cannot create validation csvs files or access validation data from db')
    
    cancelStatus(db,jobId,workingFolder)
    
    if len(trainingData) == 0 :
        exit_error(db,workingFolder,log,jobId,'cannot create validation csvs files or access validation data from db')
 
    classes = {}
    
    bIndex = band2index(maxBand)
    log.write('Max bandwidth '+str(maxBand)+' index '+ str(bIndex))
    rois = None
    """Roigenerator"""
    try:
        #roigen defined in a2audio.training
        rois = Parallel(n_jobs=num_cores)(delayed(roigen)(line,config,workingFolder,currDir,jobId,useSsim,bIndex) for line in trainingData)
    except:
        exit_error(db,workingFolder,log,jobId,'roigenerator failed')
        
    cancelStatus(db,jobId,workingFolder)
    
    if rois is None or len(rois) == 0 :
        exit_error(db,workingFolder,log,jobId,'cannot create rois from recordings')
        
    patternSurfaces = {}    
    """Align rois"""
    try:
        for roi in rois:
            if 'err' not in roi:
                classid = roi[1]
                lowFreq = roi[0].lowF
                highFreq = roi[0].highF
                sample_rate = roi[0].sample_rate
                spec = roi[0].spec
                rows = spec.shape[0]
                columns = spec.shape[1]
                if classid in classes:
                    classes[classid].addRoi(float(lowFreq),float(highFreq),float(sample_rate),spec,rows,columns)
                else:
                    logRoiset = Logger(jobId, 'train.py', 'roiset')
                    logRoiset.also_print = True
                    classes[classid] = Roiset(classid,float(sample_rate) ,logRoiset, (not useSsim))
                    classes[classid].addRoi(float(lowFreq),float(highFreq),float(sample_rate),spec,rows,columns)
        for i in classes:
            classes[i].alignSamples(bIndex)
            patternSurfaces[i] = [classes[i].getSurface(),classes[i].setSampleRate,classes[i].lowestFreq ,classes[i].highestFreq,classes[i].maxColumns]
    except:
            exit_error(db,workingFolder,log,jobId,'cannot align rois')
    cancelStatus(db,jobId,workingFolder)
    
    if len(patternSurfaces) == 0 :
        exit_error(db,workingFolder,log,jobId,'cannot create pattern surface from rois')
        
    results = None
    """Recnilize"""
    log.write("analizing recordings")
    
    try:
        results = Parallel(n_jobs=num_cores)(delayed(recnilize)(line,config,workingFolder,currDir,jobId,(patternSurfaces[line[4]]),useSsim,useRansac,log,bIndex) for line in validationData)
    except:
        exit_error(db,workingFolder,log,jobId,'cannot analize recordings in parallel')

    if results is None:
        exit_error(db,workingFolder,log,jobId,'cannot analize recordings')
    log.write("recs analized")
    cancelStatus(db,jobId,workingFolder)
    
    presentsCount = 0
    ausenceCount = 0
    c = 1
    for res in results:
        print c,':', res
        c = c  +1
        if 'err' not in res:
            if int(res['info'][1]) == 0:
                ausenceCount = ausenceCount + 1
            if int(res['info'][1]) == 1:
                presentsCount = presentsCount + 1            
            if presentsCount >= 2 and ausenceCount >= 2:
                break
            
    if presentsCount < 2 or ausenceCount < 2:
        exit_error(db,workingFolder,log,jobId,'not enough validations to create model')

    """Add samples to model"""
    models = {}
    try:
        for res in results:
            if 'err' not in res:
                classid = res['info'][0]
                if classid in models:
                    models[classid].addSample(res['info'][1],res['fets'],res['info'][6])
                else:
                    models[classid] = Model(classid,patternSurfaces[classid][0],jobId)
                    models[classid].addSample(res['info'][1],res['fets'],res['info'][6])
    except:
        exit_error(db,workingFolder,log,jobId,'cannot add samples to model')
    
    cancelStatus(db,jobId,workingFolder)

    if (useTrainingPresent+useValidationPresent) > presentsCount:
        if presentsCount <= useTrainingPresent:
            print 'presents if presentsCount <= useTrainingPresent ' , presentsCount ,"?", useTrainingPresent
            #useTrainingPresent = presentsCount - 1
            #useValidationPresent = 1
        else:
            print 'presents else presentsCount <= useTrainingPresent ' , presentsCount ,"?", useTrainingPresent
            #useValidationPresent = presentsCount - useTrainingPresent

    if (useTrainingNotPresent + useValidationNotPresent)  > ausenceCount:
        if ausenceCount <= useTrainingNotPresent:
            print 'ausence if ausenceCount <= useTrainingNotPresent' , ausenceCount ,"?", useTrainingNotPresent
            #useTrainingNotPresent = ausenceCount - 1
            #useValidationNotPresent = 1
        else:
            print 'ausence else ausenceCount <= useTrainingNotPresent' , ausenceCount ,"?", useTrainingNotPresent
            #useValidationNotPresent = ausenceCount  - useTrainingNotPresent

    savedModel = False
    log.write("creating model")
    """ Create and save model """
    for i in models:
        resultSplit = False
        try:
            resultSplit = models[i].splitData(useTrainingPresent,useTrainingNotPresent,useValidationPresent,useValidationNotPresent)
        except:
            exit_error(db,workingFolder,log,jobId,'error spliting data for validation')
        if not resultSplit:
            continue
        validationsKey =  'project_'+str(project_id)+'/validations/job_'+str(jobId)+'_vals.csv'
        validationsLocalFile = modelFilesLocation+'job_'+str(jobId)+'_vals.csv'
        try:
            models[i].train()
        except:
            exit_error(db,workingFolder,log,jobId,'error training model')

        if useValidationPresent > 0:
            try:
                models[i].validate()
                models[i].saveValidations(validationsLocalFile)
            except:
               exit_error(db,workingFolder,log,jobId,'error validating model')
               
        modFile = modelFilesLocation+"model_"+str(jobId)+"_"+str(i)+".mod"
        try:
            models[i].save(modFile,patternSurfaces[i][2] ,patternSurfaces[i][3],patternSurfaces[i][4],useSsim,useRansac,bIndex)
        except:
            exit_error(db,workingFolder,log,jobId,'error saving model file to local storage')
            
        modelStats = None
        try:
            modelStats = models[i].modelStats()
        except :
            exit_error(db,workingFolder,log,jobId,'cannot get stats from model')       
        pngKey = None
        try:       
            pngFilename = modelFilesLocation+'job_'+str(jobId)+'_'+str(i)+'.png'
            pngKey = 'project_'+str(project_id)+'/models/job_'+str(jobId)+'_'+str(i)+'.png'
            specToShow = numpy.zeros(shape=(0,int(modelStats[4].shape[1])))
            rowsInSpec = modelStats[4].shape[0]
            spec = numpy.copy(modelStats[4])
            if sum(spec == -10000)>0:
                spec[spec == -10000] = numpy.nan
            for j in range(0,rowsInSpec):
                if abs(numpy.nansum(spec[j,:])) > 0.0:
                    specToShow = numpy.vstack((specToShow,numpy.copy(spec[j,:])))
            if sum(numpy.isnan(specToShow))>0:
                specToShow[numpy.isnan(specToShow)] = numpy.nanmean(numpy.nanmean(specToShow))
            smin = min([min((specToShow[j])) for j in range(specToShow.shape[0])])
            smax = max([max((specToShow[j])) for j in range(specToShow.shape[0])])
            x = 255*(1-((specToShow - smin)/(smax-smin)))
            png.from_array(x, 'L;8').save(pngFilename)
        except:
            exit_error(db,workingFolder,log,jobId,'error creating pattern PNG')
        modKey = None
        
        cancelStatus(db,jobId,workingFolder)
        
        try:
            conn = S3Connection(awsKeyId, awsKeySecret)
            bucket = conn.get_bucket(bucketName)
            modKey = 'project_'+str(project_id)+'/models/job_'+str(jobId)+'_'+str(i)+'.mod'
            #save model file to bucket
            k = bucket.new_key(modKey)
            k.set_contents_from_filename(modFile)
            #save validations results to bucket
            k = bucket.new_key(validationsKey)
            k.set_contents_from_filename(validationsLocalFile)
            #save vocalization surface png to bucket
            k = bucket.new_key(pngKey)
            k.set_contents_from_filename(pngFilename)
            k.set_acl('public-read')
        except:
            exit_error(db,workingFolder,log,jobId,'error uploading files to amazon bucket')
            
        species,songtype = i.split("_")
        try:
            #save model to DB
            with closing(db.cursor()) as cursor:
                cursor.execute('update `jobs` set `state`="processing", `progress` = `progress` + 5 where `job_id` = '+str(jobId))
                db.commit()        
                cursor.execute("SELECT   max(ts.`x2` -  ts.`x1`) , min(ts.`y1`) , max(ts.`y2`) "+
                    "FROM `training_set_roi_set_data` ts "+
                    "WHERE  ts.`training_set_id` =  "+str(training_set_id))
                db.commit()
                row = cursor.fetchone()
                lengthRoi = row[0]	
                minFrequ = row[1]
                maxFrequ = row[2]
                
                cursor.execute("SELECT   count(*) "+
                    "FROM `training_set_roi_set_data` ts "+
                    "WHERE  ts.`training_set_id` =  "+str(training_set_id))
                db.commit()
                row = cursor.fetchone()
                totalRois = row[0]
                
                statsJson = '{"roicount":'+str(totalRois)+' , "roilength":'+str(lengthRoi)+' , "roilowfreq":'+str(minFrequ)+' , "roihighfreq":'+str(maxFrequ)
                statsJson = statsJson + ',"accuracy":'+str(modelStats[0])+' ,"precision":'+str(modelStats[1])+',"sensitivity":'+str(modelStats[2])
                statsJson = statsJson + ', "forestoobscore" :'+str(modelStats[3])+' , "roisamplerate" : '+str(patternSurfaces[i][1])+' , "roipng":"'+pngKey+'"'
                statsJson = statsJson + ', "specificity":'+str(modelStats[5])+' , "tp":'+str(modelStats[6])+' , "fp":'+str(modelStats[7])+' '
                statsJson = statsJson + ', "tn":'+str(modelStats[8])+' , "fn":'+str(modelStats[9])+' , "minv": '+str(modelStats[10])+', "maxv": '+str(modelStats[11])+'}'
            
                cursor.execute("INSERT INTO `models`(`name`, `model_type_id`, `uri`, `date_created`, `project_id`, `user_id`,"+
                               " `training_set_id`, `validation_set_id`) " +
                               " VALUES ('"+modelname+"', "+str(model_type_id)+" , '"+modKey+"' , now() , "+str(project_id)+","+
                               str(user_id)+" ,"+str(training_set_id)+", "+str(valiId)+" )")
                db.commit()
                insertmodelId = cursor.lastrowid
                
                cursor.execute("INSERT INTO `model_stats`(`model_id`, `json_stats`) VALUES ("+str(insertmodelId)+",'"+statsJson+"')")
                db.commit()
                
                cursor.execute("INSERT INTO `model_classes`(`model_id`, `species_id`, `songtype_id`) VALUES ("+str(insertmodelId)
                               +","+str(species)+","+str(songtype)+")")
                db.commit()       
                
                cursor.execute('update `job_params_training` set `trained_model_id` = '+str(insertmodelId)+' where `job_id` = '+str(jobId))
                db.commit()
                
                cursor.execute('update `jobs` set `last_update` = now() where `job_id` = '+str(jobId))
                db.commit()
                cursor.execute('update `jobs` set `state`="completed", `progress` = `progress_steps` ,  `completed` = 1 , `last_update` = now() where `job_id` = '+str(jobId))
                db.commit()
                savedModel  = True
        except:
            exit_error(db,workingFolder,log,jobId,'error saving model into database')
            
    if savedModel :
        log.write("model saved")
    else:
        exit_error(db,workingFolder,log,jobId,'error saving model')
    shutil.rmtree(tempFolders+"/training_"+str(jobId))
else:
    log.write("Unkown model type requested")

with closing(db.cursor()) as cursor:
    cursor.execute("""
        UPDATE `jobs`
        SET `last_update`=now()
        WHERE `job_id` = %s
    """, [jobId])
    db.commit()

db.close()
log.write("script ended")

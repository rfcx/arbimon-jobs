import os
from contextlib import closing
import shutil
from soundscape.set_visual_scale_lib import exit_error
from boto.s3.connection import S3Connection
import a2pyutils.storage

def  get_model_type():
    pass

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

def upload_files_2storage(storage, files,log,jobId,db,workingFolder):
    log.write('starting storage upload')
        
    try:
        for k in files:
            fileu = files[k]
            storage.put_file_path(fileu['key'], fileu['file'], acl='public-read' if fileu['public'] else None)
    except a2pyutils.storage.StorageError as se:
        exit_error('error uploading files to storage. '+se.message,-1,log,jobId,db,workingFolder)
    log.write('files uploaded to storage')

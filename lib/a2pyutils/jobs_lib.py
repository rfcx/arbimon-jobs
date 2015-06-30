import os
from contextlib import closing
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
        
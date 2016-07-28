#! .env/bin/python

import sys
from a2pyutils.logger import Logger
from a2pyutils.config import EnvironmentConfig
import a2audio.audio_event_detection_lib

USAGE = """Runs a audio event detection job.
{prog} job_id
    job_id - job id in database
""".format(prog=sys.argv[0])

def main(argv):
    if len(argv) < 2:
        print USAGE
        sys.exit()
    else:
        job_id = int(str(argv[1]).strip("'"))
        logger = Logger(job_id, 'audio_event_detection.py', 'main')
        logger.also_print = True    
        configuration = EnvironmentConfig()
        
        job = a2audio.audio_event_detection_lib.AudioEventDetectionJob(job_id, logger, configuration)

        retVal = job.run()
        if retVal:
            print 'end', retVal
        else:
            print 'err'

if __name__ == '__main__':
    main(sys.argv)

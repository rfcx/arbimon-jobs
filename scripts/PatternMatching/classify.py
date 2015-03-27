#! .env/bin/python

import sys
from a2audio.classification_lib import run_classification

USAGE = """Runs a classification job.
{prog} job_id
    job_id - job id in database
""".format(prog=sys.argv[0])

def main(argv):
    if len(argv) < 2:
        print USAGE
        sys.exit()
    else:
        jobId = int(sys.argv[1].strip("'"))
        retVal = run_classification(jobId)
        if retVal:
            print 'end'
        else:
            print 'err'

if __name__ == '__main__':
    main(sys.argv)


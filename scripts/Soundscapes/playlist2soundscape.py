#! .env/bin/python
import sys
from soundscape.soundscape_utils import run_soundscape

USAGE = """
{prog} job_id
    job_id - job id in database
""".format(prog=sys.argv[0])


def main(argv):
    if len(argv) < 2:
        print USAGE
        sys.exit(-1)
    else:
        job_id = int(sys.argv[1].strip("'"))
        run_soundscape(job_id)
        print 'end'

if __name__ == '__main__':
    main(sys.argv)

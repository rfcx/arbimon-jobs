#! .env/bin/python

"""
task_runner.py
Server for running job tasks.
"""

import sys
import a2.runtime.inject
import a2.job.taskrunner

USAGE="{} task_id"

def main(taskId):
    completed, result = a2.job.taskrunner.execute_task(taskId)
    print "Task completed : ", completed
    print "Result : ", result
    
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print USAGE.format(sys.argv)
    main(sys.argv[1])

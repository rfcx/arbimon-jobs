"""
TaskRunner class
"""

import multiprocessing
import multiprocessing.pool
import traceback
import tasks

class TaskRunner(object):
    "Class for handling the running of tasks"
    def __init__(self, config, max_concurrency):
        self.max_concurrency = max_concurrency if max_concurrency else multiprocessing.cpu_count()
        self.config = config
        self.tasks = []
        self.pool = multiprocessing.pool.Pool(
            self.max_concurrency
        )
        self.reporter_uri = None

    def run(self, task, step):
        
        if len(self.tasks) >= self.max_concurrency:
            raise AtMaximumConcurrencyError()

        def resolve(arg):
            print "resolved :: ", (task, step), arg
            for i, t in reversed(list(enumerate(self.tasks))):
                if t[0] == task and t[1] == step:
                    del self.tasks[i]
            
        self.tasks.append((task, step))
        self.pool.apply_async(execute_task, (task, step), callback=resolve)
        
        return {
            "task": task,
            "step": step
        }
        
class TaskRunnerError(StandardError):
    pass

class AtMaximumConcurrencyError(TaskRunnerError):
    pass    

def execute_task(task, step):
    try:
        print "Executing ze task...", task, step
        return True, sample_task()
    except Exception:
        return False, traceback.format_exc()

def sample_task():
    import time
    import random
    import os
    
    pid = os.getpid()
    delay = int(random.uniform(1, 10))
    a = random.uniform(1, 10)
    b = random.uniform(1, 10)
    
    print "{} :: sleeping for {}s".format(pid, delay)
    time.sleep(delay)
    
    return a + b
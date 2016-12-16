"""
    Tasks base class module.
"""

import json
import os.path
import a2.runtime as runtime
import a2.util.memoize

class Task(object):
    "Tasks base class"
    
    byType={}
    
    def __init__(self, taskId):
        self.taskId = taskId
        self.args = None
        
    def run(self):
        pass
        
    def get_args(self):
        if self.args:
            return self.args
        args = runtime.db.queryOne("""
            SELECT JT.args
            FROM job_tasks JT
            WHERE JT.task_id = %s
        """, [self.taskId])
        self.args = json.loads(args['args']) if args else None

    def get_job_id(self):
        return self.get_job_data()['job_id']

    def get_project_id(self):
        return self.get_job_data()['project_id']

    @a2.util.memoize.noargs
    def get_job_data(self):
        job = runtime.db.queryOne("""
            SELECT JT.job_id, J.project_id
            FROM job_tasks JT
            JOIN jobs J ON J.job_id = JT.job_id
            WHERE JT.task_id = %s
        """, [self.taskId])
        return job['job_id']

    
    @staticmethod
    def fromTaskId(taskId):
        ttdef = runtime.db.queryOne("""
            SELECT JTT.identifier
            FROM job_tasks JT
            JOIN job_task_types JTT On JT.type_id = JTT.type_id
            WHERE JT.task_id = %s
        """, [taskId])
        print "ttdef", ttdef
        ttype = runtime.tags.get('task_type', ttdef['identifier']) if ttdef else None
        
        if not ttype:
            raise StandardError("task or task type not found.")
        
        return ttype(taskId)
        
    def set_status(self, status, exc):
        Task.markTaskAs(self.taskId, status, exc)

    @staticmethod
    def markTaskAs(taskId, status, exc):
        runtime.db.execute("""
            UPDATE job_tasks
            SET status=%s, remark=%s, timestamp=NOW()
            WHERE task_id = %s
        """, [
            status, exc, taskId
        ])
        
    def get_workspace_path(self, path=''):
        base_path = os.path.join(
            runtime.config.get_config().pathsConfig['efs_base'],
            str(self.get_job_id())
        )
        
        return os.path.join(base_path, path) if path else base_path
        
"""
    Tasks base class module.
"""

import a2.runtime as runtime

class Task(object):
    "Tasks base class"
    
    byType={}
    
    def __init__(self, taskId, step):
        self.taskId = taskId
        self.step = step
        
    def run(self):
        pass
    
    @staticmethod
    def fromTaskId(taskId, step):
        ttdef = runtime.db.execute("""
            SELECT TT.identifier
            FROM job_tasks JT
            JOIN job_task_types JTT On JT.type_id = JTT.type_id
            WHERE JT.task_id = %s
        """, [taskId])
        
        ttype = runtime.tags.get('task_type', ttdef[0].identifier) if len(ttdef) else None
        
        if not ttype:
            raise StandardError("task or task type not found.")
        
        return ttype(taskId, step)


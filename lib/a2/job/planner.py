import json

class JobPlanner(object):
    def __init__(self, jobId):
        self.jobId = jobId
        
    def plan(self):
        pass
    
    def addTask(self, cursor, step, typeId, dependencies=None, args=None):
        cursor.execute("""
            INSERT INTO job_tasks(job_id, step, type_id, dependency_counter, status, remark, timestamp, args)
            VALUES (%s, %s, %s, %s, 'waiting', NULL, NOW(), %s)
        """, [self.jobId, step, typeId, len(dependencies), json.dumps(args) if args else None])
        task_id = cursor.lastrowid
        
        for dependency in dependencies:
            cursor.execute("""
                INSERT INTO job_task_dependencies(task_id, dependency_id, satisfied)
                VALUES (%s, %s, 0)
            """, [task_id, dependency])

        return task_id
import json
import a2.runtime as runtime

JOB_PREPARE_WORKSPACE_TASK = 10
JOB_END_TASK = 9
SYNC_TASK = 8

class JobPlanner(object):
    def __init__(self, jobId):
        self.jobId = jobId
        
    def plan(self):
        pass
    
    def addTask(self, step, typeId, dependencies=None, args=None):
        task_id = runtime.db.insert("""
            INSERT INTO job_tasks(job_id, step, type_id, dependency_counter, status, remark, timestamp, args)
            VALUES (%s, %s, %s, %s, 'waiting', NULL, NOW(), %s)
        """, [self.jobId, step, typeId, len(dependencies), json.dumps(args) if args else None])

        self.addTaskDependencies([task_id], dependencies)

        return task_id
    
    def addSyncTask(self, step, dependencies):
        return self.addTask(step, SYNC_TASK, dependencies)
    
    def addJobEndTask(self, step, dependencies):
        return self.addTask(step, JOB_END_TASK, dependencies)
    
    def addPrepareWorkspaceTask(self, step, dependencies, folders=None):
        return self.addTask(step, JOB_PREPARE_WORKSPACE_TASK, dependencies, folders)
    
    def addTaskDependency(self, task_id, dependency_id):
        self.addTaskDependencies([task_id], [dependency_id])
    
    def addTaskDependencies(self, task_ids, dependency_ids):
        for task_id in task_ids:
            for dependency_id in dependency_ids:
                runtime.db.insert("""
                    INSERT INTO job_task_dependencies(task_id, dependency_id, satisfied)
                    VALUES (%s, %s, 0)
                """, [task_id, dependency_id])

    def deleteStepsHigherThan(self, step):
        runtime.db.execute("""
            DELETE FROM job_tasks 
            WHERE job_id = %s and step > %
        """, [self.jobId, step])


    def makeWorkspace(self, subdirs):
        base_path = os.path.join(runtime.config.pathsConfig['efs_base'], 'jobs', self.jobId)
        

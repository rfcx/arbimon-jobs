import tasks
import a2.runtime as runtime


@runtime.tags.tag('task_type', 'job.plan')
class PlanJobTask(tasks.Task):
    def run(self):
        print "plan task running :-)"
        job = runtime.db.queryOne("""
            SELECT J.job_id as id, JTp.identifier as type
            FROM job_tasks JT
            JOIN jobs J ON JT.job_id = J.job_id
            JOIN job_types JTp ON J.job_type_id = JTp.job_type_id
            WHERE JT.task_id = %s
        """, [self.taskId])
        
        if not job:
            raise StandardError("Task, job or job type not found in database.")
            
        planner = runtime.tags.get('job_planner', job['type'])
        
        if not planner:
            raise StandardError("Cannot plan job of type {}".format(job['type']))
        
        planner(job['id']).plan()

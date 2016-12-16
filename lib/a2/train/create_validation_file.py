import json
import csv

import tasks
import planner
import a2.runtime as runtime
import a2.runtime.tmp

import a2.audio.recording


@runtime.tags.tag('task_type', 'train.validations.create_file')
class CreateValidationFileTask(tasks.Task):
    """Task that creates a validation file using the input of the reclinize tasks in the given step in this job.
        Inputs:[
            recnilizeTasksStep == resolves to ==> [
                recording_id,
                [species_id, songtype_id],
                present
            ]
        ]

        Output:
            s3://~/validations/job_{:job}.csv
    """
    def run(self):
        key = "project_{}/validations/job_{}.csv".format(
            self.get_project_id(),
            self.get_job_id()
        )
        
        with a2.runtime.tmp.tmpfile(suffix="csv") as tmpfile:
            csvwriter = csv.writer(tmpfile.file, delimiter=',')            
            for row in self.generate_validations():
                csvwriter.write(row)
            tmpfile.close_file()
            runtime.bucket.upload_filename(key, tmpfile.filename)

    def generate_validations(self):
        recnilize_tasks_step = self.get_args()[0]
        for row in runtime.db.queryGen("""
            SELECT JT.args
            FROM job_tasks JT
            WHERE JT.job_id = %s
              AND JT.type = %s
              AND JT.step = %s
        """, [
            self.get_job_id(),
            planner.ANALIZE_RECORDINGS_TASK,
            recnilize_tasks_step
        ]):
            recording_id, (species, songtype), present = json.loads(row['args'])
            recording = a2.audio.recording.Recording(recording_id)
            
            yield recording.get_uri(), species, songtype, present, recording_id


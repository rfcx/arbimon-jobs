import os
import csv
import json

import numpy

import tasks
import planner
import a2.runtime as runtime
import a2.runtime.tmp

import a2.audio.model


@runtime.tags.tag('task_type', 'train.rf_model.create')
class CreateModelTask(tasks.Task):
    """Task that creates a decision model from a validation dataset in efs.
        Inputs:[
            roi_class
        ]
        efs://~/{:class}/stats/*.npz
        efs://~/{:class}/surface.npz

        Output:
            s3://~/models/job_{:job}_{:class}.mod
    """
    def run(self):
        roi_class = self.get_args()[0]
        
        base_path = self.get_workspace_path(roi_class)
        rois_path = os.path.join(base_path, 'rois')
        stats_path = os.path.join(base_path, 'stats')
        
        with numpy.load(os.path.join(rois_path, 'surface.npz')) as surface:
            model = a2.audio.model.Model(roi_class, surface['roi'], self.get_job_id())
        
        for statsfile in os.listdir(stats_path):
            with numpy.load(os.path.join(stats_path, statsfile)) as validation:
                model.addSample(
                    validation['present'],
                    validation['features'],
                    validation['uri']
                )

        model_key = "project_{}/models/job_{}_{}.mod".format(
            self.get_project_id(),
            self.get_job_id(),
            roi_class
        )

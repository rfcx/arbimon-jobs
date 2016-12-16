import os
import os.path
import json

import numpy

import tasks
import a2.runtime as runtime
import a2.audio.recording
import a2.audio.recanalizer


@runtime.tags.tag('task_type', 'train.validations.analyze')
class ExtractRoiTask(tasks.Task):
    """Task that aligns all rois read from the working folder.
        Inputs:[
            recording_id,
            [species_id, songtype_id],
            present
        ]

        Output:
            efs://~/{:species_id}_{:songtype_id}/stats/{:step_id}.json
    """
    def run(self):
        rec_id, (species_id, songtype_id), present, model_type_id = self.get_args()
        roi_class = "{}_{}".format(species_id, songtype_id)
        
        base_path = self.get_workspace_path(roi_class)
        rois_path = os.path.join(base_path, 'rois')
        stats_path = os.path.join(base_path, 'stats')

        recording = a2.audio.recording.Recording(rec_id)
        roidata = numpy.load(os.path.join(rois_path, 'surface.npz'))
        roi_spec, fbounds = roidata['roi'], roidata['fbounds']
        flag_ssim, flag_search_match = self.get_analysis_flags(model_type_id)

        recanalizer = a2.audio.recanalizer.Recanalizer(
            recording,
            roi_spec,
            fbounds[1], fbounds[2],
            flag_ssim, flag_search_match
        )
        
        self.upload_vector(recording, recanalizer.get_vector())

        numpy.savez(
            os.path.join(stats_path, "{}.npz".format(self.taskId)),
            features=recanalizer.get_features(),
            present=present,
            max_cols=roidata['max_cols'],
            sample_rate=roidata['sample_rate'],
            fbounds=fbounds
        )
        
    def upload_vector(self, recording, vector):
        "uploads the given vector as a result of the given recording's analysis."
        key = "project_{}/training_vector/job_{}/{}".format(
            self.get_project_id(),
            self.get_job_id(),
            recording.get_name()
        )

        csv = ','.join(str(x) for x in vector) + '\n'

        runtime.bucket.upload_string(key, csv, 'public-read')
    
    def get_analysis_flags(self, model_type_id):
        "get analysis flags"
        ssim = True
        if model_type_id == 2:
            ssim = False
        searchMatch = False

        if model_type_id == 3:
            searchMatch = True
        return ssim, searchMatch

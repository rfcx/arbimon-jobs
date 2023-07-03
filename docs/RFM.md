# Random Forest Models

## Training

Entrypoint script: `PatternMatching/train.py`

### Notes

In this script, for each call type:
1. a template is made from a training set
2. for each recording in a validation set (present/absent)
   - features are collected from cross-correlation with the template
3. a scikit-learn RandomForestClassifier is trained to predict presence/absence

The script takes a job ID as an argument. It finds the job parameters such as `model_type_id`, `training_set_id`, `validation_set_id`,
from `job_params_training` table.

### DB Tables

- `jobs` - updated for training job
- `recordings` - retrieving recordings for training set
- `training_set_roi_set_data` - retrieving training set ROIs
- `job_params_training` - parameters for training job
    - number of present/absent training/validation samples
- `recording_validations` - retrieving validation data
- `validation_set` - storing a set of validation data
- `models` - for storing trained models
- `model_stats` - parameter info for models
- `model_classes` - the species and songtype IDs for each model

### Operations

#### Roigenerator

- calls `roigen()`: `lib/a2audio/training.py` within `Parallel()`
    - creates Roizer: `lib/a2audio/roizer.py`
   	    - computes the spectrogram of an ROI

#### Align rois
- loops over ROI spectrograms, creates list of Roisets: `lib/a2audio/roiset.py`
- loops over Roisets, calls `alignSamples()` method to align them in time and frequency
- gets a template (mean call) for each class (species/songtype combination)

#### Recnilize
- calls `recnilize()`: `lib/a2audio/training.py` within Parallel()
   	- creates Recanalizer: `lib/a2audio/recanalizer.py`
   	- calls `features()`, and `getVector()` methods to perform cv2 `matchTemplate()` and get cross-correlation features

#### Initialize model
- creates Models: `lib/a2audio/model.py`, one for each class
- calls `addSample()` method to append feature vectors from each sample to models

#### Train model
- for each model:
   	- calls `splitData()` method to split training and validation data
    - then `train()`
   	    - calls `sklearn.ensemble.RandomForestClassifier()`
   	    - then `fit()` method
   	- `validate()`
   	- `saveValidations()`
   	- `save()`
   	- `modelStats()`

## Classification

Entrypoint script: `PatternMatching/classification.py`

### DB Tables

- `jobs` - updated for classification job
- `job_params_classification` - stores parameters for classification jobs
- `models` - stores models
- `training_sets_roi_set` - for getting species and songtype IDs associated with each model
- `classification_stats` - some info about classification jobs: min and max vectors used?
- `classification_results` - stores predicted presence absence by recording, species, songtype, and job IDs

### Operations

Classification calls `lib/a2audio/classification_lib.run_classification( job ID )`
- `get_classification_job_data( MySQLdb connection, job ID )`
   	- returns model ID, project ID, user ID, classification Job Name, playlist ID, nCPU
- `get_model_params( MySQLdb connection, model ID, log )`
   	- returns model_type_id, model_uri, species, song type
- `run_pattern_matching( job ID, model URI, species, song type, playlist ID, log, config, ncpu )`
   	- `create_temp_dir( job ID, log)`
   	    - returns path to working folder for job
   	- `get_playlist( MySQLdb connection, playlist ID, log )`
   	    - returns recording IDs and URIs in playlist
   	- `get_model( model URI, config, log, working Folder )`
   	    - calls `get_contents_to_filename()` to pull model from S3 into working folder
   	        - pickle loads the model
   	- `classify_rec` within `Parallel()`, and passes model, processes recordings
   	    - creates Recanalizer: `lib/a2audio/recanalizer.py`
   	    - calls `features()` and `getVector()` methods
   	    - calls `predict()` on model (scikit-learn RandomForestClassifier), passing features
   	- `processResults()`
   	    - write classification results to DB

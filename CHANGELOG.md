# Change log for arbimon2 jobs library

## [Unreleased]
[[tag](https://github.com/Sieve-Analytics/arbimon2-jobs/commit/HEAD)]
[[compare](https://github.com/Sieve-Analytics/arbimon2-jobs/compare/HEAD...v1.0.1)]

## 1.0.1 - 2016-9-11
[[tag](https://github.com/Sieve-Analytics/arbimon2-jobs/releases/tag/v1.0.1)]
[[compare](https://github.com/Sieve-Analytics/arbimon2-jobs/compare/v1.0.1...v1.0.1)]

##### Fixed
- Some scripts still had `Config` instead of `EnvironmentConfig`.


## 1.0.0 - 2016-9-9    
[[tag](https://github.com/Sieve-Analytics/arbimon2-jobs/releases/tag/v1.0.0)]
[[compare](https://github.com/Sieve-Analytics/arbimon2-jobs/compare/3d3050dad7af986887f37612376d129e59967464...v1.0.0)]

##### Added
- Audio event detection:
    - new job script `AudioEventDetection/audio_event_detection.py`
    - new modules/packages:
        - `a2audio.audio_event_detection_lib`
        - `a2audio.segmentation.stats.*`
- Preliminary docker support
- new `EnvironmentConfig` class for reading configuration from the environment, a lá [dotenv-safe](https://github.com/rolodato/dotenv-safe), but adapted to current usage.
- Generic `Job` class for handling common things in jobs
- `Plan` and `PlanRunner` classes for specifying a job's steps and executing them in a
    more uniform manner.
- Pickling support for configurations
- Dependencies:
    - `dill` [0.2.5](https://pypi.python.org/pypi/dill/0.2.5)

##### Changed
- Configuration:
    - objects' attributes are now in snake_case, not in cammelCase
    - `EnvironmentConfig` is now used by default
    - `pathConfig` changed to `pathsConfig`
- Dependencies:
    - `numpy` [1.11.0](https://pypi.python.org/pypi/numpy/1.11.0)



## Pre changelog
[[tag](https://github.com/Sieve-Analytics/arbimon2-jobs/commit/3d3050dad7af986887f37612376d129e59967464)]

- Added
    - Rafa's thesis' pattern matching code for training and classifying recordings
    - Soundscape generation script using peaks
    - Configuration reader utility
    - many more undocumented things

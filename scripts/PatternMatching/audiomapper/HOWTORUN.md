###training:
 1. training.csv file with
    recId,speciesId,songtypeId,iniTime,endTime,lowFreq,highFreq,recuri,jobid
 2. ```sh
        cat bucket/training.csv | ./trainMap.py  | ./roigen.py  | ./align.py  | ./recnilize.py  |./modelize.py
    ```
 3. saves a model file

###classification:
 1. classify.csv file with
        recUri,modelUri,recId,job_id

 2. cat bucket/classify.csv | ./recClassify.py > results.txt

 3. results.txt file with
        recId, 0|1  present or ausent
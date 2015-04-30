#! .env/bin/python

import sys
import MySQLdb
import tempfile
import os
import time
import shutil
import math
import multiprocessing
import subprocess
import boto
import json
from joblib import Parallel, delayed
from datetime import datetime
from contextlib import closing
from soundscape import soundscape
from indices import indices
from a2audio.rec import Rec
from a2pyutils import palette
from a2pyutils.news import insertNews
from boto.s3.connection import S3Connection

num_cores = multiprocessing.cpu_count()

currDir = (os.path.dirname(os.path.realpath(__file__)))
USAGE = """
{prog} folder with recs
""".format(prog=sys.argv[0])

if len(sys.argv) < 2:
    print USAGE
    sys.exit(-1)

tempFolders = tempfile.gettempdir()
workingFolder = tempFolders+"/soundscape_folder/"
if os.path.exists(workingFolder):
    shutil.rmtree(workingFolder)
os.makedirs(workingFolder)

folder  = sys.argv[1]

agr_ident = 'time_of_day'
if len(sys.argv) > 2:
    agr_ident = sys.argv[2]
aggregation = soundscape.aggregations.get(agr_ident)

if not aggregation:
    print "# Wrong agregation."
    print USAGE
    sys.exit(-1)
imgout = 'image.png'
scidxout = 'index.scidx'
threshold = 0
frequency = 0
bin_size =  86
if bin_size < 0:
    print "# Bin size must be a positive number. Input was: " + str(bin_size)
    print USAGE
    sys.exit(-1)

#try:

recsToProcess = os.listdir(folder)
if len(recsToProcess) < 1:
    print "no recordings on folder."
    sys.exit(-1)

peaknumbers  = indices.Indices(aggregation)

hIndex = indices.Indices(aggregation)

aciIndex = indices.Indices(aggregation)

def processRec(rec):
    #if not ".flac" in rec:
        #return None
    id = 1
    rec_wav = rec.replace(".flac",".wav")
    rec_date = rec.replace("t1-","").replace(".wav","")
    date = datetime.strptime(rec_date, '%Y-%m-%d_%H-%M')
    if not os.path.isfile(rec_wav):
        proc = subprocess.Popen([
           '/usr/bin/flac', '-d',
           folder+"/"+rec
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate()
    if os.path.isfile(folder+"/"+rec_wav):
        localFile = folder+"/"+rec_wav
        print "processing",rec_wav
        proc = subprocess.Popen([
            '/usr/bin/Rscript', currDir+'/fpeaks.R',
            localFile,
            str(threshold),
            str(bin_size),
            str(frequency)
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate()
        if stderr and 'LC_TIME' not in stderr and 'OpenBLAS' not in stderr:
            return None
        elif stdout:
            if 'err' in stdout:
                return None
            ff=json.loads(stdout)
            freqs =[]
            amps =[]
            for i in range(len(ff)):
                freqs.append(ff[i]['f'])
                amps.append(ff[i]['a'])
            proc = subprocess.Popen([
               '/usr/bin/Rscript', currDir+'/h.R',
               localFile
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = proc.communicate()
            hvalue = None
            if stdout and 'err' not in stdout:
                hvalue = float(stdout)
            proc = subprocess.Popen([
               '/usr/bin/Rscript', currDir+'/aci.R',
               localFile
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = proc.communicate()
            
            acivalue = None
            if stdout and 'err' not in stdout:
                acivalue = float(stdout)
                
            proc = subprocess.Popen([
               '/usr/bin/soxi', '-r',
               localFile
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = proc.communicate()
            
            recSampleRate = None
            if stdout and 'err' not in stdout:
                recSampleRate = float(stdout)
            recMaxHertz = float(recSampleRate)/2.0    
            results = {"date": date, "id": id, "freqs": freqs , "amps":amps , "h":hvalue , "aci" :acivalue,"recMaxHertz":recMaxHertz}
            return results 
    else:
        return None


for recordingi in recsToProcess:
    print processRec(recordingi)
    quit()
quit()


start_time_all = time.time()
resultsParallel = Parallel(n_jobs=num_cores)(
     delayed(processRec)(recordingi) for recordingi in recsToProcess
)

if len(resultsParallel) > 0:
    max_hertz = 22050
    for result in resultsParallel:
        if result is not None:
            if   max_hertz < result['recMaxHertz']:
                max_hertz = result['recMaxHertz']
    max_bins = int(max_hertz / bin_size)
    scp = soundscape.Soundscape(aggregation, bin_size, max_bins)
    start_time_all = time.time()
    i = 0
    for result in resultsParallel:
        if result is not None:
            i = i + 1
            if result['freqs'] is not None:
                if len(result['freqs']) > 0:
                    scp.insert_peaks(result['date'], result['freqs'], i)
                peaknumbers.insert_value(result['date'] ,len(result['freqs']),i)
            if result['h'] is not None:
                hIndex.insert_value(result['date'] ,result['h'],i)
            if result['aci'] is not None:
                aciIndex.insert_value(result['date'] ,result['aci'],i)
                
    scp.write_index(workingFolder+scidxout)
    
    peaknFile = workingFolder+'peaknumbers'
    peaknumbers.write_index_aggregation_json(peaknFile+'.json')
    
    hFile = workingFolder+'h'
    hIndex.write_index_aggregation_json(hFile+'.json')
    
    aciFile = workingFolder+'aci'
    aciIndex.write_index_aggregation_json(aciFile+'.json')
    
    if aggregation['range'] == 'auto':
        statsMin = scp.stats['min_idx']
        statsMax = scp.stats['max_idx']
    else:
        statsMin = aggregation['range'][0]
        statsMax = aggregation['range'][1]

    scp.write_image(workingFolder + imgout, palette.get_palette())

else:
    print 'no results from playlist id:'+playlist_id

    #shutil.rmtree(tempFolders+"/soundscape_"+str(job_id))
#except Exception, e:
    #print 'error'



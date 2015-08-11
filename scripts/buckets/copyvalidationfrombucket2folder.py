import boto
from a2pyutils.config import Config
from soundscape.set_visual_scale_lib import get_bucket
import sys
import os

if len(sys.argv)<2:
    print "need a validation list (project_1234/validations/job_1234.csv)"
    exit(1)

print 'start'

configuration = Config()
config_source = configuration.data()
config_source[4] = 'arbimon2'

namePart = sys.argv[1].split("/")

wDir = '/home/rafa/recs/'+namePart[len(namePart)-1]

if not os.path.exists(wDir):
    os.makedirs(wDir)
 
source_bucket = get_bucket(config_source)

if not os.path.exists(wDir+"/valilist.txt"):
    k = source_bucket.get_key(sys.argv[1], validate=False)
    k.get_contents_to_filename(wDir+"/valilist.txt")
    
with open(wDir+"/valilist.txt") as f:
    content = f.readlines()

for filename in content:
    filename = filename.strip("\n")
    print filename
    recnamePart = filename.split(",")
    bucketKey = recnamePart[0]
    recnamePart = bucketKey.split("/")
    
    if not os.path.exists(wDir+"/"+recnamePart[len(recnamePart)-1]):
        k = source_bucket.get_key(bucketKey, validate=False)
        k.get_contents_to_filename(wDir+"/"+recnamePart[len(recnamePart)-1])
        del k

print 'done'
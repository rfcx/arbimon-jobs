import boto
from a2pyutils.config import Config
import sys
import os
import a2pyutils.storage
from soundscape.set_visual_scale_lib import get_db
from contextlib import closing


folder = "/home/rafa/recs/"

configuration = Config()
config_dest = configuration.data()
config_source = list(config_dest)
config_source[4] = 'a2-rafa'
db = get_db(config_dest)

uris = []

with closing(db.cursor()) as cursor:
    cursor.execute("""
        SELECT r.`uri`
        FROM  `recordings` r
    """)
    db.commit()
    numTrainingRows = int(cursor.rowcount)
    for x in range(0, numTrainingRows):
        rowTraining = cursor.fetchone()
        uris.append(rowTraining['uri'])
        
db.close()

storage = a2pyutils.storage.BotoBucketStorage(config_source[7], config_source[4], config_source[5],config_source[6])

for i in range(len(uris)):
    uriP = uris[i].split('/')
    folderDest ='/'.join(uriP[0:(len(uriP)-1)])
    folderDest = folder+folderDest
    if not os.path.exists(folderDest):
        os.makedirs(folderDest)
    f = None
    localfilename = folderDest+'/'+uriP[(len(uriP)-1)]
    if not os.path.exists(localfilename):
        f = storage.get_file(uris[i])
        print "copying to local storage",uris[i]
        with open(localfilename, "wb") as local_file:
            local_file.write(f.read())
    else:
        print "already in local storage", uris[i]
    f = None

print 'done'
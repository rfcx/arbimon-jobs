import sys
import json
import csv

filen = None
if len(sys.argv) > 1:
    filen = str(sys.argv[1])
else:
    print 'importances csv file needed'
    sys.exit(1)

importance_data = []
with open(filen, 'rb') as csvfile:
     spamreader = csv.reader(csvfile)
     for row in spamreader:
         importance_data.append([float(i) for i in row])
    
for row in importance_data:
    print [i[0] for i in reversed(sorted(enumerate(row), key=lambda x:x[1]))]


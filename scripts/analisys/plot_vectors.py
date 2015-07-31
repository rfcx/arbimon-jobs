import sys
import csv
from pylab import *

filen = None
if len(sys.argv) > 1:
    filen = str(sys.argv[1])
else:
    print 'vectors csv file needed'
    sys.exit(1)

vectors_data = []
classes = []
with open(filen, 'rb') as csvfile:
     spamreader = csv.reader(csvfile)
     for row in spamreader:
        classes.append(row[0])
        vectors_data.append([float(i) for i in row[1:]])
         
for i in range(len(vectors_data)):
    vect = vectors_data[i]
    ccc = classes[i]
    cc = 'black'
    if ccc[0] == '1':
        cc = 'red'
    plot(vect[1:],color=cc)

ff = filen.split('/')
ff = ff[len(ff)-1]
savefig('/home/rafa/Desktop/sel/'+ff+'.png')


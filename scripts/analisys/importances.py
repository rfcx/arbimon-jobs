import sys
import json
import csv

varssNames = ['mean',
'(max-min)',
'max',
'min',
'std',
'median',
'skew',
'kurtosis',
'moment(1) mean',
'moment(2) variance',
'moment(3) skweness',
'moment(4) kurtosis',
'moment(5) hyper skweness',  #high value indicates movement in the tails , while a low value indicates more action in the center
'moment(6) hyper kurtosis',
'moment(7)',
'moment(8)',
'moment(9)',
'moment(10)',
'cfs[0]',
'cfs[1]',
'cfs[2]',
'cfs[3]',
'cfs[4]',
'cfs[5]',
'hist[0]',
'hist[1]',
'hist[2]',
'hist[3]',
'hist[4]',
'hist[5]',
'mean(xf)',
'max(xf)-min(xf)',
'max(xf)',
'min(xf)',
'std(xf)',
'median(xf)',
'skew(xf)',
'kurtosis(xf)',
'acf[0]',
'acf[1]',
'acf[2]']


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
first = True
firstNvars = 10
a = None
#f = open('/home/rafa/Desktop/allvarss.csv','a')

for row in importance_data:
    varss =  [i[0] for i in reversed(sorted(enumerate(row), key=lambda x:x[1]))]
    #f.write(','.join(str(x) for x in row)+"\n")
    if first:
        a = varss[0:firstNvars]
        first = False
    else:
        a = list(set(a) & set(varss[0:firstNvars]))
#f.close()
print [varssNames[i] for i in a]

import sys
sys.path.append('/var/lib/jobs/app/lib/')
import numpy
if 'a2audio.recanalizer' in sys.modules:
    del sys.modules['a2audio.recanalizer']

from pylab import *
def gen_random_matrix(rows,cols):
    """Generates random stripped matrix"""
    chunckLength = 20
    randomStart = 25#randint(chunckLength,min(100,cols))
    chucnkJump = 3
    chunckLessLength = chunckLength*chucnkJump
    chunks = int((float(cols-randomStart))/(float(chunckLessLength+chunckLength)))
    mm = numpy.random.rand(rows,cols)
    jump = 0
    dd = [.9,.95,.99]
    for i in range(randomStart,cols-chunckLength,chunckLength):
        if jump == 0:
            mm[:,i:(i+chunckLength)] = numpy.ones(shape=(rows,chunckLength))*dd[randint(0,2)]
        jump = (jump+1)%chucnkJump
    z = numpy.zeros(shape=(1116,mm.shape[1]))
    if mm.shape[0] == 1116:
        z = mm
    else:
        z[(max(0,1116-mm.shape[0]-1)):1115,:] = mm
    return z

import scipy
def istft(X):
    cols = X.shape[1]
    x = scipy.zeros(cols*X.shape[0])
    j = 0
    for i in range(cols):
        x[j:(j+X.shape[0])] = scipy.real(scipy.ifft(X[:,i]))
        j = j + X.shape[0]
    return x

mm = gen_random_matrix(1116,650)
ss = numpy.copy(mm[:,490:550])
mmm = numpy.random.rand(1116,650*2)
ii=650/2
mmm[:,ii:(ii+650)] = mm
au = istft(mmm)
au1 = numpy.random.rand(2*len(au))
ii=len(au)/2
au1[ii:(ii+len(au))] = au
ss = numpy.copy(mm[:,490:550])
from a2audio.thresholder import Thresholder
threshold = Thresholder()
ss = threshold.apply(ss)
from a2audio.recanalizer import Recanalizer
recAna = Recanalizer('anyuri', ss , 1000.0, 5000.0, '/tmp/','bucketname', logs=None,test=True,useSsim = False,step=16)
recAna.insertRecAudio(au,192000)
recAna.spectrogram()
recAna.featureVector()
recAna.showVectAndSpec()

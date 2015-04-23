import sys
import numpy
sys.path.append('/var/lib/jobs/app/lib')
import scipy.io.wavfile
from pylab import *
import warnings
import time

from a2audio.recanalizer import Recanalizer

inputAudio = '/home/rafa/Desktop/sp35/rec-2010-12-14_00-00.wav'
fs=None
au=None
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fs,au = scipy.io.wavfile.read(inputAudio)

sp,fqs,b = mlab.specgram(au,NFFT=512,Fs=fs,noverlap=256)
pattern = numpy.flipud(10*numpy.log10(sp[1:,]))[:,350:520]
pp = numpy.zeros(shape=(1116,pattern.shape[1]))
pp[(pp.shape[0]-pattern.shape[0]):,] = pattern
fqs = fqs[::-1]

start_time = time.time()

analyzer = Recanalizer('/tmp/', pp, float(fqs[210]), float(fqs[155]), '/tmp','none', logs=None,test=True,useSsim = True,step=1,oldModel =False,numsoffeats=41)
print 'Recanalizer init',str(time.time() - start_time),'secs'

inputAudio2 = '/home/rafa/Desktop/sp35/rec-2010-12-14_00-01.wav'
fs2=None
au2=None
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fs2,au2 = scipy.io.wavfile.read(inputAudio2)
sp,fqs,b = mlab.specgram(au2,NFFT=512,Fs=fs2,noverlap=256)
pattern = numpy.flipud(10*numpy.log10(sp[1:,]))
#imshow(pattern)
#show()
analyzer.insertRecAudio(au2,fs2)
start_time = time.time()
analyzer.spectrogram()
print 'spectrogram',str(time.time() - start_time),'secs'
#analyzer.showspectrogram()
start_time = time.time()
analyzer.ransac()
print 'ransac',str(time.time() - start_time),'secs'
#featureVector step=1 13.151278019 secs, step=2 7.39018201828 secs, step=4 3.19879317284 secs, step=8 1.47710108757 secs , step=16 0.854254007339 secs
analyzer.showVectAndSpec()

import numpy as np
import cv2
from matplotlib import pyplot as plt
import scipy.io.wavfile
from pylab import *
import numpy
import warnings
import cv2
from cv import *
import numpy as np
import cv2
from matplotlib import pyplot as plt

inputAudio = '/home/rafa/Desktop/sp20/rec-2010-12-14_00-00.wav'
fs=None
au=None
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fs,au = scipy.io.wavfile.read(inputAudio)

sp,fqs,b = mlab.specgram(au,NFFT=512,Fs=fs,noverlap=256)
pattern = numpy.flipud(10*numpy.log10(sp[1:,]))[150:220,210:300]
pattern = ((pattern-numpy.min(numpy.min(pattern)))/(numpy.max(numpy.max(pattern))-numpy.min(numpy.min(pattern))))*255
pattern = pattern.astype('uint8')

img = pattern
gray = img

corners = cv2.goodFeaturesToTrack(gray,25,0.01,10)
corners = np.int0(corners)
print img.shape
for i in corners:
    x,y = i.ravel()
    cv2.circle(img,(x,y),1,255)

plt.imshow(img),plt.show()
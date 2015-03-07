from rec import Rec
from pylab import *
from matplotlib import *
import numpy
import math

class Roizer:

    def __init__(self, uri ,tempFolder,bucketName ,iniSecs=5,endiSecs=15,lowFreq = 1000, highFreq = 2000):
        
        if type(uri) is not str and type(uri) is not unicode:
            raise ValueError("uri must be a string")
        if type(tempFolder) is not str:
            raise ValueError("invalid tempFolder")
        if not os.path.exists(tempFolder):
            raise ValueError("invalid tempFolder")
        elif not os.access(tempFolder, os.W_OK):
            raise ValueError("invalid tempFolder")
        if type(bucketName) is not str:
            raise ValueError("bucketName must be a string")
        if type(iniSecs) is not int and  type(iniSecs) is not float:
            raise ValueError("iniSecs must be a number")
        if type(endiSecs) is not int and  type(endiSecs) is not float:
            raise ValueError("endiSecs must be a number")
        if type(lowFreq) is not int and  type(lowFreq) is not float:
            raise ValueError("lowFreq must be a number")
        if type(highFreq) is not int and  type(highFreq) is not float:
            raise ValueError("highFreq must be a number")
        if iniSecs>=endiSecs:
            raise ValueError("iniSecs must be less than endiSecs")
        if lowFreq>=highFreq :
            raise ValueError("lowFreq must be less than highFreq")
        self.spec = None
        recording = Rec(uri,tempFolder,bucketName,None)

        if  'HasAudioData' in recording.status:
            self.original = recording.original
            self.sample_rate = recording.sample_rate
            self.channs = recording.channs
            self.samples = recording.samples
            self.status = 'HasAudioData'
            self.iniT = iniSecs
            self.endT = endiSecs
            self.lowF = lowFreq
            self.highF = highFreq 
            self.uri = uri
        else:
            self.status = "NoAudio"
            return None
        dur = self.samples/self.sample_rate
        if dur < endiSecs:
            raise ValueError("endiSecs greater than recording duration")
        
        if  'HasAudioData' in self.status:
            self.spectrogram()

    def getAudioSamples(self):
        return self.original
    
    def getSpectrogram(self):
        if self.spec is not None:
             self.spectrogram()
        return self.spec
    
    def spectrogram(self):
        
        endSample = int(math.floor(float((self.endT)) * float((self.sample_rate))))
        if endSample >= len(self.original):
           endSample = len(self.original) - 1

        data = self.original[0:endSample]
        
        Pxx, freqs, bins = mlab.specgram(data, NFFT=512, Fs=self.sample_rate, noverlap=256)
        dims =  Pxx.shape
         
        #remove unwanted columns (cut in time)
        i = 0
        while bins[i] < self.iniT:
            Pxx = numpy.delete(Pxx, 0,1)
            i = i + 1
        
        #put zeros in unwanted frequencies (filter)
        i =0
        while freqs[i] < self.lowF:
            Pxx[i,:] = 0 
            i = i + 1
        #calculate decibeles in the passband
        while freqs[i] < self.highF:
            Pxx[i,:] =  10. * numpy.log10(Pxx[i,:].clip(min=0.0000000001))
            i = i + 1
        #put zeros in unwanted frequencies (filter)
        while i <  dims[0]:
            Pxx[i,:] = 0
            i = i + 1

        Z = numpy.flipud(Pxx)
        self.spec = Z
        

from rec import Rec
from pylab import *
from matplotlib import *
import numpy
import math
import json
from fullFrequencies import *
analysis_sample_rates = [16000.0,32000.0,48000.0,96000.0,192000.0]

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
            if float(recording.sample_rate) not in analysis_sample_rates:
                self.status = "SampleRateNotSupported"
                return None              
            self.original = recording.original
            self.sample_rate = recording.sample_rate
            self.recording_sample_rate = recording.sample_rate
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
        
        initSample = int(math.floor(float((self.iniT)) * float((self.sample_rate))))
        endSample = int(math.floor(float((self.endT)) * float((self.sample_rate))))
        if endSample >= len(self.original):
           endSample = len(self.original) - 1
        freqsFull = get_freqs()
        maxHertzInRec = float(self.sample_rate)/2.0
        nfft = 1116 #if 192000 Hz nfft is 1116 else:
        if float(self.sample_rate) == 16000.0:
            nfft = 93
        if float(self.sample_rate) == 32000.0:
            nfft = 186
        if float(self.sample_rate) == 48000.0:
            nfft = 279
        if float(self.sample_rate) == 96000.0:
            nfft = 558
        targetrows = len(freqsFull)
        data = self.original[initSample:endSample]
        Pxx, freqs, bins = mlab.specgram(data, NFFT=nfft*2, Fs=self.sample_rate, noverlap=nfft)
        dims =  Pxx.shape
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
        Z = numpy.flipud(Pxx[1:(Pxx.shape[0]-1),:])
        z = numpy.zeros(shape=(targetrows,Pxx.shape[1]))
        z[(targetrows-Pxx.shape[0]+1):(targetrows-1),:] = Z
        self.spec = z
        

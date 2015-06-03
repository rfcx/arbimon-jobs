from a2audio.rec import Rec
from pylab import *
import numpy
import time
from skimage.measure import structural_similarity as ssim
from scipy.stats import pearsonr as prs
from scipy.stats import kendalltau as ktau
from  scipy.spatial.distance import cityblock as ct
from scipy.spatial.distance import cosine as csn
import math
from a2pyutils.logger import Logger
import os
import json
import warnings

class Recanalizer:
    
    def __init__(self, uri, speciesSurface, low, high, tempFolder,bucketName, logs=None,test=False):
        if type(uri) is not str and type(uri) is not unicode:
            raise ValueError("uri must be a string")
        if type(speciesSurface) is not numpy.ndarray:
            raise ValueError("speciesSurface must be a numpy.ndarray. Input was a "+str(type(speciesSurface)))
        if type(low) is not int and  type(low) is not float:
            raise ValueError("low must be a number")
        if type(high) is not int and  type(high) is not float:
            raise ValueError("high must be a number")
        if low>=high :
            raise ValueError("low must be less than high")
        if type(tempFolder) is not str:
            raise ValueError("invalid tempFolder")
        if not os.path.exists(tempFolder):
            raise ValueError("invalid tempFolder")
        elif not os.access(tempFolder, os.W_OK):
            raise ValueError("invalid tempFolder")
        if type(bucketName) is not str:
            raise ValueError("bucketName must be a string")
        if logs is not None and not isinstance(logs,Logger):
            raise ValueError("logs must be a a2pyutils.Logger object")
        
        start_time = time.time()
        self.low = float(low)
        self.high = float(high)
        self.columns = speciesSurface.shape[1]
        self.speciesSurface = speciesSurface
        self.logs = logs   
        self.uri = uri
        self.bucketName = bucketName
        self.tempFolder = tempFolder
        self.rec = None
        self.status = 'NoData'
        
        if self.logs:
           self.logs.write("processing: "+self.uri)    
        if self.logs :
            self.logs.write("configuration time --- seconds ---" + str(time.time() - start_time))
        
        if not test:
            self.process()
    
    def process(self):
        start_time = time.time()
        self.instanceRec()
        if self.logs:
            self.logs.write("retrieving recording from bucket --- seconds ---" + str(time.time() - start_time))
        if self.rec.status == 'HasAudioData':
            maxFreqInRec = float(self.rec.sample_rate)/2.0
            if self.high >= maxFreqInRec:
                self.status = 'CannotProcess'
            else:
                start_time = time.time()
                self.spectrogram()
                if self.logs:
                    self.logs.write("spectrogrmam --- seconds ---" + str(time.time() - start_time))
                start_time = time.time()
                self.featureVector()
                if self.logs:
                    self.logs.write("feature vector --- seconds ---" + str(time.time() - start_time))
                self.status = 'Processed'
        else:
            self.status = self.rec.status

    def getRec(self):
        return self.rec
    
    def instanceRec(self):
        self.rec = Rec(str(self.uri),self.tempFolder,self.bucketName,None)
        
    def getVector(self ):
        return self.distances
    
    def features(self):
        return [numpy.mean(self.distances), (max(self.distances)-min(self.distances)),
                max(self.distances), min(self.distances)
                , numpy.std(self.distances) , numpy.median(self.distances)]
        
    def featureVector(self):
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            if self.logs:
               self.logs.write("featureVector start")
            if self.logs:
               self.logs.write(self.uri)    
            pieces = self.uri.split('/')
            self.distances = []
            currColumns = self.spec.shape[1]
            step = 16
            if self.logs:
               self.logs.write("featureVector start")
            self.matrixSurfacComp = numpy.copy(self.speciesSurface[self.spechigh:self.speclow,:])
            self.matrixSurfacComp[self.matrixSurfacComp[:,:]==-10000] = numpy.min(self.matrixSurfacComp[self.matrixSurfacComp != -10000])
            winSize = min(self.matrixSurfacComp.shape)
            winSize = min(winSize,7)
            if winSize %2 == 0:
                winSize = winSize - 1
            spec = self.spec;
            for j in range(0,currColumns - self.columns,step):
                val = ssim( numpy.copy(spec[: , j:(j+self.columns)]) , self.matrixSurfacComp , win_size=winSize)
                if val < 0:
                   val = 0
                self.distances.append(  val   )
            if self.logs:
               self.logs.write("featureVector end")
    
    def getSpec(self):
        return self.spec
    
    def spectrogram(self):
        freqs44100 = json.load(file('scripts/data/freqs.json'))['freqs']
        maxHertzInRec = float(self.rec.sample_rate)/2.0
        i = 0
        nfft = 512
        if self.rec.sample_rate <= 44100:
            while i<len(freqs44100) and freqs44100[i] <= maxHertzInRec :
                i = i + 1
            nfft = i
        start_time = time.time()

        Pxx, freqs, bins = mlab.specgram(self.rec.original, NFFT=nfft *2, Fs=self.rec.sample_rate , noverlap=nfft )
        if self.rec.sample_rate < 44100:
            self.rec.sample_rate = 44100
        dims =  Pxx.shape
        if self.logs:
            self.logs.write("mlab.specgram --- seconds ---" + str(time.time() - start_time))

        i = 0
        j = 0
        start_time = time.time()
        while freqs[i] < self.low:
            j = j + 1
            i = i + 1
        
        #calculate decibeles in the passband
        while (i < len(freqs)) and (freqs[i] < self.high):
            Pxx[i,:] =  10. * np.log10( Pxx[i,:].clip(min=0.0000000001))
            i = i + 1
 
        if i >= dims[0]:
            i = dims[0] - 1
            
        Z= Pxx[j:i,:]
        
        self.highIndex = dims[0]-j
        self.lowIndex = dims[0]-i
        
        if self.lowIndex < 0:
            self.lowIndex = 0
            
        if self.highIndex >= dims[0]:
            self.highIndex = dims[0] - 1
        i = 0
        j = 0
        if self.rec.sample_rate <= 44100:
            i = len(freqs44100) - 1
            j = i
            while freqs44100[i] > self.high and i>=0:
                j = j -1 
                i = i -1
                
            while freqs44100[j] > self.low and j>=0:
                j = j -1
            self.speclow = len(freqs44100) - j - 2
            self.spechigh = len(freqs44100) - i - 2
            if self.speclow >= len(freqs44100):
                self.speclow = len(freqs44100)-1
            if self.spechigh < 0:
                self.spechigh = 0
        else:
            i = len(freqs) - 1
            j = i
            while freqs[i] > self.high and i>=0:
                j = j -1 
                i = i -1
                
            while freqs[j] > self.low and j>=0:
                j = j -1            
            self.speclow = len(freqs) - j - 2
            self.spechigh = len(freqs) - i - 2
            if self.speclow >= len(freqs):
                self.speclow = len(freqs)-1
            if self.spechigh < 0:
                self.spechigh = 0
        Z = np.flipud(Z)
        if self.logs:
            self.logs.write('logs and flip ---' + str(time.time() - start_time))
        self.spec = Z
    
    def showVectAndSpec(self):
        ax1 = subplot(211)
        plot(self.distances)
        subplot(212, sharex=ax1)
        ax = gca()
        im = ax.imshow(self.spec, None)
        ax.axis('auto')
        show()
        close()
        
    def showSurface(self):
        print numpy.min(numpy.min(self.matrixSurfacComp))
        imshow(self.matrixSurfacComp)
        show()
        close()

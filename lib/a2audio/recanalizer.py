from a2audio.rec import Rec
from a2audio.thresholder import Thresholder
from pylab import *
import numpy
numpy.seterr(all='ignore')
numpy.seterr(divide='ignore', invalid='ignore')
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
from fullFrequencies import *
from scipy.stats import *
from  scipy.signal import *
import warnings


analysis_sample_rates = [16000.0,32000.0,48000.0,96000.0,192000.0]


class Recanalizer:
    
    def __init__(self, uri, speciesSurface, low, high, tempFolder,bucketName, logs=None,test=False,useSsim = True):
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
            raise ValueError("invalid tempFolder must be a string")
        if not os.path.exists(tempFolder):
            raise ValueError("invalid tempFolder does not exists")
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
        self.ssim = useSsim
        
        if self.logs:
           self.logs.write("processing: "+self.uri)    
        if self.logs :
            self.logs.write("configuration time --- seconds ---" + str(time.time() - start_time))
        
        if not test:
            self.process()
        else:
            self.status = 'TestRun'
    
    def process(self):
        start_time = time.time()
        self.instanceRec()
        if self.logs:
            self.logs.write("retrieving recording from bucket --- seconds ---" + str(time.time() - start_time))
        if self.rec.status == 'HasAudioData':
            maxFreqInRec = float(self.rec.sample_rate)/2.0
            if self.high >= maxFreqInRec:
                self.status = 'RoiOutsideRecMaxFreq'
            elif float(self.rec.sample_rate) not in analysis_sample_rates:
                self.status = "SampleRateNotSupported"
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
            self.status = 'NoData'

    def getRec(self):
        return self.rec
    
    def instanceRec(self):
        self.rec = Rec(str(self.uri),self.tempFolder,self.bucketName,None)
        
    def getVector(self ):
        return self.distances
    
    def features(self):
        
        N = len(self.distances)
        fvi = np.fft.fft(self.distances, n=2*N)
        acf = np.real( np.fft.ifft( fvi * np.conjugate(fvi) )[:N] )
        acf = acf/(N - numpy.arange(N))
        
        xf = abs(numpy.fft.fft(self.distances))
        skew(xf)
        return [1]
        fs = [ numpy.mean(xf), (max(xf)-min(xf)),
                max(xf), min(xf)
                , numpy.std(xf) , numpy.median(xf),skew(xf),
                kurtosis(xf),acf[0] ,acf[1] ,acf[2]]
        return [1]
        hist = histogram(self.distances,6)[0]
        cfs =  cumfreq(self.distances,6)[0]
        return [numpy.mean(self.distances), (max(self.distances)-min(self.distances)),
                max(self.distances), min(self.distances)
                , numpy.std(self.distances) , numpy.median(self.distances),skew(self.distances),
                kurtosis(self.distances),moment(self.distances,1),moment(self.distances,2)
                ,moment(self.distances,3),moment(self.distances,4),moment(self.distances,5)
                ,moment(self.distances,6),moment(self.distances,7),moment(self.distances,8)
                ,moment(self.distances,9),moment(self.distances,10)
                ,cfs[0],cfs[1],cfs[2],cfs[3],cfs[4],cfs[5]
                ,hist[0],hist[1],hist[2],hist[3],hist[4],hist[5]
                ,fs[0],fs[1],fs[2],fs[3],fs[4],fs[5],fs[6],fs[7],fs[8],fs[9],fs[10]]
        
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
            step = 16#int(self.spec.shape[1]*.05) # 5 percent of the pattern size
            if self.logs:
                self.logs.write("featureVector start")
            self.matrixSurfacComp = numpy.copy(self.speciesSurface[self.spechigh:self.speclow,:])
            removeUnwanted = self.matrixSurfacComp == -10000
            if len(removeUnwanted) > 0  :
                self.matrixSurfacComp[self.matrixSurfacComp[:,:]==-10000] = numpy.min(self.matrixSurfacComp[self.matrixSurfacComp != -10000])
            winSize = min(self.matrixSurfacComp.shape)
            winSize = min(winSize,7)
            if winSize %2 == 0:
                winSize = winSize - 1
            spec = self.spec;
            if self.ssim:
                for j in range(0,currColumns - self.columns,step):
                    val = ssim( numpy.copy(spec[: , j:(j+self.columns)]) , self.matrixSurfacComp , win_size=winSize)
                    if val < 0:
                       val = 0
                    self.distances.append(  val )
            else:
                maxnormforsize = numpy.linalg.norm( numpy.ones(shape=self.matrixSurfacComp.shape) )
                for j in range(0,currColumns - self.columns,step):
                    val = numpy.linalg.norm( numpy.multiply ( numpy.copy(spec[: , j:(j+self.columns)]), self.matrixSurfacComp ) )/maxnormforsize
                    self.distances.append(  val )
                
            if self.logs:
               self.logs.write("featureVector end")
    
    def getSpec(self):
        return self.spec
    
    def spectrogram(self):
        freqsmaxRange = get_freqs()
        maxHertzInRec = float(self.rec.sample_rate)/2.0
        nfft = 1116
        if float(self.rec.sample_rate) == 16000.0:
            nfft = 93
        if float(self.rec.sample_rate) == 32000.0:
            nfft = 186
        if float(self.rec.sample_rate) == 48000.0:
            nfft = 279
        if float(self.rec.sample_rate) == 96000.0:
            nfft = 558
        start_time = time.time()

        Pxx, freqs, bins = mlab.specgram(self.rec.original, NFFT=nfft*2, Fs=self.rec.sample_rate , noverlap=nfft )
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

        i = len(freqsmaxRange ) - 1
        j = i
        while freqsmaxRange[i] > self.high and i>=0:
            j = j -1 
            i = i -1
            
        while freqsmaxRange[j] > self.low and j>=0:
            j = j -1
        self.speclow = len(freqsmaxRange) - j - 2
        self.spechigh = len(freqsmaxRange) - i - 2
        if self.speclow >= len(freqsmaxRange):
            self.speclow = len(freqsmaxRange)-1
        if self.spechigh < 0:
            self.spechigh = 0

        Z = np.flipud(Z)
        if self.logs:
            self.logs.write('logs and flip ---' + str(time.time() - start_time))
            
        if self.ssim:
            self.spec = Z
        else:
            threshold = Thresholder()
            self.spec = threshold.apply(Z)
    
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
        imshow(self.matrixSurfacComp)
        show()
        close()

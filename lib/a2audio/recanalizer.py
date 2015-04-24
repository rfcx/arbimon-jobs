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
from scipy.stats import *
from  scipy.signal import *
import warnings
from samplerates import *
import cv2
from cv import *

analysis_sample_rates = [16000.0,32000.0,48000.0,96000.0,192000.0]


class Recanalizer:
    
    def __init__(self, uri, speciesSurface, low, high, tempFolder,bucketName, logs=None,test=False,useSsim = True,step=16,oldModel =False,numsoffeats=41):
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
        self.distances = []
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
        self.step = step
        self.oldModel = oldModel
        self.numsoffeats = numsoffeats
        self.algo = 'sift'
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
            else:
                if not self.oldModel and float(self.rec.sample_rate) not in analysis_sample_rates:
                    self.status = "SampleRateNotSupported"
                else:
                    start_time = time.time()
                    self.spectrogram()
                    if self.logs:
                        self.logs.write("spectrogrmam --- seconds ---" + str(time.time() - start_time))
                    start_time = time.time()
                    self.featureVector()
                    if self.logs:
                        self.logs.write("Done:feature vector --- seconds ---" + str(time.time() - start_time))
                    self.status = 'Processed'
        else:
            self.status = 'NoData'

    def getRec(self):
        return self.rec
    
    def instanceRec(self):
        self.rec = Rec(str(self.uri),self.tempFolder,self.bucketName,self.logs,False,False,not self.oldModel)
        
    def getVector(self ):
        if len(self.distances)<1:
            self.featureVector()
        return self.distances
    
    def insertRecAudio(self,data,fs=44100):
        self.rec = Rec('nouri','/tmp/','bucketName',None,True,True)
        for i in data:
            self.rec.original.append(i)
        self.rec.sample_rate = fs
        self.rec.resample()
        maxFreqInRec = float(self.rec.sample_rate)/2.0
    
    def ocurrences(threshold=0.5):
        if len(self.distances)<1:
            self.featureVector()
        if  max(self.distances) < threshold:
            threshold = self.maxDist
    
    def features(self):
        if len(self.distances)<1:
            self.featureVector()
        N = len(self.distances)
        fvi = np.fft.fft(self.distances, n=2*N)
        acf = np.real( np.fft.ifft( fvi * np.conjugate(fvi) )[:N] )
        acf = acf/(N - numpy.arange(N))
        
        xf = abs(numpy.fft.fft(self.distances))
        skew(xf)
        fs = [ numpy.mean(xf), (max(xf)-min(xf)),
                max(xf), min(xf)
                , numpy.std(xf) , numpy.median(xf),skew(xf),
                kurtosis(xf),acf[0] ,acf[1] ,acf[2]]
        hist = histogram(self.distances,6)[0]
        cfs =  cumfreq(self.distances,6)[0]
        ffs = [numpy.mean(self.distances), (max(self.distances)-min(self.distances)),
                    max(self.distances), min(self.distances)
                    , numpy.std(self.distances) , numpy.median(self.distances),skew(self.distances),
                    kurtosis(self.distances),moment(self.distances,1),moment(self.distances,2)
                    ,moment(self.distances,3),moment(self.distances,4),moment(self.distances,5)
                    ,moment(self.distances,6),moment(self.distances,7),moment(self.distances,8)
                    ,moment(self.distances,9),moment(self.distances,10)
                    ,cfs[0],cfs[1],cfs[2],cfs[3],cfs[4],cfs[5]
                    ,hist[0],hist[1],hist[2],hist[3],hist[4],hist[5]
                    ,fs[0],fs[1],fs[2],fs[3],fs[4],fs[5],fs[6],fs[7],fs[8],fs[9],fs[10]]
        if self.oldModel:
            return ffs[:self.numsoffeats]
        else:
            return ffs
        
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
            step = self.step#int(self.spec.shape[1]*.05) # 5 percent of the pattern size
            if self.oldModel:
                if self.logs:
                    self.logs.write("Backward compatibility mode")  
                freqs44100 = json.load(file('scripts/data/freqs44100.json'))['freqs']
                i = len(freqs44100) - 1
                j = i
                if self.logs:
                    self.logs.write('Searchjing frequencies')  
                while freqs44100[i] > self.high and i>=0:
                    j = j -1
                    i = i -1
                while freqs44100[j] > self.low and j>=0:
                    j = j -1
                if self.logs:
                    self.logs.write('Search done')  
                speclow = len(freqs44100) - j - 2
                spechigh = len(freqs44100) - i - 2
                if speclow >= len(freqs44100):
                    speclow = len(freqs44100)-1
                if spechigh < 0:
                    spechigh = 0
                self.matrixSurfacComp = numpy.copy(self.speciesSurface[spechigh:speclow,:])
            else:
                self.matrixSurfacComp = numpy.copy(self.speciesSurface[self.spechigh:self.speclow,:])
            removeUnwanted = self.matrixSurfacComp == -10000
            if len(removeUnwanted) > 0  :
                self.matrixSurfacComp[self.matrixSurfacComp[:,:]==-10000] = numpy.min(self.matrixSurfacComp[self.matrixSurfacComp != -10000])
            winSize = min(self.matrixSurfacComp.shape)
            winSize = min(winSize,7)
            if winSize %2 == 0:
                winSize = winSize - 1
            spec = self.spec;
            self.currColumns = currColumns
            if self.logs:
                self.logs.write('Computing distances')
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
               self.logs.write("Done featureVector end")
    
    def getSpec(self):
        return self.spec
    
    def spectrogram(self):
        freqsmaxRange = get_freqs()
        maxHertzInRec = float(self.rec.sample_rate)/2.0
        if self.oldModel:
            nfft = self.speciesSurface.shape[0]
        else:
            nfft = get_nfft(self.rec.sample_rate)
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
            Pxx[i,:] =  10. * np.log10( Pxx[i,:])
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
        pdist = [0] * self.spec.shape[1]
        index = int(self.speciesSurface.shape[1]/2)
        if self.step == 1:
            if len(self.distances)>0:
                pdist[index:(index+len(self.distances))] = self.distances
        else:
            i = 0
            for j in range(index,self.currColumns - self.columns,self.step):
                pdist[j] = self.distances[i]
                i = i + 1
            #for j in range(index,self.currColumns - self.columns - index,self.step):
            #    aa = [self.distances[i]] * self.step
            #    print len(aa)
            #    pdist[j:(j+index)] = aa
            #    i = i + 1
            #for j in range(index,self.spec.shape[1]-index ,self.step):
            #    print i,j
            #    reps = (min(j+self.step,self.spec.shape[1]-index))-j
            #    pdist[j:(min(j+self.step,self.spec.shape[1]-index))] = [self.distances[i]] * reps 
            #    i = i + 1
            start_index = index
            #for i in range(index):
            #    pdist2.append(None)
            #for v in self.distances:
            #    for i  in range(self.step):
            #        pdist2.append(v)
            #for i in range(index):
            #    pdist2.append(None)
            #for v in self.distances:
            #    print start_index 
            #    pdist[start_index:(start_index+(self.step))] = [v]*(self.step)
            #    start_index = start_index + (self.step)
            #print self.distances
            #print pdist
        ax1 = subplot(211)
        plot(pdist)
        subplot(212, sharex=ax1)
        ax = gca()
        im = ax.imshow(self.spec, None)
        ax.axis('auto')
        show()
        close()
        
    def showAudio(self):
        plot(self.rec.original)
        show()
        close()
        
    def showVect(self):
        plot(self.distances)
        show()
        close()
        
    def showspectrogram(self):
        imshow(self.spec)
        show()
        close()
        
    def showSurface(self):
        imshow(self.speciesSurface)
        show()
        close()
 
    def plots(self,s):
       fig, ax = subplots(figsize=(25, 15))
       ax.imshow(s,aspect='auto')
       show()
    
    def ransac(self):
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            if self.logs:
               self.logs.write("featureVector start")
            if self.logs:
               self.logs.write(self.uri)    
            self.distances = []
            currColumns = self.spec.shape[1]
            if self.oldModel:
                if self.logs:
                    self.logs.write("Backward compatibility mode")  
                freqs44100 = json.load(file('scripts/data/freqs44100.json'))['freqs']
                i = len(freqs44100) - 1
                j = i
                if self.logs:
                    self.logs.write('Searching frequencies')  
                while freqs44100[i] > self.high and i>=0:
                    j = j -1
                    i = i -1
                while freqs44100[j] > self.low and j>=0:
                    j = j -1
                if self.logs:
                    self.logs.write('Search done')  
                speclow = len(freqs44100) - j - 2
                spechigh = len(freqs44100) - i - 2
                if speclow >= len(freqs44100):
                    speclow = len(freqs44100)-1
                if spechigh < 0:
                    spechigh = 0
                self.matrixSurfacComp = numpy.copy(self.speciesSurface[spechigh:speclow,:])
            else:
                self.matrixSurfacComp = numpy.copy(self.speciesSurface[self.spechigh:self.speclow,:])
            removeUnwanted = self.matrixSurfacComp == -10000
            if len(removeUnwanted) > 0  :
                self.matrixSurfacComp[self.matrixSurfacComp[:,:]==-10000] = numpy.min(self.matrixSurfacComp[self.matrixSurfacComp != -10000])

            spec = self.spec
            spec = ((spec-numpy.min(numpy.min(spec)))/(numpy.max(numpy.max(spec))-numpy.min(numpy.min(spec))))*255
            spec = spec.astype('uint8')
            
            dect = None
            if self.algo == 'sift':
                dect = cv2.SIFT(nfeatures=0, nOctaveLayers=3, contrastThreshold=0.04, edgeThreshold=15, sigma=1.6)
            
            pat = self.matrixSurfacComp
            pat = ((pat-numpy.min(numpy.min(pat)))/(numpy.max(numpy.max(pat))-numpy.min(numpy.min(pat))))*255
            pat = pat.astype('uint8')          
            pat_kp, pat_des1 = dect.detectAndCompute(pat,None)
            
       
            self.plots(pat)
            self.plots(spec)
            MIN_MATCHES = 4
            for j in range(0,currColumns - self.columns,int(float(self.columns)/2.0)):
                specPiece = spec[:,j:(j+self.columns)]
                self.plots(specPiece)
                good = []
                spec_kp2, spec_des2 = dect.detectAndCompute(spec,None)
                FLANN_INDEX_KDTREE = 0
                index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 20)
                search_params = dict(checks = 200)
                flann = cv2.FlannBasedMatcher(index_params, search_params)  
                matches = flann.knnMatch(pat_des1,spec_des2,k=2)
                for m,n in matches:
                   if m.distance < 0.8*n.distance:
                       good.append(m)
                if len(good) >= MIN_MATCHES:
                    print 'matches',len(good)
                del matches
                del spec_kp2
                del spec_des2
                del good
                del specPiece
        #     spec = self.spec;
        #     self.currColumns = currColumns
        #     if self.logs:
        #         self.logs.write('Computing distances')

    

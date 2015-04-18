from pylab import *
import numpy
numpy.seterr(all='ignore')
numpy.seterr(divide='ignore', invalid='ignore')
import cPickle as pickle
import scipy
import math
from skimage.measure import structural_similarity as ssim
from samplerates import *
import warnings

class Roiset:   

    def __init__(self, classId,setSRate,logs=None,useDynamicRanging=False):
        
        """useDynamicRanging when ROI matrices are of zeros and ones (boolean matrices from the thresholder)"""
        
        if type(classId) is not str and type(classId) is not int:
            raise ValueError("classId must be a string or int. Input was a "+str(type(classId)))
        if type(setSRate) is not int and  type(setSRate) is not float:
            raise ValueError("setSRate must be a number")
        self.classId = classId
        self.roiCount = 0
        self.roi = [] 
        self.sampleLengths =[]
        self.rows = 0
        self.sampleRates = []
        self.setSampleRate = setSRate
        self.logs = logs
        self.useDynamicRanging = useDynamicRanging
        
    def addRoi(self,lowFreq,highFreq,sample_rate,spec,rows,columns):
        if len(self.sampleLengths) < 1:
            self.maxColumns = columns
            self.biggestIndex = 0
            self.varlengthsIndeces = []
            self.maxIndeces = []
            self.maxrois = []
            self.varlengths = set()
            self.maxrois.append(spec)
            self.maxIndeces.append(self.roiCount)
            self.lowestFreq = lowFreq
            self.highestFreq = highFreq
            self.highestlowestFreq = lowFreq
            self.lowesthighestFreq = highFreq
            self.biggestRoi = spec
            self.highestBand = highFreq - lowFreq
        else:
            highestBand = highFreq - lowFreq
            if self.maxColumns < columns:
                self.biggestIndex = self.roiCount + 1
                self.biggestRoi = spec
            if self.highestBand <= highestBand and self.maxColumns < columns:
                self.biggestRoi = spec
            if self.lowestFreq > lowFreq:
                self.lowestFreq = lowFreq
            if self.highestFreq < highFreq:
                self.highestFreq = highFreq
            if self.highestlowestFreq  < lowFreq:
                self.highestlowestFreq  = lowFreq
            if self.lowesthighestFreq > highFreq:
                self.lowesthighestFreq = highFreq
            if self.maxColumns < columns:
                self.varlengths.add(self.maxColumns)
                self.maxColumns = columns
                for i in self.maxIndeces:
                    self.varlengthsIndeces.append(i)
                self.maxIndeces = []
                self.maxIndeces.append(self.roiCount)
                self.maxrois = []
                self.maxrois.append(spec)
            elif self.maxColumns == columns:
                self.maxIndeces.append(self.roiCount)
                self.maxrois.append(spec)
            else:
                self.varlengthsIndeces.append(self.roiCount)
                self.varlengths.add(columns)
        self.sampleRates.append(sample_rate)    
        self.sampleLengths.append(columns)
        self.setSampleRate = max(self.sampleRates)
        self.rows = None
        self.roi.append(Roi(lowFreq,highFreq,sample_rate,spec))
        self.roiCount = self.roiCount + 1
    
    def getData(self):
        return [self.roi,self.rows,self.roiCount,self.biggestRoi,self.lowestFreq,self.highestFreq,self.maxColumns]
  
    def getSurface(self):
        return self.meanSurface
    
    def alignSamples(self):
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            if self.logs:
                self.logs.write("Roiset.py: set sample rate = "+str(self.setSampleRate))
            freqs = [i for i in reversed(get_freqs())]
            self.rows = len(freqs)
            big_high_index = 0
            big_low_index = 0
            if self.logs:
                self.logs.write("Roiset.py: high freq = "+str(self.highestFreq)+" low freq "+str(self.lowestFreq))
            while float(freqs[big_high_index]) >= float(self.highestFreq):
                big_high_index = big_high_index + 1
                big_low_index  = big_low_index  + 1
            if self.logs:
                self.logs.write("Roiset.py: search freqs ")
            while big_low_index <= (len(freqs)-1) and float(freqs[big_low_index ]) >=  float(self.lowestFreq) :
                big_low_index  = big_low_index  + 1
            if self.logs:
                self.logs.write("Roiset.py: freqs searched")
            big_low_index  = big_low_index -1
            big_high_index = big_high_index + 2
            if self.logs:
                self.logs.write("Roiset.py: creating temp computation space ")
            surface = numpy.zeros(shape=(self.rows,self.maxColumns*2))
            compsurface = numpy.random.rand(self.rows,self.maxColumns*2)
            if self.logs:
                self.logs.write("Roiset.py: done creating temp computation space ")
            jval = math.floor(self.maxColumns/2)
            surface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
            compsurface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
            if self.logs:
                self.logs.write("Roiset.py: weights initialization ")
            weights = numpy.zeros(shape=(self.rows,self.maxColumns*2))
            weights[big_high_index:big_low_index,jval:(jval+self.maxColumns)] = 1
            dm = 1
            minj = jval
            maxj = jval+self.maxColumns
            index = 0
            highcut = big_high_index
            lowcut = big_low_index
            if self.logs:
                self.logs.write("Roiset.py:start align ")
            cccc=0
            for roi in self.roi:
                cccc = cccc+1
                if self.logs:
                    self.logs.write("roi:"+str(cccc))
                if index is not self.biggestIndex:
                    high_index = 0
                    low_index = 0
                    while float(freqs[high_index]) >= float(roi.highFreq):
                        high_index = high_index + 1
                        low_index  = low_index  + 1
                    while float(freqs[low_index ]) >=  float(roi.lowFreq):
                        low_index  = low_index  + 1
                    low_index  = low_index  - 1
                    high_index = high_index + 2
                    distances = []
                    currColumns = roi.spec.shape[1]
                    compareArea = roi.spec[high_index:low_index,:]
                    winSize = min(compareArea.shape)
                    winSize = min(winSize,7)
                    if winSize %2 == 0:
                        winSize = winSize - 1
                    if winSize < 1:
                        winSize = 1
                    if self.useDynamicRanging:
                        for jj in range((self.maxColumns*2) -currColumns ): 
                            subMatrix =   compsurface[high_index:low_index, jj:(jj+currColumns)]
                            distances.append(ssim(subMatrix ,compareArea , win_size=winSize, gradient=False  , dynamic_range=dm) )
                    else:
                        for jj in range((self.maxColumns*2) -currColumns ): 
                            subMatrix =   compsurface[high_index:low_index, jj:(jj+currColumns)]
                            distances.append(ssim(subMatrix ,compareArea , win_size=winSize  ) )
                    j = distances.index(max(distances))
                    del distances
                    if minj > j :
                        minj = j
                    if maxj< j+currColumns:
                        maxj = j+currColumns
                    if highcut < high_index:
                        highcut = high_index
                    if lowcut   >  low_index:
                        lowcut   =  low_index
                    compsurface[high_index:low_index, j:(j+currColumns)] = compsurface[high_index:low_index, j:(j+currColumns)] + roi.spec[high_index:low_index, :]            
                    surface[high_index:low_index, j:(j+currColumns)] = surface[high_index:low_index, j:(j+currColumns)] + roi.spec[high_index:low_index, :]            
                    dm = dm + 1    
                    weights[high_index:low_index, j:(j+currColumns)] = weights[high_index:low_index, j:(j+currColumns)]  + 1
                index = index + 1
            self.meanSurface = numpy.divide(surface[:,minj:(maxj)],weights[:,minj:(maxj)])
            self.meanSurface[0:highcut,:] = -10000
            self.meanSurface[lowcut:(self.meanSurface.shape[0]-1),:] = -10000 
            self.maxColumns = self.meanSurface.shape[1]
            self.meanSurface[numpy.isnan(self.meanSurface)]   = -10000
            #imshow(self.meanSurface[big_high_index:big_low_index,:])
            #show()
            if self.logs:
                self.logs.write("Roiset.py: aligned "+str(len(self.roi))+" rois")
    
    def showSurface(self):
        ax1 = subplot(111)
        im = ax1.imshow(self.surface, None)
        ax1.axis('auto')
        show()
        close()

    def showMeanSurface(self):
        ax1 = subplot(111)
        im = ax1.imshow(self.meanSurface, None)
        ax1.axis('auto')
        show()
        close()

    def showStdSurface(self):
        ax1 = subplot(111)
        im = ax1.imshow(self.stdSurface, None)
        ax1.axis('auto')
        show()
        close()

class Roi:

    def __init__(self,lowFreq,highFreq,sample_rate,spec,bigflag=False):
        if type(lowFreq) is not int and  type(lowFreq) is not float:
            raise ValueError("lowFreq must be a number")
        if type(highFreq) is not int and  type(highFreq) is not float:
            raise ValueError("highFreq must be a number")
        if lowFreq>=highFreq :
            raise ValueError("lowFreq must be less than highFreq")
        if type(sample_rate) is not int and  type(sample_rate) is not float:
            raise ValueError("sample_rate must be a number")
        if type(spec) is not numpy.ndarray:
            raise ValueError("spec must be a numpy.ndarray. Input was a "+str(type(spec)))
        self.lowFreq = lowFreq
        self.highFreq = highFreq
        self.sample_rate = sample_rate
        self.spec = spec
        self.biggest = bigflag
    
    def getData(self):
        return [self.lowFreq,self.highFreq,self.sample_rate,self.spec]
    
    def showRoi(self):
        ax1 = subplot(111)
        im = ax1.imshow(self.spec, None)
        ax1.axis('auto')
        show()
        close()

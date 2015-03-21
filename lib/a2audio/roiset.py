from pylab import *
import numpy
numpy.seterr(all='ignore')
numpy.seterr(divide='ignore', invalid='ignore')
import cPickle as pickle
import scipy
import math
from skimage.measure import structural_similarity as ssim
from fullFrequencies import *

class Roiset:   

    def __init__(self, classId,setSRate,logs=None):
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
        self.rows = rows
        self.roi.append(Roi(lowFreq,highFreq,sample_rate,spec))
        self.roiCount = self.roiCount + 1
    
    def getData(self):
        return [self.roi,self.rows,self.roiCount,self.biggestRoi,self.lowestFreq,self.highestFreq,self.maxColumns]
  
    def getSurface(self):
        return self.meanSurface
    
    def alignSamples(self):
        if self.logs:
            self.logs.write("Roiset.py: set sample rate = "+str(self.setSampleRate))
        freqs = [i for i in reversed(get_freqs())]#[self.setSampleRate/2/(self.rows-1)*i for i in reversed(range(0,self.rows))]
        big_high_index = 0
        big_low_index = 0
        if self.logs:
            self.logs.write("Roiset.py: high freq = "+str(self.highestFreq)+" low freq "+str(self.lowestFreq))
        while float(freqs[big_high_index]) >= float(self.highestFreq):
            big_high_index = big_high_index + 1
            big_low_index  = big_low_index  + 1
        while float(freqs[big_low_index ]) >=  float(self.lowestFreq):
            big_low_index  = big_low_index  + 1
        big_low_index  = big_low_index -1
        big_high_index = big_high_index + 2
        surface = numpy.zeros(shape=(self.rows,self.maxColumns*2))
        compsurface = numpy.random.rand(self.rows,self.maxColumns*2)
        jval = math.floor(self.maxColumns/2)
        surface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
        compsurface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
        weights = numpy.zeros(shape=(self.rows,self.maxColumns*2))
        weights[big_high_index:big_low_index,jval:(jval+self.maxColumns)] = 1
        dm = 1
        minj = jval
        maxj = jval+self.maxColumns
        index = 0
        highcut = big_high_index
        lowcut = big_low_index
        for roi in self.roi:
            if index is not self.biggestIndex:
                high_index = 0
                low_index = 0
                while freqs[high_index] >= roi.highFreq:
                    high_index = high_index + 1
                    low_index  = low_index  + 1
                while freqs[low_index ] >=  roi.lowFreq:
                    low_index  = low_index  + 1
                distances = []
                currColumns = roi.spec.shape[1]
                compareArea = roi.spec[high_index:low_index,:]
                for jj in range((self.maxColumns*2) -currColumns ): 
                    subMatrix =   compsurface[high_index:low_index, jj:(jj+currColumns)]
                    #distances.append(ssim(subMatrix ,compareArea  , dynamic_range=dm ) )
                    distances.append(ssim(subMatrix ,compareArea   ) )
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
        if self.logs:
            self.logs.write("Roiset.py: aligned "+str(len(self.roi))+" rois")
            
    def alignSamples2(self):
        self.surface = numpy.sum(self.maxrois,axis=0)
        weights = numpy.zeros(shape=(self.rows,self.maxColumns))
        freqs = [self.setSampleRate/2/(self.rows-1)*i for i in reversed(range(0,self.surface.shape[0]))]
        high_index = 0
        low_index = 0
        while freqs[high_index] >= self.highestFreq:
            high_index = high_index + 1
            low_index  = low_index  + 1
        while freqs[low_index ] >=  self.lowestFreq:
            low_index  = low_index  + 1
        
        weights[high_index:low_index ,:] = weights[high_index:low_index ,:] + len(self.maxrois)
        
        for i in self.varlengthsIndeces:
            distances = []
            currColumns = self.roi[i].spec.shape[1]
            for j in range(self.maxColumns -currColumns ): 
                subMatrix =  self.surface[:, j:(j+currColumns)]
                distances.append(numpy.linalg.norm(subMatrix  - self.roi[i].spec) )
            j = distances.index(min(distances))
            temp = numpy.zeros(shape=(self.rows,self.maxColumns))
            temp[:, j:(j+currColumns)] = self.roi[i].spec
            self.maxrois.append(temp)
            self.surface[:, j:(j+currColumns)] = self.surface[:, j:(j+currColumns)] + self.roi[i].spec
            
            high_index = 0
            low_index = 0
            
            while freqs[high_index] >= self.roi[i].highFreq:
                high_index = high_index + 1
                low_index  = low_index  + 1
                
            while freqs[low_index ] >=  self.roi[i].lowFreq:
                low_index  = low_index  + 1
                
            weights[high_index:low_index, j:(j+currColumns)] = weights[high_index:low_index, j:(j+currColumns)]  + 1
            

        self.meanSurface = numpy.sum(self.maxrois,axis=0)
        self.meanSurface = numpy.divide(self.meanSurface,weights)
        self.stdSurface = numpy.std([self.maxrois[j] for j in range(self.roiCount)],axis=0)
            
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

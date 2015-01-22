from pylab import *
import numpy
numpy.seterr(divide='ignore', invalid='ignore')
import cPickle as pickle
import scipy
import math
from skimage.measure import structural_similarity as ssim

class Roiset:   

    def __init__(self, classId,setSRate):
        self.classId = classId
        self.roiCount = 0
        self.roi = [] 
        self.sampleLengths =[]
        self.rows = 0
        self.sampleRates = []
        self.setSampleRate = setSRate
        
    def addRoi(self,lowFreq,highFreq,sample_rate,spec,rows,columns):
        isthebigger = False
        if self.setSampleRate == sample_rate:
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
                    isthebigger = True
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
            self.rows = rows
            self.roi.append(Roi(lowFreq,highFreq,sample_rate,spec))
            self.roiCount = self.roiCount + 1
            
    def alignSamples(self):
        #saveob = []
        freqs = [self.setSampleRate/2/(self.rows-1)*i for i in reversed(range(0,self.rows))]
        big_high_index = 0
        big_low_index = 0
        while freqs[big_high_index] >= self.highestFreq:
            big_high_index = big_high_index + 1
            big_low_index  = big_low_index  + 1
        while freqs[big_low_index ] >=  self.lowestFreq:
            big_low_index  = big_low_index  + 1
        surface = numpy.zeros(shape=(self.rows,self.maxColumns*2))
        compsurface = numpy.random.rand(self.rows,self.maxColumns*2)
        jval = math.floor(self.maxColumns/2)
        surface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
        compsurface[:,jval:(jval+self.maxColumns)] = self.biggestRoi
        #saveob.append(numpy.copy(self.biggestRoi))
        #saveob.append(numpy.copy(surface))
        #saveob.append(numpy.copy(compsurface))
        weights = numpy.zeros(shape=(self.rows,self.maxColumns*2))
        weights[big_high_index:big_low_index,jval:(jval+self.maxColumns)] = 1
        #saveob.append(numpy.copy(weights))
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
                    distances.append(ssim(subMatrix ,compareArea  , dynamic_range=dm ) )
                j = distances.index(max(distances))
                #saveob.append(numpy.copy(distances))
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
                #saveob.append(numpy.copy(surface))
                #saveob.append(numpy.copy(weights))
                #saveob.append(numpy.copy(roi.spec[high_index:low_index, :]))
                #saveob.append(numpy.copy(compsurface))
            index = index + 1
        self.meanSurface = numpy.divide(surface[:,minj:(maxj)],weights[:,minj:(maxj)])
        self.meanSurface[0:highcut,:] = -10000
        self.meanSurface[lowcut:(self.meanSurface.shape[0]-1),:] = -10000 
        self.maxColumns = self.meanSurface.shape[1]
        #saveob.append(self.meanSurface)
        #saveob.append(numpy.copy(compsurface))
        #filename = '/home/rafa/debug_images.data'    
        #with open(filename, 'wb') as output:
            #pickler = pickle.Pickler(output, -1)
            #pickle.dump(saveob, output, -1)  
        self.meanSurface[numpy.isnan(self.meanSurface)]   = -10000
        
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
            
        #filename = '/home/rafa/debug_weights.data'    
        #with open(filename, 'wb') as output:
        #    pickler = pickle.Pickler(output, -1)
        #    pickle.dump([self.maxrois,weights], output, -1)
            
        #self.meanSurface = numpy.mean([self.maxrois[j] for j in range(self.roiCount)],axis=0)
        self.meanSurface = numpy.sum(self.maxrois,axis=0)
        self.meanSurface = numpy.divide(self.meanSurface,weights)
        self.stdSurface = numpy.std([self.maxrois[j] for j in range(self.roiCount)],axis=0)
        #self.meanSurface[self.meanSurface[:,:]==0] = numpy.min(numpy.min(self.meanSurface))
        #
        #for i in reversed(range(0,self.maxColumns)):
        #    if weights[0,i] < self.roiCount:
        #        weights = scipy.delete(weights, i, 1)
        #        self.meanSurface = scipy.delete(self.meanSurface, i, 1)
        #        self.stdSurface = scipy.delete(self.stdSurface, i, 1)
        #        self.surface = scipy.delete(self.surface, i, 1)
        #        
        #self.maxColumns = self.surface.shape[1]
        #freqs = [self.setSampleRate/2/(self.surface.shape[0]-1)*i for i in reversed(range(0,self.surface.shape[0]))]
        #
        #i =0
        #while freqs[i] >= self.lowesthighestFreq:
        #    self.meanSurface[i,:] = 0
        #    self.stdSurface[i,:] = 0
        #    self.surface[i,:] = 0
        #    i = i + 1
        #while freqs[i] >=  self.highestlowestFreq:
        #    i = i + 1
        #while i <  self.rows:
        #    self.meanSurface[i,:] = 0
        #    self.stdSurface[i,:] = 0
        #    self.surface[i,:] = 0
        #    i = i + 1
            
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
        self.lowFreq = lowFreq
        self.highFreq = highFreq
        self.sample_rate = sample_rate
        self.spec = spec
        self.biggest = bigflag

    def showRoi(self):
        ax1 = subplot(111)
        im = ax1.imshow(self.spec, None)
        ax1.axis('auto')
        show()
        close()

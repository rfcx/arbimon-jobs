from a2audio.rec import Rec
from a2audio.thresholder import Thresholder
from pylab import *
import numpy
import time
from a2pyutils.config import Config
from skimage.measure import structural_similarity as ssim
import cPickle as pickle
from scipy.stats import pearsonr as prs
from scipy.stats import kendalltau as ktau
from  scipy.spatial.distance import cityblock as ct
from scipy.spatial.distance import cosine as csn
import math
from scipy.stats import *
from  scipy.signal import *

class Recanalizer:
    
    def __init__(self, uri, speciesSurface, low, high, columns, tempFolder, logs=None, bucket=None):
        start_time = time.time()
        self.low = float(low)
        self.high = float(high)
        self.columns = speciesSurface.shape[1]#int(columns)
        self.speciesSurface = speciesSurface
        self.logs = logs
        configuration = Config()
        config = configuration.data()
        if self.logs:
           self.logs.write(uri)    
        self.uri = uri
        if self.logs:
           self.logs.write(self.uri)    
        if self.logs :
            self.logs.write("configuration time --- seconds ---" + str(time.time() - start_time))
        start_time = time.time()
        self.rec = Rec(uri,tempFolder,config,'bucketname',logs)
        if self.logs:
            self.logs.write("retrieving recording from bucket --- seconds ---" + str(time.time() - start_time))
        if self.rec.status == 'HasAudioData':
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
        self.tempFolder = tempFolder
        
    def getVector(self ):
        return self.distances
    
    def features(self):
        fs = periodogram(self.distances,nfft=20)[1]
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
        if self.logs:
           self.logs.write("featureVector start")
        if self.logs:
           self.logs.write(self.uri)    
        pieces = self.uri.split('/')
        filename = '/home/rafa/debugs_pickels/'+pieces[len(pieces)-1]+".pickle"
        self.distances = []
        currColumns = self.spec.shape[1]
        step = int(self.spec.shape[1]*.05) # 10 percent of the pattern size
        if self.logs:
           self.logs.write("featureVector in here")     
        self.matrixSurfacComp = numpy.copy(self.speciesSurface[self.lowIndex:self.highIndex,:]).astype('int')
        if self.logs:
           self.logs.write("featureVector write start")
           
        #with open(filename, 'wb') as output:
        #    pickler = pickle.Pickler(output, -1)
        #    pickle.dump([self.spec,self.matrixSurfacComp], output, -1)
        #    
        if self.logs:
           self.logs.write("featureVector write end")            
        spec = self.spec;
        for j in range(0,currColumns - self.columns,step): 
            #self.distances.append(self.matrixDistance(numpy.copy(spec[: , j:(j+self.columns)])) )
            val = ssim( numpy.copy(spec[: , j:(j+self.columns)]).astype('int') , self.matrixSurfacComp  , dynamic_range=1)
            if val < 0:
               val = 0
            self.distances.append(  val   )
        if self.logs:
           self.logs.write("featureVector end")
           
    def matrixDistance(self,a,stype=2):
        #val = 0
        
        #if stype == 1: #original from RAB thesis (frobenius norm of the difference, squared l2-norm?)
        #    val = numpy.linalg.norm(a  - self.matrixSurfacComp)
        #
        #if stype == 2: # SSIM (structural similarity)
        val = ssim(a,self.matrixSurfacComp)
        if val < 0:
            val = 0
    
        #if stype == 3: # Mean Squared Error 
        #    val = ((a - self.matrixSurfacComp) ** 2).mean(axis=None)
        #
        #if stype == 4: # Pearson correlation coefficient 
        #    val = prs((numpy.asarray(a)).reshape(-1) , (numpy.asarray(self.matrixSurfacComp)).reshape(-1) )[0]
        #    if val < 0:
        #        val = 0
        #        
        #if stype == 5: # Kendall's tau
        #   val = ktau(a,self.matrixSurfacComp)[0]
        #   if val < 0:
        #       val = 0
        #       
        #if stype == 6: # Manhattan distance. 
        #    val = ct(np.asarray(a).reshape(-1) , np.asarray(self.matrixSurfacComp).reshape(-1))
        #    if val < 0:
        #        val = 0
        #        
        #if stype == 7: # Cosine distance. 
        #    val = csn(np.asarray(a).reshape(-1) , np.asarray(self.matrixSurfacComp).reshape(-1))
        #    if val < 0:
        #        val = 0
        #        
        #if stype == 8: # L1-norm
        #    val = numpy.linalg.norm(a  - self.matrixSurfacComp,ord=1)
            
        return val
    
    def spectrogram(self):

        start_time = time.time()
        Pxx, freqs, bins = mlab.specgram(self.rec.original, NFFT=512, Fs=self.rec.sample_rate , noverlap=256)
        dims =  Pxx.shape
        if self.logs:
            self.logs.write("mlab.specgram --- seconds ---" + str(time.time() - start_time))

        i =0
        j = 0
        start_time = time.time()
        while freqs[i] < self.low:
            j = j + 1
            i = i + 1
        
        #calculate decibeles in the passband
        while freqs[i] < self.high:
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
            
        Z = np.flipud(Z)
        if self.logs:
            self.logs.write('logs and flip ---' + str(time.time() - start_time))
            
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

from pylab import *
import numpy as np
import math
import random
from scipy import interpolate
import scipy

syl_types = { 'spline' :{} }
spline_types = {'overlaping':{},'nonoverlaping':{}}

class Spline(object):
    def __init__(self,xsize,ysize):
        self.xsize = xsize
        self.ysize = ysize
        self.sig = None
        
    def gen_random_spline_signature(self,spline_type = 'nonoverlaping'):
        num_of_points = random.randint(3,6)
        self.spline_type = spline_type
        if spline_type not in spline_types:
            self.spline_type = 'nonoverlaping'
        sig = {}
        if spline_type == 'nonoverlaping':
            for i in range(num_of_points):
                x=random.randint(0,self.xsize)
                y=random.randint(0,self.ysize)
                sig[i]= {'x':x,'y':y}
        elif spline_type == 'overlaping':
            print 'not yet implemented'
        self.sig = sig 
    
    def test_sig(self):
        x = []
        y = []
        for s in self.sig:
            xx,yy = self.gen_random_point(self.sig[s]['x'],self.sig[s]['y'])
            x.append(xx)
            y.append(yy)
        try:
            tck,u = interpolate.splprep([x,y], s=0)
            return True
        except:
            return False
                
    def gen_spline(self):
        x = []
        y = []
        for s in self.sig:
            xx,yy = self.gen_random_point(self.sig[s]['x'],self.sig[s]['y'])
            x.append(xx)
            y.append(yy)
            
        tck,u = interpolate.splprep([x,y], s=0)
        
        unew = np.arange(0, 1.01, 0.01)
        out = interpolate.splev(unew, tck)
        return out[0], out[1]
        
    def gen_random_point(self,x,y,tol=2):
        xx=randint(x-tol,x+tol)
        yy=randint(y-tol,y+tol)
        if xx < 0:
            xx = 0
        if yy <0:
            yy = 0
        if xx >= self.xsize:
            xx = self.xsize - 1
        if yy >= self.ysize:
            yy = self.ysize - 1
        return xx,yy
    
class Species(object):
    
    def __init__(self,syllables=1,syl_type='spline',f_min = 3000 ,f_max = 4000,dur = .5 ,sample_rate = 44100,y_size = 256, noisy = False):
        self.syl_type = syl_type
        if syl_type not in syl_types:
            self.syl_type='spline'
        self.f_min = f_min
        self.f_max = f_max
        self.dur = dur
        self.sample_rate = sample_rate
        self.y_size = y_size
        self.noisy = noisy
        self.x_size_samples = int(math.ceil(self.dur*self.sample_rate))
        self.x_size = self.x_size_samples/y_size
        self.syllables = syllables
        if noisy:
            self.matrix = np.random.rand(self.y_size,self.x_size)
        else:
            self.matrix = np.zeros(shape=(self.y_size,self.x_size))
        
        self.padding = 0.01 #secs
        self.padding = int(math.ceil(self.padding*self.sample_rate))
        self.splineX = self.x_size #- self.padding*2
        self.maxFreq = float(self.sample_rate)/2.0
        self.binFreq = float(self.maxFreq)/float(y_size)
        f = float(self.maxFreq)
        self.high_freq_index = y_size-1
        while float(f) > float(f_max):
            f = f - self.binFreq
            self.high_freq_index = self.high_freq_index - 1
        self.low_freq_index = self.high_freq_index
        while float(f) > float(f_min):
            f = f - self.binFreq
            self.low_freq_index = self.low_freq_index - 1
        
        self.splineY = (self.high_freq_index-self.low_freq_index)
        self.sp = Spline(self.splineX,self.splineY)

        self.sp.gen_random_spline_signature()
        while not self.sp.test_sig():
            self.sp.gen_random_spline_signature()
            
    def gen_random_individual(self):
        ind = self.matrix/2
        v = 0.01
        for i in range(ind.shape[0]):
            ind[i,] = ind[i,] - v
            v = v + 0.005
        mm = np.mean(np.mean(ind))
        
        xx,yy = self.sp.gen_spline()
        for i in range(len(xx)):
            try:
                ind[self.low_freq_index+int(yy[i]),int(xx[i])] = 0.95 
            except:
                """ """
            try:
                ind[self.low_freq_index+int(yy[i]),int(xx[i])+1] = 0.95 
            except:
                """ """
            try:
                ind[self.low_freq_index+int(yy[i]),int(xx[i])-1] = 0.95 
            except:
                """ """
            try:
                ind[self.low_freq_index+int(yy[i]+1),int(xx[i])] = 0.95 
            except:
                """ """
            try:
                ind[self.low_freq_index+int(yy[i]-1),int(xx[i])] = 0.95 
            except:
                """ """
        return np.flipud(ind)
    
    def gen_recording(self,calls=10,dur=10):
        x_size_samples = int(math.ceil(dur*self.sample_rate))
        x_size = x_size_samples/self.y_size
        if self.noisy:
            ind = np.random.rand(self.y_size,x_size)
        else:
            ind = np.zeros(shape=(self.y_size,x_size))
        mm = np.mean(np.mean(ind))
        sylDur = self.dur
        remainingDur = dur
        spos = 0
        epos = self.x_size*2
        cCount = 0
        poss = []
        for i in range(calls):
            spos = random.randint(spos,epos)
            epos = random.randint(max(spos,epos),epos)
            xx,yy = self.sp.gen_spline()
            hasSpline = False
            for i in range(len(xx)):
                try:
                    ind[self.low_freq_index+int(yy[i]),spos+int(xx[i])] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]),spos+int(xx[i])+1] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]),spos+int(xx[i])-1] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]+1),spos+int(xx[i])] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]-1),spos+int(xx[i])] = 0.95
                    hasSpline = True
                except:
                    """ """        
                try:
                    ind[self.low_freq_index+int(yy[i]),spos+int(xx[i])+2] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]),spos+int(xx[i])-2] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]+2),spos+int(xx[i])] = 0.95
                    hasSpline = True
                except:
                    """ """
                try:
                    ind[self.low_freq_index+int(yy[i]-2),spos+int(xx[i])] = 0.95
                    hasSpline = True
                except:
                    """ """
            j = random.randint(int(float(x_size)/float(calls)),int(float(x_size*2)/float(calls)))
            if hasSpline:
                cCount =  cCount + 1
                poss.append(spos+int(xx[i]))
            spos = spos + j
            epos = epos + j
        return np.flipud(ind),cCount,poss
    
    def get_audio(self, spec ):
       cols = spec.shape[1]
       x = scipy.zeros(cols*spec.shape[0])
       j = 0
       for i in range(cols):
           x[j:(j+spec.shape[0])] = scipy.real(scipy.ifft(spec[:,i]))
           j = j + spec.shape[0]
       return x       
    
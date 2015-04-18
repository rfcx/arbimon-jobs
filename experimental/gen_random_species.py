from pylab import *
import numpy as np
import math
import random

syl_types = { 'spline' :{} }
spline_types = {'overlaping':{},'nonoverlaping':{}}

class Spline(object):
    def __init__(self,xsize,ysize):
        self.xsize = xsize
        self.ysize = ysize
        
    def gen_random_spline_signature(self,spline_type = 'nonoverlaping'):
        num_of_points = 3
        self.spline_type = spline_type
        if spline_type not in spline_types:
            self.spline_type = 'nonoverlaping'
        
        if spline_type == 'nonoverlaping':
            for i in range(num_of_points):
                print "point",i
        elif spline_type == 'overlaping':
            print 'not yet implemented'
            
    def gen_spline(self):
        pass
    
    def gen_random_point(self,xmi,xma,ymi,yma):
        pass
        #return randint(xmi,xma),randint(ymi,yma)
    
class Species(object):
    
    def __init__(self,syllables=1,syl_type='spline',f_min = 2000 ,f_max = 4000,dur = .5 ,sample_rate = 44100,y_size = 512, noisy = True):
        self.syl_type = syl_type
        if syl_type not in syl_types:
            self.syl_type='spline'
        self.f_min = f_min
        self.f_max = f_max
        self.dur = dur
        self.sample_rate = sample_rate
        self.y_size = y_size
        self.noisy = noisy
        self.x_size = int(math.ceil(self.dur*self.sample_rate))
        self.syllables = syllables
        if noisy:
            self.matrix = np.random.rand(self.y_size,self.x_size)
        else:
            self.matrix = np.zeros(shape=(self.y_size,self.x_size))

    def gen_random_individual(self):
        pass
    
    def gen_species_group(self):
        pass
    def save_species_group(self):
        pass
    def load_species_group(self):
        pass

    
    def view(self):
        pass
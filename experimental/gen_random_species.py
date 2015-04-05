from pylab import *
import numpy as np
import math

syl_types = { 'spline' :{} }

class Syllable(object):
    
    def __init__(self,syl_type='spline',f_min = 2000 ,f_max = 4000,dur = .5 ,sample_rate = 44100,y_size = 512, noisy = True):
        self.syl_type = syl_type
        self.f_min = f_min
        self.f_max = f_max
        self.dur = dur
        self.sample_rate = sample_rate
        self.y_size = y_size
        self.noisy = noisy
        self.x_size = int(math.ceil(self.dur*self.sample_rate))
        
        if noisy:
            self.matrix = np.random.rand(self.y_size,self.x_size)
        else:
            self.matrix = np.zeros(shape=(self.y_size,self.x_size))

    def gen_random_spline_signature(self):
        pass

    def gen_spline(self):
        pass
    
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
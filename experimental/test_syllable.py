import unittest
from mock import MagicMock
from pylab import *
import scipy.io.wavfile
import numpy
import subprocess
import os
import random

class Test_syllable(unittest.TestCase):

    def test_dev(self):
        import sys
        sys.path.append('/home/rafa/node/arbimon2-jobs/lib')
        if 'gen_random_species' in sys.modules:
            del sys.modules['gen_random_species']
        from gen_random_species import Species
        
        sp = Species(syllables=1,syl_type='spline',f_min = 3000 ,f_max = 5000,dur = .5 ,sample_rate = 44100,y_size = 256, noisy = False)
        spec,cc,pos = sp.gen_recording(calls=15,dur=10)
        print cc
        au = sp.get_audio(spec)
        spec2,a,b=mlab.specgram(au,NFFT=512,Fs=44100,noverlap=256)
        imshow(10*log10(np.flipud(spec2[1:,])))
        show()
        
        response = raw_input("Do you like it? (y) ")
        recCount = 30
        #response = 'n'
        del au
        if response == 'y':
            f = open('/home/rafa/Desktop/rec-stats.csv','w')
            for i in range(recCount):
                rr,count,pos = sp.gen_recording(calls=random.randint(5,15),dur=10)
                au = sp.get_audio(rr)
                scipy.io.wavfile.write( '/tmp/t.wav', 44100 , au)
                del au

                #mix ambient noise
                proc = subprocess.Popen([
                   '/usr/bin/sox', '-m',
                   '/tmp/t.wav' , 'amb.wav' , '/tmp/t2.wav'
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = proc.communicate()
                sstr = '0'+str(i)
                if int(i) >= 10:
                    sstr = str(i)
                proc = subprocess.Popen([
                   '/usr/bin/sox',
                   '/tmp/t2.wav' , '/home/rafa/Desktop/rec-2010-12-14_00-'+str(sstr)+'.wav' 
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = proc.communicate()
                os.remove('/tmp/t.wav')
                os.remove('/tmp/t2.wav')
                f.write( '/home/rafa/Desktop/rec-2010-12-14_00-'+str(sstr)+'.wav'+","+str(count)+","+','.join( [str(i) for i in pos])+'\n')
            f.close()    
                
if __name__ == '__main__':
    unittest.main()




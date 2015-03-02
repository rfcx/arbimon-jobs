import unittest

class Test_roizer(unittest.TestCase):
    
    def test_import(self):
        """Test Roizer module can be imported"""
        try:
            from a2audio.roizer import Roizer
        except ImportError:
            self.fail("Cannot load a2audio.roizer module")
            
    def test_init(self):
        """Test Roizer init arguments"""
        from a2audio.roizer import Roizer
        
        #test invalid combinations of arguments
        self.assertRaises(ValueError,Roizer,1,"/tmp","dummyBucket",1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp",1,"dummyBucket",1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/invalidfolder","dummyBucket",1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp",1,1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket","1",10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket",1,"10",1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket",1,10,"1000",2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket",1,10,1000,"2000")
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket",100,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp","dummyBucket",1,10,10000,2000)
        
        #test valid combinations of arguments
        self.assertIsInstance(Roizer("/tmp","/tmp","dummyBucket",0,1,1000,2000),Roizer)
 
    def test_recording(self):
        """Test Roizer rec(cording) instance"""
        from a2audio.roizer import Roizer
        import warnings
        import numpy as np
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        currentRoizer = Roizer("test/short.wav","/tmp/","arbimon2",0,1,1000,2000)
        self.assertIsInstance(currentRoizer,Roizer)
        auSamples = currentRoizer.getAudioSamples()
        correctStreamTest = None
        with closing(Sndfile('test_python/data/short.wav')) as f:     
            correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
        self.assertEqual(len(auSamples),len(correctStreamTest),msg="Roizer.init streams have different lenghts")
        for i in range(len(auSamples)):
            self.assertEqual(auSamples[i],correctStreamTest[i],msg="Roizer.init streams have different data")
   
    def test_spectrogram(self):
        """Test Roizer.spectrogram function"""
        
if __name__ == '__main__':
    unittest.main()

import unittest
from test_python.framework.mocks import Mock_BotoBucketStorage

MOCK_STORAGE = Mock_BotoBucketStorage()
MOCK_STORAGE.set_file_list({
    "test/short.wav"  : {'file':'test_python/data/bucket_short.wav'},
    "test/short.flac" : {'file':'test_python/data/bucket_short.flac'}
})

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
        self.assertRaises(ValueError,Roizer,1,"/tmp", MOCK_STORAGE,1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp",1, MOCK_STORAGE,1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/invalidfolder", MOCK_STORAGE,1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", 1,1,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,"1",10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,1,"10",1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,1,10,"1000",2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,1,10,1000,"2000")
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,100,10,1000,2000)
        self.assertRaises(ValueError,Roizer,"/tmp","/tmp", MOCK_STORAGE,1,10,10000,2000)
        
        #test valid combinations of arguments
        self.assertIsInstance(Roizer("/tmp/","/tmp/", MOCK_STORAGE,0,1,1000,2000),Roizer)

    def test_recording(self):
        """Test Roizer rec(cording) instance"""
        from a2audio.roizer import Roizer
        import warnings
        import numpy as np
        import json
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        recordingsTest = None
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        for rec in recordingsTest:
            currentRoizer = Roizer(str(rec['a2Uri']),"/tmp/", MOCK_STORAGE,rec['roizerParams'][0],rec['roizerParams'][1],rec['roizerParams'][2],rec['roizerParams'][3])
            self.assertIsInstance(currentRoizer,Roizer)
            auSamples = currentRoizer.getAudioSamples()
            correctStreamTest = None
            with closing(Sndfile(str(rec['local']))) as f:     
                correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
            self.assertEqual(len(auSamples),len(correctStreamTest),msg="Roizer.init streams have different lenghts")
            del currentRoizer
            del correctStreamTest
            del auSamples
   
    def test_spectrogram(self):
        """Test Roizer.spectrogram function"""
        from a2audio.roizer import Roizer
        import cPickle as pickle
        import numpy
        import json
        import sys
        is_64bits = sys.maxsize > 2**32
        recordingsTest = None
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        for rec in recordingsTest:
            currentRoizer = Roizer(str(rec['a2Uri']),"/tmp/", MOCK_STORAGE,rec['roizerParams'][0],rec['roizerParams'][1],rec['roizerParams'][2],rec['roizerParams'][3])
            spectrogram = currentRoizer.getSpectrogram()
            self.assertIsInstance(spectrogram,numpy.ndarray,msg="Roizer.spectrogram invalid spectrogram")
            compSpec=None
            if is_64bits:
                with open(str(rec['filteredSpec']), 'rb') as specFile:
                    compSpec=pickle.load(specFile)
            else:
                with open(str(rec['filteredSpec'])+".32", 'rb') as specFile:
                    compSpec=pickle.load(specFile)
            for i in range(spectrogram.shape[0]):
                for j in range(spectrogram.shape[1]):
                    self.assertEqual(spectrogram[i,j],compSpec[i,j],msg="Roizer.spectrogram saved wrong spec: "+str(rec['a2Uri']))
            del currentRoizer
            del spectrogram
            del compSpec
        
if __name__ == '__main__':
    unittest.main()

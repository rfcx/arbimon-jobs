import unittest
import mock
from test_python.framework.mocks import Mock_BotoBucketStorage

MOCK_STORAGE = Mock_BotoBucketStorage()

class MockRec(object):
    sample_rate = 0
    original = []
    def __init__(self):
        self.sample_rate = 48000
        for i in range(self.sample_rate):
            self.original.append(i)

def os_access_false(p,a):
    return False

def os_path_exists_false(p):
    return False

def os_access_true(p,a):
    return True

def os_path_exists_true(p):
    return True

def gen_stripped_matrix(rows,cols):
    """Generates random stripped matrix"""
    import numpy
    chunckLength = 20
    randomStart = 10
    chucnkJump = 3
    chunckLessLength = chunckLength*chucnkJump
    chunks = int((float(cols-randomStart))/(float(chunckLessLength+chunckLength)))
    mm = numpy.zeros(shape=(rows,cols))
    jump = 0
    for i in range(randomStart,cols-chunckLength,chunckLength):
        if jump == 0:
            mm[:,i:(i+chunckLength)] = numpy.ones(shape=(rows,chunckLength))
        jump = (jump+1)%chucnkJump
    return mm

class Test_recanalizer(unittest.TestCase):

    def test_import(self):
        """Test Recanalizer module can be imported"""
        try:
            from a2audio.recanalizer import Recanalizer
        except ImportError:
            self.fail("Cannot load a2audio.recanalizer module")
            
    def test_init(self):
        """Test Recanalizer init arguments"""
        from a2audio.recanalizer import Recanalizer
        from a2pyutils.logger import Logger
        import numpy
        import shutil
        spec = numpy.random.rand(100,100)
        logs = Logger(1,'Recanalizer','test')
        raisingargs3 =[
            [1,spec,1000,2000,"/tmp/", MOCK_STORAGE,logs],
            ["test/short.wav",1,1000,2000,"/tmp/", MOCK_STORAGE,logs],
            ["test/short.wav",spec,"s",2000,"/tmp/", MOCK_STORAGE,logs],
            ["test/short.wav",spec,1000,'s',"/tmp/", MOCK_STORAGE,logs],
            ["test/short.wav",spec,1000,2000,"/invalidfolder", MOCK_STORAGE,logs],
            ["test/short.wav",spec,1000,2000,1, MOCK_STORAGE,logs],
            ["test/short.wav",spec,1000,2000,"/tmp/", None,logs],
            ["test/short.wav",spec,1000,2000,"/tmp/", MOCK_STORAGE,1],
        ]
        with mock.patch('os.path.exists', os_path_exists_false, create=False):
            with mock.patch('os.access', os_access_false, create=False):
                for ar in raisingargs3:
                    self.assertRaises(ValueError,Recanalizer,ar[0],ar[1],ar[2],ar[3],ar[4],ar[5],ar[6],True)
        with mock.patch('os.path.exists', os_path_exists_true, create=False):
            with mock.patch('os.access', os_access_true, create=False):                   
                self.assertIsInstance( Recanalizer("test/short.wav",spec,1000,2000,"/tmp/", MOCK_STORAGE,None,True) ,Recanalizer,msg="Cannot create a Recanalizer object")
                self.assertIsInstance( Recanalizer("test/short.wav",spec,1000,2000,"/tmp/", MOCK_STORAGE,logs,True) ,Recanalizer,msg="Cannot create a Recanalizer object")
                self.assertIsInstance( Recanalizer("test/short.wav",spec,1000,2000,"/tmp/", MOCK_STORAGE,logs,False) ,Recanalizer,msg="Cannot create a Recanalizer object")
        shutil.rmtree('/tmp/logs/')

    def test_spectrogram(self):
        """Test Recanalizer.spectrogram funtion"""
        from a2audio.recanalizer import Recanalizer
        from a2audio.rec import Rec
        import warnings
        import json
        import numpy
        import sys
        import cPickle as pickle
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        recordingsTest = None
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        spec = gen_stripped_matrix(1116,50)
        is_64bits = sys.maxsize > 2**32
        for rec in recordingsTest:
            recanalizerInstance = Recanalizer(str(rec['a2Uri']),spec,rec['roizerParams'][2],rec['roizerParams'][3],"/tmp/", MOCK_STORAGE,None,True)
            self.assertIsInstance( recanalizerInstance ,Recanalizer,msg="Cannot create a Recanalizer object")
            recanalizerInstance.rec = MockRec()
            recanalizerInstance.spectrogram()
            spectrogram = recanalizerInstance.getSpec()
            compSpec=None
            if is_64bits:
                with open(str(rec['recanalizerSpec']), 'rb') as specFile:
                    compSpec=pickle.load(specFile)
            else:
                with open(str(rec['recanalizerSpec'])+".32", 'rb') as specFile:
                    compSpec=pickle.load(specFile)
            for i in range(spectrogram.shape[0]):
                for j in range(spectrogram.shape[1]):
                    self.assertEqual(spectrogram[i,j],compSpec[i,j],msg="Recanalizer.spectrogram saved wrong spec: "+str(rec['a2Uri']))
            del spectrogram
            del compSpec
            del recanalizerInstance
        del spec
        
    def test_featureVector(self):
        """Test Recanalizer.featureVector fucntion"""
        from a2audio.recanalizer import Recanalizer
        from a2audio.rec import Rec
        import warnings
        import json
        import numpy
        import sys
        import cPickle as pickle
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        recordingsTest = None
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        spec = gen_stripped_matrix(1116,50)
        for rec in recordingsTest:
            recanalizerInstance = Recanalizer(str(rec['a2Uri']),spec,rec['roizerParams'][2],rec['roizerParams'][3],"/tmp/", MOCK_STORAGE,None,True)
            self.assertIsInstance( recanalizerInstance ,Recanalizer,msg="Cannot create a Recanalizer object")
            recanalizerInstance.rec = MockRec()
            recanalizerInstance.spectrogram()
            recanalizerInstance.featureVector()
            currVector = recanalizerInstance.getVector()
            vectStats = recanalizerInstance.features()
            compVector =  None
            is_64bits = sys.maxsize > 2**32
            if is_64bits:
                with open(str(rec['featureVector']), 'rb') as specFile:
                    compVector=pickle.load(specFile)
            else:
                with open(str(rec['featureVector'])+".32", 'rb') as specFile:
                    compVector=pickle.load(specFile)
            compVectorStats =  None
            if is_64bits:
                with open(str(rec['featureVectorStats']), 'rb') as specFile:
                    compVectorStats=pickle.load(specFile)
            else:
                with open(str(rec['featureVectorStats'])+".32", 'rb') as specFile:
                    compVectorStats=pickle.load(specFile)
            for j in range(len(currVector)):
                self.assertEqual(currVector[j],compVector[j],msg="Roecanalizer.featureVector computed wrong vector")
            for j in range(len(compVectorStats)):
                self.assertEqual(compVectorStats[j],vectStats[j],msg="Roecanalizer.featureVector computed wrong features")
            del currVector
            del recanalizerInstance
            del compVectorStats
            del compVector
            del vectStats
        del spec
        
if __name__ == '__main__':
    unittest.main()

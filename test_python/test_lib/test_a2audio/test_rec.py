import unittest
import imp
import json
import os
import shutil
import mock
from mock import patch
import struct
from mock import mock_open
from mock import MagicMock
import numpy
from contextlib import contextmanager
from test_python.framework.mocks import Mock_BotoBucketStorage

MOCK_STORAGE = Mock_BotoBucketStorage()

mock_file_data = []
class mock_file(object):
    def __init__(self ):
        pass
    def read(self ):
        import numpy
        data = numpy.random.rand(1)
        mock_file_data.append(float(data))
        return float(data)
    
def mock_urlopen(url):
    retFile = mock_file()
    return retFile

mock_sndfile_data = []
mock_sndfile_close_calls = []
class mock_sndfile(object):
    encoding = 'PCM16'
    channels = 1
    nframes = 44100
    samplerate = 44100
    samples = None
    
    def read_frames(self,n,dtype=numpy.dtype('int16')):
        return self.samples[0:(n)]
    def __init__(self,filen):
        global mock_sndfile_data
        self.filen = filen
        self.samples = numpy.random.rand(self.nframes)
        mock_sndfile_data.append(self.samples)
    def __exit__(self,a,b,c):
        pass
    def __enter__(self):
        pass
    def close(self):
        global mock_sndfile_close_calls
        mock_sndfile_close_calls.append(self.filen)
        
    def write_frames(self,data):
        global mock_sndfile_data
        mock_sndfile_data.append(data)
    
@contextmanager           
def mock_closing(filen):
    mm = mock_sndfile(filen)
    try:
        yield mm
    finally:
        mm.close()

class Test_rec(unittest.TestCase):

    def test_import(self):
        """Test Rec module can be imported"""
        try:
            from a2audio.rec import Rec
        except ImportError:
            self.fail("Cannot load a2audio.rec module")

    @patch('os.path.isfile')
    @patch('os.access')
    @patch('os.path.exists')
    @patch('time.time')
    def test_init(self,time_time,os_path_exists,os_access,os_path_isfile):
        time_time.return_value = 123456789
        os_path_exists.return_value = False
        os_access.return_value = False
        os_path_isfile.return_value = False
        sys_maxint = pow(2 , 8 * struct.calcsize("P") -1) - 1
        """Test Rec init arguments"""
        from a2audio.rec import Rec
        from a2pyutils.logger import Logger
        
        """Test invalid arguments"""
        raisingargs3 =[
            [1,"/tmp","dummyBucket"],
            ["/tmp",1,"dummyBucket"],
            ["/tmp","/invalidfolder","dummyBucket"],
            ["/tmp","/tmp",1]
        ]
        
        with mock.patch('sys.maxint', sys_maxint , create=False):
            for ar in raisingargs3:
                self.assertRaises(ValueError,Rec,ar[0],ar[1],ar[2])
            
            self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",1)
            logs = Logger(1,'Rec','test',False)
            self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",logs,1)
            self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",logs,False,1)
            os_path_exists.return_value = True
            os_access.return_value = True          
            """Test valid arguments"""
            self.assertIsInstance( Rec("/tmp/","/tmp/", MOCK_STORAGE,logs,False,True) ,Rec)
            self.assertIsInstance( Rec("/tmp/","/tmp/", MOCK_STORAGE,None,True,True) ,Rec)        

    @patch('os.path.isfile')
    @patch('os.access')
    @patch('os.path.exists')
    @patch('time.time')        
    def test_getLocalFileLocation(self,time_time,os_path_exists,os_access,os_path_isfile):
        time_time.return_value = 123456789
        os_path_exists.return_value = False
        os_access.return_value = False
        os_path_isfile.return_value = False
        sys_maxint = pow(2 , 8 * struct.calcsize("P") -1) - 1
        """Test Rec.getLocalFileLocation function"""
        from a2audio.rec import Rec
        with mock.patch('sys.maxint', sys_maxint , create=False):
            os_path_exists.return_value = True
            os_access.return_value = True
            rec_test = Rec("test/test.wav","/tmp/", MOCK_STORAGE,None,True,True)
            rec_test.setLocalFileLocation('test_python/data/test.wav')
            os_path_isfile.return_value = True
            self.assertEqual('test_python/data/test.wav',rec_test.getLocalFileLocation(True),msg="Rec.getLocalFileLocation returned invalid location")
            self.assertEqual('test_python/data/test.wav',rec_test.getLocalFileLocation(),msg="Rec.getLocalFileLocation returned invalid location")
 
    @patch('os.path.isfile')
    @patch('os.access')
    @patch('os.path.exists')
    @patch('time.time')
    def test_getAudioFrames(self,time_time,os_path_exists,os_access,os_path_isfile):
        time_time.return_value = 123456789
        os_path_exists.return_value = False
        os_access.return_value = False
        os_path_isfile.return_value = False
        sys_maxint = pow(2 , 8 * struct.calcsize("P") -1) - 1
        """Test Rec.getAudioFrames function"""
        from a2audio.rec import Rec
        with mock.patch('sys.maxint', sys_maxint , create=False):
            os_path_exists.return_value = True
            os_access.return_value = True
            rec_test = Rec("test/test.wav","/tmp/", MOCK_STORAGE,None,True,True)
            for i in range(1000):
                rec_test.appendToOriginal(i)
            data_test = rec_test.getAudioFrames()
            for i in range(1000):
                self.assertEqual(i,data_test[i],msg="Rec.getAudioFrames returned invalid data")

    @patch('os.path.isfile')
    @patch('os.access')
    @patch('os.path.exists')
    @patch('time.time')
    def test_getAudioFromUri(self,time_time,os_path_exists,os_access,os_path_isfile):
        global mock_file_data
        import numpy
        time_time.return_value = 123456789
        os_path_exists.return_value = False
        os_access.return_value = False
        os_path_isfile.return_value = False
        sys_maxint = pow(2 , 8 * struct.calcsize("P") -1) - 1
        """Test Rec.getAudioFromUri function"""
        from a2audio.rec import Rec
        import filecmp
        recordingsTest = None
        m =  mock_open()
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        with mock.patch('urllib2.urlopen', mock_urlopen , create=False):
            with mock.patch('sys.maxint', sys_maxint , create=False):
                with mock.patch('__builtin__.open',m, create=False):
                    m.return_value = MagicMock(spec=file)
                    os_path_exists.return_value = True
                    os_access.return_value = True
                    for rec in recordingsTest:
                        rec_test = Rec(str(rec['a2Uri']),"/tmp/", MOCK_STORAGE,None,True,True)
                        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
                        rec_test.getAudioFromUri()
                        self.assertIsNone(m.assert_any_call(rec_test.getLocalFileLocation(True), 'wb'),msg="Rec.getAudioFromUri: file open function not called")
                        del rec_test
                    h =  m.return_value.__enter__.return_value
                    for data in mock_file_data:
                        self.assertIsNone(h.write.assert_any_call(data),msg="Rec.getAudioFromUri: wrote invalid data")
        
    def test_parseEncoding(self):
        """Test Rec.parseEncoding function"""
        from a2audio.rec import Rec
        rec_testing = Rec("/tmp/","/tmp/", MOCK_STORAGE,None,True,True)
        self.assertIsInstance( rec_testing ,Rec,msg="Cannot create Rec object")
        encodings = None
        with open('test_python/data/encodings.json') as fd:
            encodings = json.load(fd)
        for e in encodings:
            val = rec_testing.parseEncoding(e)
            correct = encodings[e]
            self.assertEqual(val,correct,msg="Cannot parseEncoding "+e+". Got "+str(val)+". Correct is "+str(correct) )
    
    def test_readAudioFromFile(self):
        """Test Rec.readAudioFromFile function"""
        global mock_sndfile_data
        from a2audio.rec import Rec
        import warnings
        import numpy as np
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        recordingsTest = None
        with open('test_python/data/recordings.json') as fd:
            recordingsTest= json.load(fd)
        j = 0
        with mock.patch('contextlib.closing', mock_closing , create=False):
            for rec in recordingsTest:    
                rec_test = Rec(str(rec['a2Uri']),"/tmp/", MOCK_STORAGE,None,False,True)
                self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
                rec_test.setLocalFileLocation(str(rec['local']))
                rec_test.readAudioFromFile()
                audioStreamTest = rec_test.getAudioFrames()
                correctStreamTest = mock_sndfile_data[j]
                j = j + 1
                self.assertEqual(rec_test.status,'AudioInBuffer',msg="Rec.readAudioFromFile unexpected status")
                self.assertEqual(len(audioStreamTest),len(correctStreamTest),msg="Rec.readAudioFromFile streams have different lenghts")   
                for i in range(len(audioStreamTest)):
                    self.assertEqual(audioStreamTest[i],correctStreamTest[i],msg="Rec.readAudioFromFile streams have different data")
                del rec_test
                del audioStreamTest
                del correctStreamTest
                
    @patch('os.path.isfile')
    @patch('os.remove')
    def test_removeFiles(self,os_remove,os_path_isfile):
        """Test Rec.removeFiles function"""
        global mock_sndfile_data
        global mock_sndfile_close_calls
        from a2audio.rec import Rec
        os_path_isfile.return_value = False
        removeFileFlag = True
        rec_test = Rec("test/short.wav","/tmp/", MOCK_STORAGE,None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.setLocalFileLocation("test_python/data/short.wav")
        rec_test.removeFiles()
        self.assertIsNone(os_path_isfile.assert_any_call("test_python/data/short.wav"),msg="Rec.removeFiles: os path isfile was not called")
        self.assertEqual(0,len(os_remove.mock_calls),msg="Rec.removeFiles: os remove was called with os path is file return False")
        os_path_isfile.return_value = True       
        rec_test.removeFiles()
        self.assertIsNone(os_remove.assert_any_call("test_python/data/short.wav"),msg="Rec.removeFiles: os remove was not called")
        del rec_test
        
        removeFileFlag = False
        os_path_isfile.return_value = False
        rec_test = Rec("test/short.wav","/tmp/", MOCK_STORAGE,None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.setLocalFileLocation("test_python/data/short.wav")
        os_path_isfile.reset_mock()
        rec_test.removeFiles()
        self.assertEqual(0,len(os_path_isfile.mock_calls),msg="Rec.removeFiles: os_path_isfile was called with removeFileFlag False")
        del rec_test

        os_remove.reset_mock()
        os_path_isfile.reset_mock()
        os_path_isfile.return_value = False
        removeFileFlag = True
        rec_test = Rec("test/short.flac.test","/tmp/", MOCK_STORAGE,None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.setLocalFileLocation("test_python/data/short.flac.test")
        rec_test.removeFiles()
        self.assertIsNone(os_path_isfile.assert_any_call("test_python/data/short.flac.test"),msg="Rec.removeFiles: os path isfile was not called")
        self.assertEqual(0,len(os_remove.mock_calls),msg="Rec.removeFiles: os remove was called with os path is file return False and flac file")
        os_path_isfile.return_value = True       
        rec_test.removeFiles()
        self.assertIsNone(os_remove.assert_any_call("test_python/data/short.flac.test"),msg="Rec.removeFiles: os remove was not called")
        del rec_test        
  
        audiolab_Format = MagicMock()
        audiolab_Sndfile = MagicMock()
        with mock.patch('a2audio.rec.Sndfile', audiolab_Sndfile, create=False):
            with mock.patch('a2audio.rec.Format', audiolab_Format, create=False):
                removeFileFlag = False
                os_path_isfile.return_value = False
                audiolab_Format.return_value = "WavFormat"
                audiolab_Sndfile.return_value = mock_sndfile("test/short.flac.test")
                rec_test = Rec("test/short.flac.test","/tmp/", MOCK_STORAGE,None,removeFileFlag,True)
                self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
                os_path_isfile.return_value = True
                rec_test.setLocalFileLocation("test_python/data/short.flac.test")
                origTest = numpy.random.rand(1000)
                for ii in origTest:
                    rec_test.appendToOriginal(ii)
                os_path_isfile.reset_mock()
                os_remove.reset_mock()
                mock_sndfile_data = []
                mock_sndfile_close_calls = []
                rec_test.removeFiles()
                self.assertIsNone(audiolab_Format.assert_any_call("wav"),msg="Rec.removeFiles: Format was not called")
                self.assertEqual(0,len(os_path_isfile.mock_calls),msg="Rec.removeFiles: os_path_isfile was called with removeFileFlag False")
                self.assertIsNone(audiolab_Sndfile.assert_any_call('test_python/data/short.flac.test.wav', 'w', 'WavFormat', 0, 0),msg="Rec.removeFiles: Sndfile was not called")
                compTest = mock_sndfile_data[0]        
                for ii in range(len(origTest)):
                    self.assertEqual( compTest[ii],origTest[ii],msg="Rec.removeFiles: invalid data wrote to file")
                self.assertEqual(mock_sndfile_close_calls[0],"test/short.flac.test",msg="Rec.removeFiles: Sndfile.close was not called")
                self.assertIsNone(os_remove.assert_any_call('test_python/data/short.flac.test'),msg="Rec.removeFiles: the original flac file was not removed os_Remove")
                del rec_test

if __name__ == '__main__':
    unittest.main()

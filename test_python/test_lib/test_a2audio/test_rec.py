import unittest
import imp
import json
import os
import shutil
import mock
from mock import patch
import struct

class mock_file(object):
    def __init__(self ):
        pass
    def read(self ):
        return 'this'
    
    
def mock_urlopen(url):
    retFile = mock_file()
    return retFile

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
            self.assertIsInstance( Rec("/tmp/","/tmp/","dummyBucket",logs,False,True) ,Rec)
            self.assertIsInstance( Rec("/tmp/","/tmp/","dummyBucket",None,True,True) ,Rec)        

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
            rec_test = Rec("test/test.wav","/tmp/","arbimon2",None,True,True)
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
            rec_test = Rec("test/test.wav","/tmp/","arbimon2",None,True,True)
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
        time_time.return_value = 123456789
        os_path_exists.return_value = False
        os_access.return_value = False
        os_path_isfile.return_value = False
        sys_maxint = pow(2 , 8 * struct.calcsize("P") -1) - 1
        """Test Rec.getAudioFromUri function"""
        from a2audio.rec import Rec
        import filecmp
        recordingsTest = None
        with mock.patch('urllib2.urlopen', mock_urlopen , create=False):
            with mock.patch('sys.maxint', sys_maxint , create=False):
                os_path_exists.return_value = True
                os_access.return_value = True
                with open('test_python/data/recordings.json') as fd:
                    recordingsTest= json.load(fd)
                for rec in recordingsTest:
                    rec_test = Rec(str(rec['a2Uri']),"/tmp/","arbimon2",None,True,True)
                    self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
                    print rec_test.getAudioFromUri()
                    #self.assertTrue(os.path.isfile(rec_test.getLocalFileLocation()),msg="Rec.getAudioFromUri failed to get audio file")
                    #self.assertTrue(filecmp.cmp(rec_test.getLocalFileLocation(),str(rec['local'])),msg="Rec.getAudioFromUri donwloaded file is corrupt")
                    #os.remove(rec_test.getLocalFileLocation());
                    #del rec_test
        
    def dtest_parseEncoding(self):
        """Test Rec.parseEncoding function"""
        from a2audio.rec import Rec
        rec_testing = Rec("/tmp/","/tmp/","dummyBucket",None,True,True)
        self.assertIsInstance( rec_testing ,Rec,msg="Cannot create Rec object")
        encodings = None
        with open('test_python/data/encodings.json') as fd:
            encodings = json.load(fd)
        for e in encodings:
            val = rec_testing.parseEncoding(e)
            correct = encodings[e]
            self.assertEqual(val,correct,msg="Cannot parseEncoding "+e+". Got "+str(val)+". Correct is "+str(correct) )
    
    def dtest_readAudioFromFile(self):
        """Test Rec.readAudioFromFile function"""
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
        for rec in recordingsTest:    
            rec_test = Rec(str(rec['a2Uri']),"/tmp/","arbimon2",None,True,True)
            self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
            rec_test.getAudioFromUri()
            rec_test.readAudioFromFile()
            audioStreamTest = rec_test.getAudioFrames()
            correctStreamTest = None
            with closing(Sndfile(str(rec['local']))) as f:     
                correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
            self.assertEqual(rec_test.status,'AudioInBuffer',msg="Rec.readAudioFromFile unexpected status")
            self.assertEqual(len(audioStreamTest),len(correctStreamTest),msg="Rec.readAudioFromFile streams have different lenghts")   
            for i in range(len(audioStreamTest)):
                self.assertEqual(audioStreamTest[i],correctStreamTest[i],msg="Rec.readAudioFromFile streams have different data")
            if rec_test.getLocalFileLocation():
                os.remove(rec_test.getLocalFileLocation())
            del rec_test
            del audioStreamTest
            del correctStreamTest
        
    def dtest_removeFiles(self):
        """Test Rec.removeFiles function"""
        from a2audio.rec import Rec
        
        removeFileFlag = True
        rec_test = Rec("test/short.wav","/tmp/","arbimon2",None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        rec_test.readAudioFromFile()
        localFile = rec_test.getLocalFileLocation()
        rec_test.removeFiles()
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
        del rec_test
        if(os.path.isfile(localFile )):
            os.remove(localFile)
            
        removeFileFlag = False
        rec_test = Rec("test/short.wav","/tmp/","arbimon2",None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        rec_test.readAudioFromFile()
        localFile = rec_test.getLocalFileLocation()
        rec_test.removeFiles()
        self.assertTrue(os.path.isfile(localFile),msg="Rec.removeFiles file was not kept")
        del rec_test
        if(os.path.isfile(localFile)):
            os.remove(localFile)
            
        removeFileFlag = True
        rec_test = Rec("test/short.flac","/tmp/","arbimon2",None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        rec_test.readAudioFromFile()
        localFile = rec_test.getLocalFileLocation()
        rec_test.removeFiles()
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles flac file was not removed")
        localFile = localFile.replace('.flac','.wav')
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
        del rec_test
        if(os.path.isfile(localFile )):
            os.remove(localFile)
            
        removeFileFlag = False
        rec_test = Rec("test/short.flac","/tmp/","arbimon2",None,removeFileFlag,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        rec_test.readAudioFromFile()
        localFile = rec_test.getLocalFileLocation()
        rec_test.removeFiles()
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles flac file was not removed")
        localFile = localFile+'.wav'
        self.assertTrue(os.path.isfile(localFile),msg="Rec.removeFiles file was not kept")
        if(os.path.isfile(localFile )):
            os.remove(localFile)
        if(os.path.isfile(localFile+'.wav' )):
            os.remove(localFile+'.wav')

    def dtest_process(self):
        """Test Rec.process function"""
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
        for rec in recordingsTest:
            rec_test = Rec(str(rec['a2Uri']),"/tmp/","arbimon2",None,True,True)
            self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
            localFile = rec_test.getLocalFileLocation(True)
            rec_test.process()
            self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
            audioStreamTest = rec_test.getAudioFrames()
            correctStreamTest = None
            with closing(Sndfile(str(rec['local']))) as f:     
                correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
            self.assertEqual(rec_test.status,'HasAudioData',msg="Rec.readAudioFromFile unexpected status")
            self.assertEqual(len(audioStreamTest),len(correctStreamTest),msg="Rec.readAudioFromFile streams have different lenghts")   
            for i in range(len(audioStreamTest)):
                self.assertEqual(audioStreamTest[i],correctStreamTest[i],msg="Rec.readAudioFromFile streams have different data")
            filePath = rec_test.getLocalFileLocation()
            if filePath is not None:
                if(os.path.isfile(filePath)):
                    os.remove(filePath)
            if(os.path.isfile(localFile)):
                os.remove(localFile)
            del rec_test
            del audioStreamTest
            del correctStreamTest
            del filePath
            del localFile
     
    def dtest_usage(self):
        """Test Rec intended usage"""
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
        for rec in recordingsTest:            
            rec_test = Rec(str(rec['a2Uri']),"/tmp/","arbimon2")
            self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
            localFile = rec_test.getLocalFileLocation(True)
            self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
            audioStreamTest = rec_test.getAudioFrames()
            correctStreamTest = None
            with closing(Sndfile(str(rec['local']))) as f:     
                correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
            self.assertEqual(rec_test.status,'HasAudioData',msg="Rec.readAudioFromFile unexpected status")
            self.assertEqual(len(audioStreamTest),len(correctStreamTest),msg="Rec.readAudioFromFile streams have different lenghts")   
            for i in range(len(audioStreamTest)):
                self.assertEqual(audioStreamTest[i],correctStreamTest[i],msg="Rec.readAudioFromFile streams have different data")
            filePath = rec_test.getLocalFileLocation()
            if filePath is not None:
                if(os.path.isfile(filePath)):
                    os.remove(filePath)
            if(os.path.isfile(localFile)):
                os.remove(localFile)
            del rec_test
            del audioStreamTest
            del correctStreamTest
            del filePath
            del localFile
            
if __name__ == '__main__':
    unittest.main()

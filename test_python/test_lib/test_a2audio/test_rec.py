import unittest
import imp
import json
import os
import shutil

class Test_rec(unittest.TestCase):

    def test_import(self):
        """Test Rec module can be imported"""
        try:
            from a2audio.rec import Rec
        except ImportError:
            self.fail("Cannot load a2audio.rec module")

    def test_init(self):
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
        
        for ar in raisingargs3:
            self.assertRaises(ValueError,Rec,ar[0],ar[1],ar[2])
        
        self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",1)
        logs = Logger('test','Rec','test')
        self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",logs,1)
        self.assertRaises(ValueError,Rec,"/tmp","/tmp","dummyBucket",logs,False,1)
        
        """Test valid arguments"""
        self.assertIsInstance( Rec("/tmp","/tmp","dummyBucket",logs,False,True) ,Rec)
        self.assertIsInstance( Rec("/tmp","/tmp","dummyBucket",None,True,True) ,Rec)
        
        shutil.rmtree('/tmp/logs/')
        
    def test_getLocalFileLocation(self):
        """Test Rec.getLocalFileLocation function"""
        from a2audio.rec import Rec
        rec_test = Rec("test/test.wav","/tmp/","arbimon2",None,True,True)
        rec_test.setLocalFileLocation('test_python/data/test.wav')
        self.assertEqual('test_python/data/test.wav',rec_test.getLocalFileLocation(),msg="Rec.getLocalFileLocation returned invalid location")

    def test_getAudioFrames(self):
        """Test Rec.getAudioFrames function"""
        from a2audio.rec import Rec
        rec_test = Rec("test/test.wav","/tmp/","arbimon2",None,True,True)
        for i in range(1000):
            rec_test.appendToOriginal(i)
        data_test = rec_test.getAudioFrames()
        for i in range(1000):
            self.assertEqual(i,data_test[i],msg="Rec.getAudioFrames returned invalid data")
        
    def test_getAudioFromUri(self):
        """Test Rec.getAudioFromUri function"""
        from a2audio.rec import Rec
        import filecmp
        rec_test = Rec("test/short.wav","/tmp/","arbimon2",None,True,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        self.assertTrue(os.path.isfile(rec_test.getLocalFileLocation()),msg="Rec.getAudioFromUri failed to get audio file")
        self.assertTrue(filecmp.cmp(rec_test.getLocalFileLocation(),'test_python/data/short.wav'),msg="Rec.getAudioFromUri donwloaded file is corrupt")
        os.remove(rec_test.getLocalFileLocation());
        
    def test_parseEncoding(self):
        """Test Rec.parseEncoding function"""
        from a2audio.rec import Rec
        rec_testing = Rec("/tmp","/tmp","dummyBucket",None,True,True)
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
        from a2audio.rec import Rec
        rec_test = Rec("test/short.wav","/tmp/","arbimon2",None,True,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        rec_test.getAudioFromUri()
        rec_test.readAudioFromFile()
        audioStreamTest = rec_test.getAudioFrames()
        import warnings
        import numpy as np
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        correctStreamTest = None
        with closing(Sndfile('test_python/data/short.wav')) as f:     
            correctStreamTest = f.read_frames(f.nframes,dtype=np.dtype('int16'))
        self.assertEqual(rec_test.status,'AudioInBuffer',msg="Rec.readAudioFromFile unexpected status")
        self.assertEqual(len(audioStreamTest),len(correctStreamTest),msg="Rec.readAudioFromFile streams have different lenghts")   
        for i in range(len(audioStreamTest)):
            self.assertEqual(audioStreamTest[i],correctStreamTest[i],msg="Rec.readAudioFromFile streams have different data")
        if rec_test.getLocalFileLocation():
            os.remove(rec_test.getLocalFileLocation())
        
    def test_removeFiles(self):
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

    def test_process(self):
        """Test Rec.process function"""
        from a2audio.rec import Rec
        
        rec_test = Rec("test/short.wav","/tmp/","arbimon2",None,True,True)
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        localFile = rec_test.getLocalFileLocation(True)
        rec_test.process()
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
 
        audioStreamTest = rec_test.getAudioFrames()
        import warnings
        import numpy as np
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        correctStreamTest = None
        with closing(Sndfile('test_python/data/short.wav')) as f:     
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
     
    def test_usage(self):
        """Test Rec intended usage"""
        from a2audio.rec import Rec
        
        rec_test = Rec("test/short.wav","/tmp/","arbimon2")
        self.assertIsInstance( rec_test ,Rec,msg="Cannot create Rec object")
        localFile = rec_test.getLocalFileLocation(True)
        self.assertFalse(os.path.isfile(localFile),msg="Rec.removeFiles file was not removed")
 
        audioStreamTest = rec_test.getAudioFrames()
        import warnings
        import numpy as np
        from contextlib import closing
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            from scikits.audiolab import Sndfile, Format
        correctStreamTest = None
        with closing(Sndfile('test_python/data/short.wav')) as f:     
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
            
if __name__ == '__main__':
    unittest.main()

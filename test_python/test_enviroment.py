import unittest
import imp
import json
import warnings

def load(lib):
    path = None
    try:
        fp,path,desc = imp.find_module(lib)
    except:
        """do nothing"""
    return path
    
class Test_enviroment(unittest.TestCase):
    def test_libs_imports(self):
        libs = None
        with open('test_python/data/libs.json') as fd:
            libs = json.load(fd)
        for i in libs:
            self.assertIsNotNone(load(i),msg="Lib "+i+" is not installed in current enviroment")

    def test_sampleratelib(self):
        try:
            from scikits.samplerate import resample
        except:
            self.fail("Lib scikits.samplerate is not installed in current enviroment")
            
    def test_scikits_audiolab(self):
        try:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                from scikits.audiolab import Sndfile, Format
        except:
            self.fail("Lib scikits.audiolab is not installed in current enviroment")

if __name__ == '__main__':
    unittest.main()

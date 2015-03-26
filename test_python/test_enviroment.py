import unittest
import imp
import json

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

if __name__ == '__main__':
    unittest.main()

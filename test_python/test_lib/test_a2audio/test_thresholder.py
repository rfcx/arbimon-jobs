import unittest
from mock import MagicMock
import cPickle as pickle

class Test_thresholder(unittest.TestCase):

    def test_import(self):
        try:
            from a2audio.thresholder import Thresholder
        except ImportError:
            self.fail("Cannot load a2audio.thresholder module")
    
    def test_thresholds(self):
        from a2audio.thresholder import Thresholder
        import numpy
        
        matrices = []
        funcs = {'global':{'otsu','median','isodata','yen'} ,
         'adaptive':{ 'gaussian', 'mean', 'median'}}
        
        with open('test_python/data/thresholds.matrices', 'rb') as output:
            matrices=pickle.load(output)   
        orig = matrices[0]
        i=1
        for f in funcs:
            for m in funcs[f]:
                cc = Thresholder(f,m).apply(orig)
                tt = matrices[i]
                for j in range(orig.shape[0]):
                    for k in range(orig.shape[1]):
                        self.assertEqual(cc[j,k],tt[j,k],msg="a2audio.thresholder returned wrong matrix")
                i = i + 1        
        
if __name__ == '__main__':
    unittest.main()

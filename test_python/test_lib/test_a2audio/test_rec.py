import unittest
import imp
import json

class Test_rec(unittest.TestCase):

    def test_import(self):
        try:
            from a2audio.rec import Rec
        except ImportError:
            self.fail("Cannot load a2audio.rec module")

    def test_init(self):
        print 'init'
    
    def test_parseEncoding(self):
        from a2audio.rec import Rec
        rec_testing = Rec("/tmp/dummy","dummy","dummy",None,True,True)
        encodings = None
        with open('test_python/data/encodings.json') as fd:
            encodings = json.load(fd)
        for e in encodings:
            val = rec_testing.parseEncoding(e)
            correct = encodings[e]
            self.assertEqual(val,correct,msg="Cannot parseEncoding "+e+". Got "+str(val)+". Correct is "+str(correct) )
            
if __name__ == '__main__':
    unittest.main()

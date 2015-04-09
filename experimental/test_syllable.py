import unittest
from mock import MagicMock

class Test_syllable(unittest.TestCase):

    def test_dev(self):
        import sys
        sys.path.append('/home/rafa/node/arbimon2-jobs/lib')
        if 'gen_random_species' in sys.modules:
            del sys.modules['gen_random_species']
        from gen_random_species import Syllable
        
        syl = Syllable()
        
        #print dir(syl)
        
if __name__ == '__main__':
    unittest.main()




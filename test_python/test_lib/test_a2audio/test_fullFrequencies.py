import unittest

class Test_fullFrequencies(unittest.TestCase):

    def test_freqs(self):
        try:
            from a2audio.fullFrequencies import get_freqs
        except ImportError:
            self.fail("Cannot load a2audio.fullFrequencies module")
        
        fs = get_freqs()
        self.assertEqual(len(fs),1116,msg="a2audio.fullFrequencies the length of the frequencies vector is incorrect")
        self.assertEqual(round(fs[2]-fs[1],10),round(86.0215053763,10),msg="a2audio.fullFrequencies the banwidth of the frequencies vector is incorrect")
        
if __name__ == '__main__':
    unittest.main()

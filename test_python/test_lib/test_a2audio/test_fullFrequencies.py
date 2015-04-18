import unittest

class Test_fullFrequencies(unittest.TestCase):

    def test_import(self):
        try:
            from a2audio.fullFrequencies import get_freqs
        except ImportError:
            self.fail("Cannot load a2audio.fullFrequencies module")
            
    def test_freqs(self):
        from a2audio.fullFrequencies import get_freqs
        fs = get_freqs()
        self.assertEqual(len(fs),4464,msg="a2audio.fullFrequencies the length of the frequencies vector is incorrect")
        self.assertEqual(round(fs[2]-fs[1],10),round(21.50537634408602,10),msg="a2audio.fullFrequencies the banwidth of the frequencies vector is incorrect")
        
if __name__ == '__main__':
    unittest.main()

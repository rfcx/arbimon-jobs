import unittest

class Test_roiset(unittest.TestCase):
    
    def test_import(self):
        """Test Roiset module can be imported"""
        try:
            from a2audio.roiset import Roiset
        except ImportError:
            self.fail("Cannot load a2audio.roiset module")

if __name__ == '__main__':
    unittest.main()


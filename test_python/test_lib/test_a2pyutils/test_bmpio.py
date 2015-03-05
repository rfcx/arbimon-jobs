import unittest

class Test_bmpio(unittest.TestCase):

    def test_import(self):
        """Test bmpio.Writer module can be imported"""
        try:
            from a2pyutils.bmpio import Writer
        except ImportError:
            self.fail("Cannot load a2pyutils.bmpio.Writer module")
            
    def test_init(self):
        """Test bmpio.Writer init arguments"""
        from a2pyutils.bmpio import Writer
        import a2pyutils.palette as pl
        self.assertIsInstance( Writer() , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10,8) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10,8,pl.get_palette()) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")

    def test_write(self):
        """Test bmpio.Writer write function"""
        import a2pyutils.bmpio
        import filecmp
        import a2pyutils.palette as pl
        import os
        W = a2pyutils.bmpio.Writer
        fileout = "/tmp/bmpio.test.writer.bmp"
        w = W(width=1, height=255, bitdepth=8, palette=pl.get_palette())
        with file(fileout, "wb") as fout:
            w.write(fout, [[i] for i in range(255)])
        self.assertTrue(os.path.isfile(fileout),msg="a2pyutils.bmpio.Writer failed to write bmp file")
        self.assertTrue(filecmp.cmp(fileout,"test_python/data/bmpio.test.writer.bmp"),msg="a2pyutils.bmpio.Writer written bmp file is corrupt")
        if(os.path.isfile(fileout )):
            os.remove(fileout)
        
if __name__ == '__main__':
    unittest.main()

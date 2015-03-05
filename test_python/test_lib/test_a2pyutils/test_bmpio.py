import unittest
import mock
from mock import mock_open
from a2pyutils.bmpio import Writer
import struct

class Test_bmpio(unittest.TestCase):

    def test_import(self):
        """Test bmpio.Writer module can be imported"""
        try:
            from a2pyutils.bmpio import Writer
        except ImportError:
            self.fail("Cannot load a2pyutils.bmpio.Writer module")
            
    def test_init(self):
        """Test bmpio.Writer init arguments"""
        import a2pyutils.palette as pl
        self.assertIsInstance( Writer() , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10,8) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")
        self.assertIsInstance( Writer(10,10,8,pl.get_palette()) , Writer,msg="a2pyutils.bmpio.Writer initiation was not succesful")

    def test_write(self):
        """Test bmpio.Writer write function"""
        import a2pyutils.bmpio
        import a2pyutils.palette as pl
        W = Writer
        fileout = "/tmp/bmpio.test.writer.bmp"
        w = W(width=1, height=255, bitdepth=8, palette=pl.get_palette())
        m = mock_open()
        with mock.patch('__builtin__.open', m, create=True):
            with open(fileout, 'w') as fout:
                w.write(fout, [[i] for i in range(255)])
            self.assertTrue(m.called,msg="bmpio.Writer failed to call open method")
            self.assertIsNone(m.assert_called_once_with(fileout, 'w'),msg="bmpio.Writer failed to write file")
            handle = m()
            for ii in range(255):
                self.assertIsNone(handle.write.assert_any_call(struct.pack('<B',ii)),msg="bmpio.Writer failed to write some values")

if __name__ == '__main__':
    unittest.main()

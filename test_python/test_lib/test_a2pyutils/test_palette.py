import unittest
from mock import MagicMock
import json
import mock
from mock import patch

class Test_palette(unittest.TestCase):

    def test_import(self):
        try:
            from a2pyutils.palette import get_palette
        except ImportError:
            self.fail("Cannot load a2pyutils.palette.get_palette function")
        try:
            from a2pyutils.palette import export_palette
        except ImportError:
            self.fail("Cannot load a2pyutils.palette.export_palettee function")
        try:
            from a2pyutils.palette import get_palette
        except ImportError:
            self.fail("Cannot load a2pyutils.palette.print_hex function")
    
    def test_get_palette(self):
        """Test get_palette function"""
        from a2pyutils.palette import get_palette
        with open('test_python/data/palettes.json') as fd:
            palettesTest= json.load(fd)
        for i in range(5):
            palet = get_palette(i)
            compPalet = palettesTest[i]
            for j in range(len(palet)):
                for k in range(3):
                   self.assertEqual( palet[j][k],compPalet[j][k],msg="a2pyutils.palette.get_palette : Wrong palette value")
    
    @patch("png.Writer")
    @patch("a2pyutils.bmpio.Writer")
    @patch('__builtin__.file')
    def test_export_palette(self,mock_file,bmpio_Writer,png_Writer):
        """Test export palette function"""
        from a2pyutils.palette import export_palette
        #png_Writer.return_value = 'Garbage'
        with open('test_python/data/palettes.json') as fd:
            palettesTest= json.load(fd)
        for i in range(5):
            compPalet = palettesTest[i]
            export_palette(compPalet,"/sdfsfd/dummy"+str(i)+".png")
            export_palette(compPalet,"/sdfsfd/dummy"+str(i)+".bmp")
            mock_file.assert_any_calls("/sdfsfd/dummy"+str(i)+".png", 'wb')
            mock_file.assert_any_calls("/sdfsfd/dummy"+str(i)+".bmp", 'wb')
            bmpio_Writer.assert_any_calls(width=2, palette=compPalet, bitdepth=8, height=256)
            png_Writer.assert_any_calls(width=1, palette=compPalet, bitdepth=8, height=256)
        
if __name__ == '__main__':
    unittest.main()

import unittest

class Test_colors(unittest.TestCase):

    def test_import_AbstractGradient(self):
        """Test colors.AbstractGradient module can be imported"""
        try:
            from a2pyutils.colors import AbstractGradient
        except ImportError:
            self.fail("Cannot load a2pyutils.colors.AbstractGradient module")

    def test_import_MatPlotLibGradient(self):
        """Test colors.MatPlotLibGradient module can be imported"""
        try:
            from a2pyutils.colors import MatPlotLibGradient
        except ImportError:
            self.fail("Cannot load a2pyutils.colors.MatPlotLibGradient module")
            
    def test_import_LinearGradient(self):
        """Test colors.LinearGradient module can be imported"""
        try:
            from a2pyutils.colors import LinearGradient
        except ImportError:
            self.fail("Cannot load a2pyutils.colors.LinearGradient module")

    def test_import_MultiGradient(self):
        """Test colors.MultiGradient module can be imported"""
        try:
            from a2pyutils.colors import MultiGradient
        except ImportError:
            self.fail("Cannot load a2pyutils.colors.MultiGradient module")
            
    def test_colors(self):
        """Test colors usage init arguments"""
        from a2pyutils import colors
        import pylab
        import cPickle as pickle
        import sys
        palette = [
            colors.MultiGradient([
                colors.LinearGradient(
                    [[43/60.0, 1.0, .9], [31/60.0, 1.0, .9]], spacetx=colors.hsv2rgb
                ),
                colors.LinearGradient(
                    [[23/60.0, 1.0, .9], [11/60.0, 1.0, .9]], spacetx=colors.hsv2rgb
                ),
                colors.LinearGradient(
                    [[10/60.0, 1.0, .9], [6/60.00, 0.3, .9]], spacetx=colors.hsv2rgb
                ),
                colors.LinearGradient(
                    [[0x90, 0x61, 0x24], [0xea, 0xca, 0xb9]], norm_scale=255.0
                )
            ], 255).get_palette(256),
            [[255-i, 255-i, 255-i] for i in range(256)],
        ]
        
        for x in pylab.cm.datad:
            if (x in ['hot','jet'] or 'gist_' in x) and '_r' not in x:
                palette.append(colors.MatPlotLibGradient(x, 255).get_palette(256))
        is_64bits = sys.maxsize > 2**32
        testfilename = 'test_python/data/colors.test.gradients'
        if not is_64bits:
            testfilename = 'test_python/data/colors.test.gradients.32'           
        cpmpalette = None
        with open(testfilename, 'rb') as dataFile:
            cpmpalette = pickle.load( dataFile)
        cc = 0
        for i in range(len(cpmpalette)):
            for j in range(len(cpmpalette[i])):
                for z in range(len(cpmpalette[i][j])):
                    self.assertEqual( cpmpalette[i][j][z] , palette[i][j][z], msg="a2pyutils.colors palettes do not match")
            
if __name__ == '__main__':
    unittest.main()

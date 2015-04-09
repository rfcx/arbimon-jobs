import unittest
from mock import MagicMock
import csv
import json
from datetime import datetime
from random import randint
from mock import patch
from mock import call

def get_random_bin(l):
    rb = {}
    for i in range(l):
        rb[i] = {}
    return rb

def mock_rows_gen(cls, bins, scalefn, from_y, to_y, from_x, to_x):
    return 'dummy'

class Test_soundscape(unittest.TestCase):

    def test_import(self):
        try:
            from soundscape.soundscape import Soundscape
        except ImportError:
            self.fail("Cannot load soundscape.Soundscape module")
        try:
            from soundscape.soundscape import aggregations
        except ImportError:
            self.fail("Cannot load soundscape.aggregations module")        
    
    def test_init(self):
        """Test Soundscape.init method"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        self.assertIsInstance(scp ,soundscape.Soundscape,msg="soundscape.Soundscape: Cannot create instance of Soundscape")
        
    def test_get_peak_list(self):
        """Test Soundscape.get_peak_list function"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        mFile = MagicMock()
        retVals = []
        with open('test_python/data/peaks.csv', 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in spamreader:
                retVals.append(', '.join(row))
        mFile.__iter__.return_value = retVals
        correctData = []
        with open('test_python/data/peaks.from.get.peak.list.csv', 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in spamreader:
                correctData.append(row)
        j = 0
        try:
            for i in scp.get_peak_list(mFile):
                crow = correctData[j]
                self.assertEqual(int(i['bin']),int(crow[0]))
                self.assertEqual(int(i['id']),int(crow[1]))
                self.assertEqual(int(i['idx']),int(crow[2]))
                j = j + 1
        except:
            self.fail("Soundscape.get_peak_list: Cannot compare with correctData")
            
    def test_insert_peaks(self):
        """Test Soundscape.init method"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        self.assertIsInstance(scp ,soundscape.Soundscape,msg="soundscape.Soundscape: Cannot create instance of Soundscape")
        with open('test_python/data/peaks.csv', 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            next(spamreader, None)
            for row in spamreader:
                scp.insert_peaks(
                    datetime.strptime(row[10], '%m/%d/%Y %I:%M %p'),
                    [float(row[6])],
                    [float(row[7])],
                    int(row[0])
                )
        with open('test_python/data/scp.recordings.peaks.data.json', 'rb') as fp:
            recordings = json.load(fp)
        with open('test_python/data/scp.bins.peaks.data.json', 'rb') as fp:
            bins = dict([
                (int(i_row), dict([
                    (int(i_col), dict([
                        (int(i_cell), cell) for i_cell, cell in col.items()
                    ])) for i_col, col in row.items()
                ])) for i_row, row in json.load(fp).items()
            ])

        with open('test_python/data/scp.stats.peaks.data.json', 'rb') as fp:
            stats = json.load(fp)
        self.assertEqual(scp.recordings,recordings,msg="soundscape.Soundscape: scp computed wrong recordings")
        if scp.bins != bins:
            for r in scp.bins:
                if r not in bins:
                    print ":: ", r, " missing"
                else:
                    print ":: ", r, " :: ", (scp.bins[r] == bins)
            self.assertTrue(False, msg="soundscape.Soundscape: scp computed wrong bins")
        self.assertEqual(scp.stats,stats,msg="soundscape.Soundscape: scp computed wrong stats")

    def test_init_with_finp(self):
        """Test Soundscape.init method"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        mFile = MagicMock()
        retVals = []
        with open('test_python/data/peaks.csv', 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in spamreader:
                retVals.append(', '.join(row))
        mFile.__iter__.return_value = retVals  
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256,mFile)
        self.assertIsInstance(scp ,soundscape.Soundscape,msg="soundscape.Soundscape_with_finp: Cannot create instance of Soundscape")
        
        with open('test_python/data/scp.recordings.data.json', 'rb') as fp:
            recordings = json.load(fp)
        with open('test_python/data/scp.bins.data.json', 'rb') as fp:
            bins = json.load(fp)
        with open('test_python/data/scp.stats.data.json', 'rb') as fp:
            stats = json.load(fp)
            
        self.assertEqual(scp.recordings,recordings,msg="soundscape.Soundscape_with_finp: scp computed wrong recordings")
        try:
            for k in bins:
                scp.bins[int(k)]
        except:
            self.fail("soundscape.Soundscape: scp computed wrong bins")
        self.assertEqual(scp.stats,stats,msg="soundscape.Soundscape_with_finp: scp computed wrong stats")
             
    def test_cols_gen(self):
        """Test Soundscape.cols_gen method"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        scaleFunction = lambda x: x
        dummtBins = {}
        binsLength = []
        binsc = randint(50,100)
        for i in range(binsc):
            bl = randint(0,20)
            binsLength.append(bl)
            dummtBins[i] = get_random_bin(bl)
        j = 0
        for i in scp.cols_gen(dummtBins,scaleFunction,0,binsc):
            self.assertEqual(i,binsLength[j],msg="soundscape.Soundscape.cols_gen: scp computed wrong number of peaks")
            j = j + 1
            
    def test_rows_gen(self):
        """Test Soundscape.rows_gen method"""
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        scaleFunction = lambda x: x
        dummtBins = {}
        binsLength = {}
        maxx = randint(25,100)
        maxy = randint(25,100)
        maxpeaks = randint(25,100)
        binsc = randint(0,maxy)
        for j in range(binsc):
            dummtBins[j] = {}
            binsLength[j] = []
            binsx = randint(0,maxx)
            for i in range(binsx):
                bl = randint(0,maxpeaks)
                binsLength[j].append(bl)
                dummtBins[j][i] = get_random_bin(bl)
            for i in range(maxx - binsx):
                binsLength[j].append(0)
        j = len(binsLength)-1
        for i in scp.rows_gen(dummtBins,scaleFunction,0,binsc,0,maxx):
            cbl = binsLength[j]
            jj = 0
            for k in i:
                self.assertEqual(k,cbl[jj],msg="soundscape.Soundscape.cols_gen: scp computed wrong number of peaks")
                jj=jj+1
            j = j - 1

class Test_soundscape_writes_empty(unittest.TestCase):
    
    def setUp(self):
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        from a2pyutils.palette import get_palette
        self.write_scidx_mock = MagicMock()
        soundscape.scidx.write_scidx = self.write_scidx_mock
        self.scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        self.palette = get_palette()
        
    @patch("png.Writer")
    @patch("a2pyutils.bmpio.Writer")
    @patch('__builtin__.file')
    def test_write_image(self,mock_file,bmpio_Writer,png_Writer):
        """Test Soundscape.write_image method"""
        self.scp.rows_gen = MagicMock()
        self.scp.rows_gen.return_value = []
        self.scp.write_image("/dummy/file/t.png",self.palette)
        self.scp.write_image("/dummy/file/t.bmp",self.palette)
        self.assertTrue(png_Writer.mock_calls[0] == call(width=24, palette=self.palette, bitdepth=8, height=256),msg="Soundscape.write_image wrote bad data")
        self.assertTrue(bmpio_Writer.mock_calls[0] == call(width=24, palette=self.palette, bitdepth=8, height=256),msg="Soundscape.write_image wrote bad data")
        self.assertTrue(mock_file.mock_calls[0] == call('/dummy/file/t.png', 'wb'),msg="Soundscape.write_image write was not called")
        self.assertTrue(mock_file.mock_calls[1] == call('/dummy/file/t.bmp', 'wb'),msg="Soundscape.write_image write was not called")
    
    def test_write_index(self):
        """Test Soundscape.write_index method"""
        self.scp.write_index("/dummy/file/t.png")
        self.scp.write_index("/dummy/file/t.bmp")
        self.assertTrue(self.write_scidx_mock.mock_calls[0] == call('/dummy/file/t.png', {}, {}, 0, 24, 0, 256),msg="Soundscape.write_index was not called")
        self.assertTrue(self.write_scidx_mock.mock_calls[1] == call('/dummy/file/t.bmp', {}, {}, 0, 24, 0, 256),msg="Soundscape.write_index was not called")

 
class Test_soundscape_writes(unittest.TestCase):
    
    def setUp(self):
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        from a2pyutils.palette import get_palette
        self.write_scidx_mock = MagicMock()
        soundscape.scidx.write_scidx = self.write_scidx_mock
        mFile = MagicMock()
        retVals = []
        with open('test_python/data/peaks.csv', 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in spamreader:
                retVals.append(', '.join(row))
        mFile.__iter__.return_value = retVals  
        self.scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256,mFile)
        self.palette = get_palette()
        
    @patch("png.Writer")
    @patch("a2pyutils.bmpio.Writer")
    @patch('__builtin__.file')
    def test_write_image(self,mock_file,bmpio_Writer,png_Writer):
        """Test Soundscape.write_image method"""
        import numpy
        randomData = numpy.random.rand(1000)
        self.scp.rows_gen = MagicMock()
        self.scp.rows_gen.return_value = randomData
        
        self.scp.write_image("/dummy/file/t.png",self.palette)
        self.scp.write_image("/dummy/file/t.bmp",self.palette)

        self.assertTrue(png_Writer.mock_calls[0] == call(width=24, palette=self.palette, bitdepth=8, height=256),msg="Soundscape.write_image wrote bad data")
        self.assertTrue(bmpio_Writer.mock_calls[0] == call(width=24, palette=self.palette, bitdepth=8, height=256),msg="Soundscape.write_image wrote bad data")
        self.assertTrue(mock_file.mock_calls[0] == call('/dummy/file/t.png', 'wb'),msg="Soundscape.write_image write was not called")
        self.assertTrue(mock_file.mock_calls[1] == call('/dummy/file/t.bmp', 'wb'),msg="Soundscape.write_image write was not called")
    
    def test_write_index(self):
        """Test Soundscape.write_index method"""
        self.scp.write_index("/dummy/file/t.png")
        self.scp.write_index("/dummy/file/t.bmp")
        self.assertTrue(self.write_scidx_mock.mock_calls[0] == call('/dummy/file/t.png', self.scp.bins, self.scp.recordings, 0, 24, 0, 256),msg="Soundscape.write_index was not called")
        self.assertTrue(self.write_scidx_mock.mock_calls[1] == call('/dummy/file/t.bmp', self.scp.bins, self.scp.recordings, 0, 24, 0, 256),msg="Soundscape.write_index was not called")

class Test_soundscape_read_from_index(unittest.TestCase):
    
    def test_read_from_index(self):
        from soundscape import soundscape
        from soundscape.soundscape import aggregations
        read_scidx_mock = MagicMock()
        read_scidx_mock.return_value = [1,{0:{0:{}}},{},0,0,0,0,0,0,0,0]
        soundscape.scidx.read_scidx = read_scidx_mock
        scp = soundscape.Soundscape(aggregations['time_of_day'], 86, 256)
        obj = scp.read_from_index("/dummy/index/file")
        self.assertTrue(read_scidx_mock.mock_calls[0] == call('/dummy/index/file'),msg="Soundscape.read_from_index: scidx was not call")
        self.assertTrue(obj.recordings == {},msg="Soundscape.read_from_index: returned bad data")
        self.assertTrue(obj.bins == {0: {0: {}}},msg="Soundscape.read_from_index: returned bad data")
        
if __name__ == '__main__':
    unittest.main()

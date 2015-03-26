import unittest
from mock import MagicMock
import random
import time
from datetime import datetime
from mock import patch
import mock

def randomDate():
    year = random.randint(1970, 2015)
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    hour = random.randint(0, 23)
    mins = random.randint(0, 59)
    return datetime(year, month, day,hour,mins)

def array_mock(a,b):
    aa = Array_mock_class(b)
    return aa

array_mock_class_calls = []
class Array_mock_class(object):
    d = None
    def __init__(self,b):
        self.d = b
    def tofile(self,fileHandle):
        global array_mock_class_calls
        array_mock_class_calls.append(self.d)

class Mock_file_Return(object):
    mock_calls = []
    def __init__(self):
        pass
    def close(self):
        self.mock_calls.append('close')
    def has_call(self,fun):
        for ff in self.mock_calls:
            if ff == fun:
                return fun
        return None
    def __exit__(self,a,b,c):
        pass
    def __enter__(self):
        pass
    def write(self):
        pass
    
class Test_indices(unittest.TestCase):

    def test_import(self):
        try:
            from indices.indices import Indices
            from indices.indices import aggregations
        except ImportError:
            self.fail("Cannot load indices.indices module")

    def test_init(self):
        from indices.indices import Indices
        from indices.indices import aggregations
        
        for agr in aggregations:
            indiInstance = Indices(aggregations[agr])
            self.assertIsInstance(indiInstance ,Indices,msg="Indices.indices: Cannot init Indices")
            del indiInstance
            
    def test_insert_value(self):
        from indices.indices import Indices
        from indices.indices import aggregations
        import numpy
        from random import randint
        vals = []
        totalTests = 5
        for i in range(totalTests ):
            vals.append([randomDate().strftime("%Y-%m-%d %H:%M:%S"), numpy.random.rand(1),randint(1,100000)])
        for agr in aggregations:
            indiInstance = Indices(aggregations[agr])
            self.assertIsInstance(indiInstance ,Indices,msg="Indices.indices: Cannot init Indices")
            for i in range(totalTests ):
                r = vals[i]
                try:
                    indiInstance.insert_value(datetime.strptime(r[0], '%Y-%m-%d %H:%M:%S'),r[1],r[2])
                except:
                    self.fail("Indices.indices: Cannot insert values")
            del indiInstance
            
    def test_agregatee(self):
        from indices.indices import Indices
        from indices.indices import aggregations
        import numpy
        from random import randint
        vals = []
        totalTests = 5
        for i in range(totalTests ):
            vals.append([randomDate().strftime("%Y-%m-%d %H:%M:%S"), numpy.random.rand(1),randint(1,100000)])
        for agr in aggregations:
            indiInstance = Indices(aggregations[agr])
            self.assertIsInstance(indiInstance ,Indices,msg="Indices.indices: Cannot init Indices")
            for i in range(totalTests ):
                r = vals[i]
                indiInstance.insert_value(datetime.strptime(r[0], '%Y-%m-%d %H:%M:%S'),r[1],r[2])
            try:
                indiInstance.aggregate()
            except:
                self.fail("Indices.indices: Cannot aggregate values")
            del indiInstance
 
class Test_indices_writes(unittest.TestCase):
    
    def setUp(self):
        from indices.indices import Indices
        from indices.indices import aggregations
        import numpy
        from random import randint
        vals = []
        totalTests = 5
        for i in range(totalTests ):
            vals.append([randomDate().strftime("%Y-%m-%d %H:%M:%S"), numpy.random.rand(1),randint(1,100000)])

        self.indiInstance = Indices(aggregations['time_of_day'])
        for i in range(totalTests ):
            r = vals[i]
            self.indiInstance.insert_value(datetime.strptime(r[0], '%Y-%m-%d %H:%M:%S'),r[1],r[2])
        self.indiInstance.aggregate()
    
    @patch("__builtin__.open")
    def test_write_index_aggregation(self,mock_open):
        """Test Indices.write_index_aggregation function"""
        global array_mock_class_calls
        mm = Mock_file_Return()
        mock_open.return_value = mm
        with mock.patch("indices.indices.array",array_mock):
            self.indiInstance.write_index_aggregation('/dummy/file/name')
        mock_open.assert_any_calls('/dummy/file/name', 'wb')
        self.assertEqual(mm.has_call('close'),'close',msg="Indices.indices: The file.close function was not called")
        vv = self.indiInstance.getValues()
        compvv = array_mock_class_calls[0]
        for i in range(len(vv)):
            self.assertEqual(vv[i],compvv[i],msg="Indices.indices: corrupt values were written")
    
    @patch("__builtin__.open")
    @patch("json.dump")
    def test_write_index_aggregation_json(self,json_dump,mock_open):
        """Test Indices.write_index_aggregation_json function"""
        mm = Mock_file_Return()
        mock_open.return_value = mm
        self.indiInstance.write_index_aggregation_json('/dummy/file/name')
        vv = self.indiInstance.getValues()
        json_dump.assert_any_calls(vv,None)
        mock_open.assert_any_calls('/dummy/file/name', 'w')
        
if __name__ == '__main__':
    unittest.main()

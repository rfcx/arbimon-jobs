import unittest
from mock import mock_open

class mock_file(object):
    mock_calls = []
    def __init__(self):
        pass
    def tell(self):
        self.mock_calls.append('tell')
        return 0
    def write(self,d):
        self.mock_calls.append('write')
    def seek(self,p):
        self.mock_calls.append('seek')
    def clear_calls(self):
        self.mock_calls = []
        
class Test_scidx(unittest.TestCase):

    def test_imports(self):
        try:
            from soundscape.scidx import file_pointer_write_loc
        except ImportError:
            self.fail("Cannot load soundscape.scidx.file_pointer_write_loc module")
        try:
            from soundscape.scidx import uint2BEbytes
        except ImportError:
            self.fail("Cannot load soundscape.scidx.uint2BEbytes function")      
        try:
            from soundscape.scidx import BEbytes2uint 
        except ImportError:
            self.fail("Cannot load soundscape.scidx.BEbytes2uint function")
        try:
            from soundscape.scidx import write_scidx
        except ImportError:
            self.fail("Cannot load soundscape.scidx.write_scidx function")      
        try:
            from soundscape.scidx import read_cell_recs
        except ImportError:
            self.fail("Cannot load soundscape.scidx.read_cell_recs function")
        try:
            from soundscape.scidx import read_scidx
        except ImportError:
            self.fail("Cannot load soundscape.scidx.read_scidx function")
 
class Test_scidx_file_pointer_write_loc(unittest.TestCase):
    
    def test_init(self):
        from soundscape.scidx import file_pointer_write_loc
        mo = mock_file()
        fpwc = file_pointer_write_loc(mo)
        self.assertEqual(mo.mock_calls[0],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[1],'write',msg="soundscape.scidx in init did not called file.write")
    
    def test_update(self):
        from soundscape.scidx import file_pointer_write_loc
        mo = mock_file()
        mo.clear_calls()
        fpwc = file_pointer_write_loc(mo)
        fpwc.update()
        self.assertEqual(mo.mock_calls[0],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[1],'write',msg="soundscape.scidx in init did not called file.write")
        self.assertEqual(mo.mock_calls[2],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[3],'seek',msg="soundscape.scidx in init did not called file.seek")
        self.assertEqual(mo.mock_calls[4],'write',msg="soundscape.scidx in init did not called file.write")
        self.assertEqual(mo.mock_calls[5],'seek',msg="soundscape.scidx in init did not called file.seek")

if __name__ == '__main__':
    unittest.main()

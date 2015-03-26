import unittest
from mock import patch

class mock_file_obj(object):
    mock_calls = []
    tellc = 1000
    readc = 1000
    def __init__(self):
        pass
    def tell(self):
        self.mock_calls.append('tell')
        self.tellc = self.tellc - 1
        return self.tellc
    def write(self,d):
        self.mock_calls.append('write')
    def seek(self,p,a=0):
        self.mock_calls.append('seek')
    def clear_calls(self):
        self.mock_calls = []
    def read(self,bb=-1):
        self.mock_calls.append('read')
        ret = ''
        if bb == -1:
            ret = self.readc = self.readc - 1
        else:
            ss = '0'
            for i in range(bb):
                if ss == '0':
                    ss = '1'
                    ret = ret + '\x00'
                else:
                    ret = ret + '\x01'
                    ss = '0'
        return str(ret)
        
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
        mo = mock_file_obj()
        fpwc = file_pointer_write_loc(mo)
        self.assertEqual(mo.mock_calls[0],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[1],'write',msg="soundscape.scidx in init did not called file.write")
    
    def test_update(self):
        from soundscape.scidx import file_pointer_write_loc
        mo = mock_file_obj()
        mo.clear_calls()
        fpwc = file_pointer_write_loc(mo)
        fpwc.update()
        self.assertEqual(mo.mock_calls[0],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[1],'write',msg="soundscape.scidx in init did not called file.write")
        self.assertEqual(mo.mock_calls[2],'tell',msg="soundscape.scidx in init did not called file.tell")
        self.assertEqual(mo.mock_calls[3],'seek',msg="soundscape.scidx in init did not called file.seek")
        self.assertEqual(mo.mock_calls[4],'write',msg="soundscape.scidx in init did not called file.write")
        self.assertEqual(mo.mock_calls[5],'seek',msg="soundscape.scidx in init did not called file.seek")

class Test_scidx_functions(unittest.TestCase):
                
    def test_uint2BEbytes(self):
        from soundscape.scidx import uint2BEbytes
        for k in range(256):
            for m in range(256):
                t = uint2BEbytes( k*pow(256,1) + m*pow(256,0), 2)
                self.assertEqual(t[0],k,msg="soundscape.scidx: uint2BEbytes computed wrong values")
                self.assertEqual(t[1],m,msg="soundscape.scidx: uint2BEbytes computed wrong values")

    def test_BEbytes2uint(self):
        from soundscape.scidx import BEbytes2uint
        for k in range(256):
            for m in range(256):
                v = k*pow(256,1) + m*pow(256,0)
                t = BEbytes2uint([k,m])
                self.assertEqual(t,v,msg="soundscape.scidx: BEbytes2uint computed wrong values")
                
    def test_read_cell_recs(self):
        """Test the soundscape.scidx.read_cell_recs function"""
        from soundscape.scidx import read_cell_recs       # finp, rcfmt, rcbytes, count
        mo = mock_file_obj()
        mo.clear_calls()
        for i in read_cell_recs(mo,'B',1,5):
            dummy = i
        correctCalls = ['tell', 'seek', 'tell', 'seek', 'tell', 'read', 'tell', 'read', 'tell', 'read', 'tell', 'read', 'tell', 'read']
        try:
            for i in range(len(correctCalls)):
                self.assertEqual(correctCalls[i],mo.mock_calls[i],msg="soundscape.scidx.read_cell_recs: incorrect order of calls")
        except:
            self.fail("soundscape.scidx.read_cell_recs: Incorrect number of calls")
    
    @patch("__builtin__.file")
    def test_read_scidx(self,m_file):
        """Test soundscape.scidx.read_scidx function"""
        from soundscape.scidx import read_scidx
        mfile = mock_file_obj()
        mfile.clear_calls()
        m_file.return_value = mfile 
        retData = read_scidx('/dummy/file/name')
        m_file.assert_any_calls('/dummy/file/name', 'rb')
        correctCalls = ['seek', 'tell', 'seek', 'read', 'read', 'read', 'read', 'read', 'seek', 'read', 'seek', 'read', 'seek', 'read', 'tell', 'seek', 'tell', 'seek', 'tell', 'read']
        try:
            for i in range(len(correctCalls)):
                self.assertEqual(correctCalls[i],mfile.mock_calls[i],msg="soundscape.scidx.read_cell_recs: incorrect order of calls")
        except:
            self.fail("soundscape.scidx.read_cell_recs: Incorrect number of calls")
        self.assertEqual(retData[0][1][1][0],0,msg="soundscape.scidx.read_scidx: returned incorrect values")
        self.assertEqual(retData[2],1,msg="soundscape.scidx.read_scidx: returned incorrect values")
        self.assertEqual(retData[3],1,msg="soundscape.scidx.read_scidx: returned incorrect values")
        self.assertEqual(retData[4],1,msg="soundscape.scidx.read_scidx: returned incorrect values")
        self.assertEqual(retData[5],1,msg="soundscape.scidx.read_scidx: returned incorrect values")
    
    @patch("__builtin__.file")
    def test_write_scidx(self,m_file):
        """Test soundscape.scidx.write_scidx function"""
        myfile = mock_file_obj()
        myfile.clear_calls()
        m_file.return_value = myfile 
        from soundscape.scidx import write_scidx
        recs = [1,2,3,4]
        ind = {
                10: {4: {1: 1, 2: 1},3: {1: 1, 2: 1},2: {1: 1, 2: 1},1: {1: 1, 2: 1},9: {1: 1, 2: 1}, 1: {3: 1, 4: 2}},
                15: {4: {1: 1, 2: 1},3: {1: 1, 2: 1},2: {1: 1, 2: 1},1: {1: 1, 2: 1},9: {1: 1, 2: 1}, 1: {3: 1, 4: 2}}
            }
        write_scidx('/dummy/file/write/name.scidx', ind, recs ,0, 20, 0, 20)
        m_file.assert_any_calls('/dummy/file/write/name.scidx','wb')
        callSq = ['write', 'write', 'write', 'tell', 'write', 'write', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'seek', 'write', 'seek', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write', 'tell', 'seek', 'write', 'seek', 'write', 'write', 'write']
        try:
            for c in range(len(callSq)):
                self.assertEqual(callSq[c],myfile.mock_calls[c],msg="soundscape.scidx.write_scidx: incorrect order of calls")
        except:
            self.fail("soundscape.scidx.write_scidx: Incorrect number of calls")
            
if __name__ == '__main__':
    unittest.main()

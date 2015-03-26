import unittest
from mock import MagicMock
import mock
from mock import patch
from contextlib import contextmanager

class db_mock:
    calls = []
    def __init__(self,vv=None):
        self.calls = []
        self.vv = vv
        pass
    def execute(self,q,a=None):
        self.calls.append({'f':'execute','q':q,'a':a})
    def close(self):
        self.calls.append({'f':'close'})
    def cursor(self):
        self.calls.append({'f':'cursor'})
        co = close_obj(self.vv)
        return co
    def commit(self):
        pass
 
close_obj_calls =[]
class close_obj:
    def __init__(self,vv):
        self.vv = vv
        pass
    def close(self):
        global close_obj_calls
        close_obj_calls.append({'f':'close'})
    def execute(self,q,a=None):
        global close_obj_calls
        close_obj_calls.append({'f':'execute','q':q,'a':a})
    def fetchone(self):
        global close_obj_calls
        close_obj_calls.append({'f':'fetch_one'})
        return self.vv

mock_closing_calls = [] 
@contextmanager           
def mock_closing(filen):
    global mock_closing_calls
    mock_closing_calls.append(filen)
    mm = close_obj(filen)
    try:
        yield mm
    finally:
        mm.close()

keyMockCalls = []
class keyMock(object):
    def __init__(self):
        pass
    def get_contents_to_filename(self, a ):
        global keyMockCalls
        keyMockCalls.append({'f':'get_contents_to_filename','a':a})    

bucket_mock_calls = []
class bucket_mock:
    def __init__(self):
        pass
    def new_key(self,uri):
        global bucket_mock_calls
        bucket_mock_calls.append({'f':'new_key','u':uri})
        return keyMock()
    def get_key(self,scidx_uri, validate=False ):
        global bucket_mock_calls
        bucket_mock_calls.append({'f':'get_key','u':scidx_uri})
        return keyMock()
    
    
conn_mock_calls= []    
class conn_mock:
    def __init__(self,a,b):
        global conn_mock_calls
        conn_mock_calls.append({'f':'init','a':a,'b':b})
    def get_bucket(self,bn,validate=None):
        global conn_mock_calls
        conn_mock_calls.append({'f':'get_bucket','b':bn,'a':validate})
        return bucket_mock()

new_con_calls = []
def new_con(a,b):
    global new_con_calls
    new_con_calls.append({'a':a,'b':b})
    return conn_mock(a,b)

new_con_none_calls = []
def new_con_none(a,b):
    global new_con_none_calls
    new_con_none_calls.append({'a':a,'b':b})
    return None

isInstanceMockFalse_calls = []
def isInstanceMockFalse(a,b):
    global isInstanceMockFalse_calls
    isInstanceMockFalse_calls.append({'a':a,'b':str(b)})
    return False

isInstanceMockTrue_calls = []
def isInstanceMockTrue(a,b):
    global isInstanceMockTrue_calls
    isInstanceMockTrue_calls.append({'a':str(a),'b':str(b)})
    return True

file_cache_mock_calls = []
class file_cache_mock(object):
    def __init__(self,ret):
        self.ret = ret
    def fetch(self,uri):
        global file_cache_mock_calls
        file_cache_mock_calls.append({'f':'fetch','u':uri})
        return self.ret

scidxFile_Calls = []  
class scidxFile(object):
    def __init__(self, n):
        self.file = n
    def retry_get(self):
        global scidxFile_Calls
        scidxFile_Calls.append({'f':'retry_get'})
        return self.file
    
    

class file_cache_mock_retry(object):
    def __init__(self,ret):
        self.ret = ret
    def fetch(self,uri):
        global file_cache_mock_calls
        file_cache_mock_calls.append({'f':'fetch','u':uri})
        return scidxFile(self.ret ) 

class Test_set_visual_scale_lib(unittest.TestCase):

    def test_imports(self):
        """Test set_visual_scale"""
        try:
            from soundscape.set_visual_scale_lib import run
            from soundscape.set_visual_scale_lib import exit_error
            from soundscape.set_visual_scale_lib import get_db
            from soundscape.set_visual_scale_lib import get_sc_data
            from soundscape.set_visual_scale_lib import get_bucket
            from soundscape.set_visual_scale_lib import get_scidx_file
            from soundscape.set_visual_scale_lib import write_image
            from soundscape.set_visual_scale_lib import upload_image
            from soundscape.set_visual_scale_lib import update_db
        except:
            self.fail('set_visual_scale_lib: error importing some of the functions')
    
    def test_exit_error(self):
        """Test the exit_error procedure"""
        from soundscape.set_visual_scale_lib import exit_error
        sys_exit = MagicMock()
        with mock.patch('sys.exit', sys_exit, create=False):
            exit_error('THIS IS NOT AN ERROR\nTHIS IS A TESTING MESSAGE\nTESTING THE EXIT_ERROR FUNCTION\nTHIS IS NOT AN ERROR')
        sys_exit.assert_any_call(-1)
    
    @patch('MySQLdb.connect')
    @patch('MySQLdb.cursors.DictCursor')
    def test_get_db(self,cursorDictMock,mysql_connect):
        """Test the get_db procedure"""
        from soundscape.set_visual_scale_lib import get_db
        exitErr = MagicMock()
        with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
            mysql_connect.return_value = None
            self.assertIsNone(get_db(['host','user','pass','dbname']))
            mysql_connect.return_value = 'NotNone'
            self.assertEqual('NotNone',get_db(['host','user','pass','dbname']))
        exitErr.assert_any_calls('cannot connect to database.')
        mysql_connect.assert_call(passwd='pass', host='host', db='dbname', cursorclass=cursorDictMock, user='user')
        mysql_connect.assert_call(passwd='pass', host='host', db='dbname', cursorclass=cursorDictMock, user='user')
    
    def test_get_sc_data(self):
        """Test the get_sc_data procedure"""
        global close_obj_calls
        global mock_closing_calls
        from soundscape.set_visual_scale_lib import get_sc_data
        exitErr = MagicMock()
        with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
            with mock.patch('contextlib.closing', mock_closing , create=False):
                dbMock = db_mock()
                self.assertIsNone(get_sc_data(dbMock,1),msg="get_sc_data : should have returned None")
                del dbMock
                dbMock = db_mock(1)
                self.assertEqual(get_sc_data(dbMock,1),1,msg="get_sc_data : incorrect return value")
        self.assertEqual(dbMock.calls[0],{'f': 'cursor'},msg="get_sc_data: call not found")
        closeObjCalls = [{'q': 'SELECT uri FROM soundscapes WHERE soundscape_id = %s', 'a': [1], 'f': 'execute'},
                         {'f': 'fetch_one'},
                         {'f': 'close'},
                         {'q': 'SELECT uri FROM soundscapes WHERE soundscape_id = %s', 'a': [1], 'f': 'execute'},
                         {'f': 'fetch_one'},
                         {'f': 'close'}]
        try:
            for i in range(len(closeObjCalls)):
                self.assertEqual(closeObjCalls[i],close_obj_calls[i],msg="get_sc_data: calls should be the same")
        except:
            self.fail('get_sc_data: Incorrect number of calls')
        exitErr.assert_any_calls('Soundscape #1 not found')
    
    def test_get_bucket(self):
        """Test get_bucket procedure"""
        global bucket_mock_calls
        global conn_mock_calls
        global new_con_calls
        global new_con_none_calls
        new_con_calls = []
        bucket_mock_calls = []
        conn_mock_calls = []
        from soundscape.set_visual_scale_lib import get_bucket
        exitErr = MagicMock()
        with mock.patch('boto.s3.connection.S3Connection', new_con_none, create=False):
            with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
                self.assertIsNone(get_bucket(['d','d','d','d','bucketName','awsKey','awsPass']))
        with mock.patch('boto.s3.connection.S3Connection', new_con, create=False):
            with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
                self.assertIsInstance( get_bucket(['d','d','d','d','bucketName','awsKey','awsPass']),bucket_mock)

        exitErr.assert_any_calls('cannot not connect to aws.')
        self.assertEqual(conn_mock_calls[0],{'a': 'awsKey', 'b': 'awsPass', 'f': 'init'},msg="get_bucket: AWS Connection call incorrect")
        self.assertEqual(new_con_calls[0],{'a': 'awsKey', 'b': 'awsPass'},msg="get_bucket: S3Connection call incorrect")
        self.assertEqual(new_con_none_calls[0],{'a': 'awsKey', 'b': 'awsPass'},msg="get_bucket: S3Connection call incorrect")
    
    def test_get_scidx_file_notinstance(self):
        """Test get_scidx_file procedure"""
        global file_cache_mock_calls
        global isInstanceMockFalse_calls
        global bucket_mock_calls
        bucket_mock_calls = []
        isInstanceMockFalse_calls= []
        file_cache_mock_calls = []
        from soundscape.set_visual_scale_lib import get_scidx_file
        exitErr = MagicMock()
        bucketMock = bucket_mock()
        with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
            with mock.patch('__builtin__.isinstance',isInstanceMockFalse, create=False):
                fcm = file_cache_mock(None)
                get_scidx_file('randomUri',fcm,bucketMock)
            
        self.assertEqual(file_cache_mock_calls[0],{'u': 'randomUri', 'f': 'fetch'},msg="get_scidx_file: file cache wrong call")
        self.assertEqual(isInstanceMockFalse_calls[0],{'a': None, 'b': "<class 'a2pyutils.tempfilecache.CacheMiss'>"})
        self.assertEqual(len(bucket_mock_calls),0,msg="get_scidx_file: bucket new_key should have not been call")
        exitErr.assert_ant_calls('cannot not retrieve scidx_file.')
        exitErr.reset_mock()
        
    def test_get_scidx_file(self):
        """Test get_scidx_file procedure"""
        global file_cache_mock_calls
        global isInstanceMockTrue_calls
        global bucket_mock_calls
        global scidxFile_Calls
        global keyMockCalls
        keyMockCalls = []
        scidxFile_Calls = []
        bucket_mock_calls = []
        isInstanceMockTrue_calls= []
        file_cache_mock_calls = []
        from soundscape.set_visual_scale_lib import get_scidx_file
        exitErr = MagicMock()
        bucketMock = bucket_mock()
        with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
            with mock.patch('__builtin__.isinstance',isInstanceMockTrue, create=False):
                fcm = file_cache_mock_retry('a file')
                get_scidx_file('randomUri',fcm,bucketMock)
            
        self.assertEqual(keyMockCalls[0] ,{'a': 'a file', 'f': 'get_contents_to_filename'},msg="get_scidx_file: get_contents_to_filename call wrong")
        self.assertEqual(scidxFile_Calls[0],{'f': 'retry_get'},msg="get_scidx_file: retry_get function call wrong")
        self.assertEqual(bucket_mock_calls[0] ,{'u': 'randomUri', 'f': 'get_key'},msg="get_scidx_file: bucket call wrong")
        self.assertEqual(isInstanceMockTrue_calls[0]['b'], "<class 'a2pyutils.tempfilecache.CacheMiss'>",msg="get_scidx_file: is intance called wrong")
        self.assertEqual(file_cache_mock_calls[0],{'u': 'randomUri', 'f': 'fetch'},msg="get_scidx_file: file cache call wrong")
        self.assertEqual(len(exitErr.mock_calls),0,msg="get_scidx_file: expected no errors ")
    
if __name__ == '__main__':
    unittest.main()

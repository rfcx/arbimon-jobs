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

bucket_mock_calls = []
class bucket_mock:
    def __init__(self):
        pass
    def new_key(self,uri):
        global bucket_mock_calls
        bucket_mock_calls.append({'f':'new_key','u':uri})
        return None
    
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

file_cache_mock_calls = []
class file_cache_mock(object):
    def __init__(ret):
        self.ret
    def fetch(self,uri):
        global file_cache_mock_calls
        file_cache_mock_calls.append({'f':'fetch','u':uri})
        return self.ret
    

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
            exit_error('THIS IS NOT AN ERROR : TESTING MESSAGE : EXIT_ERROR FUNCTION : THIS IS NOT AN ERROR')
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
    
    def test_get_scidx_file(self):
        """Test get_scidx_file procedure"""
        global file_cache_mock_calls
        from soundscape.set_visual_scale_lib import get_scidx_file
        with mock.patch('soundscape.set_visual_scale_lib.exit_error', exitErr, create=False):
            get_scidx_file('randomUri',file_cache_mock(None),'abucket')
        print  file_cache_mock_calls
        
if __name__ == '__main__':
    unittest.main()

import unittest
from mock import MagicMock
import cPickle as pickle
from mock import patch
import mock
from contextlib import contextmanager

status_mock_calls=[]
class Status_mock:
    def __init__(self,s):
        self.status = s
    def features(self):
        global status_mock_calls
        status_mock_calls.append('features')
        
    def getVector(self):
        global status_mock_calls
        status_mock_calls.append('getVector')
        
class logger_write:
    calls = []
    def __init__(self):
        pass
    def write(self,msg):
        self.calls.append(msg)
        
close_obj_calls =[]
class close_obj:
    def __init__(self,vv):
        self.vv = vv
        pass
    def close(self):
        global close_obj_calls
        close_obj_calls.append({'f':'close'})
    def execute(self,q):
        global close_obj_calls
        close_obj_calls.append({'f':'execute','q':q})
    def fetchone(self):
        global close_obj_calls
        close_obj_calls.append({'f':'fetch_one'})
        return self.vv

@contextmanager           
def mock_closing(filen):
    mm = close_obj(filen)
    try:
        yield mm
    finally:
        mm.close()
        
key_mock_calls = []
class key_mock:
    def __init__(self):
        pass
    def set_contents_from_filename(self,f):
        global key_mock_calls
        key_mock_calls.append({'f':'set_contents_from_filename','u':f})
    def set_acl(self,p):
        global key_mock_calls
        key_mock_calls.append({'f':'set_acl','u':p})
        
bucket_mock_calls = []
class bucket_mock:
    def __init__(self):
        pass
    def new_key(self,uri):
        global bucket_mock_calls
        bucket_mock_calls.append({'f':'new_key','u':uri})
        return key_mock()
    
conn_mock_calls= []    
class conn_mock:
    def __init__(self,a,b):
        global conn_mock_calls
        conn_mock_calls.append({'f':'init','a':a,'b':b})
    def get_bucket(self,bn):
        global conn_mock_calls
        conn_mock_calls.append({'f':'get_bucket','b':bn})
        return bucket_mock()

def new_con(a,b):
    return conn_mock(a,b)

class db_mock:
    calls = []
    def __init__(self,vv=None):
        self.calls = []
        self.vv = vv
        pass
    def execute(self,q):
        self.calls.append({'f':'execute','q':q})
    def close(self):
        self.calls.append({'f':'close'})
    def cursor(self):
        self.calls.append({'f':'cursor'})
        co = close_obj(self.vv)
        return co
    def commit(self):
        pass
    
class Test_training(unittest.TestCase):

    def test_import(self):
        try:
            from a2audio.training_lib import roigen
            from a2audio.training_lib import recnilize
        except ImportError:
            self.fail("Cannot load a2audio.training module")
    
    @patch('MySQLdb.connect')
    def test_roigen(self,mysql_connect):
        global close_obj_calls
        close_obj_calls = []
        from a2audio.training_lib import roigen
        roizer = MagicMock()
        logger = MagicMock()
        dbMock = db_mock()
        log_Writer = logger_write()
        logger.return_value = log_Writer
        mysql_connect.return_value = dbMock
        lineData = [1,2,3,1.5,2.5,1000.5,2000.5,'any/rec/uri']
        config = ['host','user','pass','db','aws']
        with mock.patch('contextlib.closing', mock_closing , create=False):
            with mock.patch('a2audio.training_lib.Logger', logger, create=False):
                with mock.patch('a2audio.training_lib.Roizer', roizer, create=False):
                    roizer.return_value = Status_mock('NoAudio')
                    ret = roigen(lineData,config,'/any/temp/folder','/any/cuur/dir' ,1,False,1)
                    self.assertEqual(ret,'err',msg="roigen should have returned error")
                    roi_with_Data = Status_mock('HasData')
                    roizer.return_value = roi_with_Data
                    ret = roigen(lineData,config,'/any/temp/folder','/any/cuur/dir' ,1,False,1)
                    self.assertEqual(ret[0],roi_with_Data,msg="roigen should have returned a ROI object and the class")
                    self.assertEqual(ret[1],'2_3',msg="roigen should have returned a ROI object and the class")
        
        logger.assert_any_call(1, 'training.py', 'roigen')
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        roizer.assert_any_call('any/rec/uri', '/any/temp/folder', 'aws', 1.5, 2.5, 1000.5, 2000.5, log_Writer, False,1)
        writerMsgs = ['roigen: processing any/rec/uri',
                      'roigen: cutting at 1.5 to 2.5 and filtering from 1000.5 to 2000.5',
                      'roigen: no audio err any/rec/uri',
                      'roigen: processing any/rec/uri',
                      'roigen: cutting at 1.5 to 2.5 and filtering from 1000.5 to 2000.5',
                      'roigen: done']
        try:
            for m in  range(len(writerMsgs)):
                self.assertEqual(writerMsgs[m],log_Writer.calls[m],msg="roigen incorrect order of logger writer calls")
        except:
            self.fail("incorrect number of logger calls")
        dbMock_calls = [{'f': 'cursor'}, {'f': 'cursor'}, {'f': 'cursor'}, {'f': 'close'}, {'f': 'cursor'}, {'f': 'cursor'}, {'f': 'close'}]
        try:
            for m in  range(len(dbMock_calls)):
                self.assertEqual(dbMock_calls[m],dbMock.calls[m],msg="roigen incorrect order of database calls")
        except:
            self.fail("incorrect number of db connection calls")
        closeObjCalls = [{'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'},
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'},
            {'f': 'close'},
            {'q': 'INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES (1,1) ', 'f': 'execute'},
            {'f': 'close'},
            {'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'},
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'},
            {'f': 'close'}]
        try:
            for m in  range(len(closeObjCalls)):
                self.assertEqual(closeObjCalls[m],close_obj_calls[m],msg="roigen incorrect order of database object calls")
        except:
            self.fail("incorrect number of database calls")
        del dbMock
        
    @patch('MySQLdb.connect')
    @patch('__builtin__.open')
    def test_recnilize(self,mock_open,mysql_connect):
        global close_obj_calls
        global bucket_mock_calls
        global key_mock_calls
        global conn_mock_calls
        global status_mock_calls
        from a2audio.roizer import Roizer
        close_obj_calls = []
        bucket_mock_calls = []
        key_mock_calls = []
        conn_mock_calls = []
        status_mock_calls = [] 
        from a2audio.training_lib import recnilize
        import numpy
        lineData = ['any/rec/uri',2,3,1.5,2.5,1000.5,2000.5,'any/rec/uri']
        config = ['host','user','pass','db','aws','key','secret']
        dbMock = db_mock(None)
        radnMatrx = numpy.random.rand(10,10)
        mysql_connect.return_value = dbMock
        with mock.patch('contextlib.closing', mock_closing , create=False):
            with mock.patch('boto.s3.connection.S3Connection', new_con , create=False):
                ret = recnilize(lineData,config,'/tmp','/tmp/' ,1,[radnMatrx,1,2,3,4],False,False,None,1)
                self.assertEqual(ret,'err',msg="recnilize should have returned err")
        del dbMock
        dbMock = db_mock([1])
        mysql_connect.return_value = dbMock
        recanalizer = MagicMock()
        mock_writerow = MagicMock()
        cancelStatusM = MagicMock()
        with mock.patch('csv.writer',mock_writerow,create=False):
            with mock.patch('a2audio.training_lib.cancelStatus', cancelStatusM, create=False):
                with mock.patch('a2audio.training_lib.Recanalizer', recanalizer, create=False):
                    with mock.patch('contextlib.closing', mock_closing , create=False):
                        with mock.patch('boto.s3.connection.S3Connection', new_con , create=False):
                            recanalizer.return_value = Status_mock('NoAudio')
                            ret = recnilize(lineData,config,'/tmp','/tmp/' ,1,[radnMatrx,1,2,3,4],False,False,None,1)
                            self.assertEqual(ret,'err',msg="recnilize should have returned err with noAudio")
                            recanalizer.return_value = Status_mock('Processed')
                            ret = recnilize(lineData,config,'/tmp','/tmp/' ,1,[radnMatrx,1,2,3,4],False,False,None,1)
        connCalls = [{'a': 'key', 'b': 'secret', 'f': 'init'},
                        {'b': 'aws', 'f': 'get_bucket'},
                        {'a': 'key', 'b': 'secret', 'f': 'init'},
                        {'b': 'aws', 'f': 'get_bucket'},
                        {'a': 'key', 'b': 'secret', 'f': 'init'},
                        {'b': 'aws', 'f': 'get_bucket'}]
        try:
            for i in range(len(connCalls)):
                self.assertEqual(connCalls[i],conn_mock_calls[i])
        except:
            self.fail("recnilize incorrect number of connection calls")
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        keyCalls = [{'u': '/tmpuri', 'f': 'set_contents_from_filename'}, {'u': 'public-read', 'f': 'set_acl'}]
        try:
            for i in range(len(keyCalls)):
                self.assertEqual(keyCalls[i],key_mock_calls[i])
        except:
            self.fail("recnilize incorrect number of bucket key calls")
        bucketCalls = [{'u': 'project_1/training_vectors/job_1/uri', 'f': 'new_key'}]
        try:
            for i in range(len(bucketCalls)):
                self.assertEqual(bucketCalls[i],bucket_mock_calls[i])
        except:
            self.fail("recnilize incorrect number of bucket calls")
        dbCalls = [{'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'}, {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'}, {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'}, {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'}]
        try:
            for i in range(len(dbCalls)):
                self.assertEqual(dbCalls[i],close_obj_calls[i])
        except:
            self.fail("recnilize incorrect number of db calls")
        statusCalls = ['features', 'getVector']
        try:
            for i in range(len(statusCalls)):
                self.assertEqual(statusCalls[i],status_mock_calls[i])
        except:
            self.fail("recnilize incorrect number of status calls")      
        self.assertEqual(len(mock_writerow.mock_calls),2,msg="recnilize incorrect number of open calls")
        mock_open.assert_any_call('/tmpuri', 'wb')
        recanalizer.assert_any_call('any/rec/uri',radnMatrx, 2, 3, '/tmp', 'aws', None, False, False, bIndex=1, step=16, numsoffeats=41, ransakit=False, oldModel=False)
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        del dbMock
        
if __name__ == '__main__':
    unittest.main()

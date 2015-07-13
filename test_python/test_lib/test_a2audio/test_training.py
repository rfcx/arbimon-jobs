import unittest
from mock import MagicMock
import cPickle as pickle
from mock import patch
import mock
from contextlib import contextmanager
import a2pyutils.storage

from test_python.framework.assertion import assertArraysEqual
from test_python.framework.mocks import Mock_BotoBucketStorage

status_mock_calls=[]
class Status_mock:
    def __init__(self, s, f=None, v=None):
        self.status = s
        self._features = f
        self._vector = v
    def features(self):
        global status_mock_calls
        status_mock_calls.append('features')
        return self._features
        
    def getVector(self):
        global status_mock_calls
        status_mock_calls.append('getVector')
        return self._vector
        
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
    def test_roigen_err_roizer_noaudio(self,mysql_connect):
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
        config = ['host', 'user', 'pass', 'db', 'aws', 'key', 'secret', 'region']
        Mock_BotoBucketStorage.calls.clear()
        with mock.patch('contextlib.closing', mock_closing , create=False):
            with mock.patch('a2audio.training_lib.Logger', logger, create=False):
                with mock.patch('a2audio.training_lib.Roizer', roizer, create=False):
                    with mock.patch('a2pyutils.storage.BotoBucketStorage', Mock_BotoBucketStorage, create=False):
                        roizer.return_value = Status_mock('NoAudio')
                        ret = roigen(lineData,config,'/any/temp/folder','/any/cuur/dir' ,1,False,1)
                        self.assertEqual(ret,'err',msg="roigen should have returned error")
        
        logger.assert_any_call(1, 'training.py', 'roigen')
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')

        self.assertTrue(roizer.called, msg='Roizer should have been called')
        self.assertTrue(isinstance(roizer.call_args_list[0][0][2], a2pyutils.storage.AbstractStorage), msg="roizer arg #3 should be instance of AbstractStorage")
        roizer.assert_called_once('any/rec/uri', '/any/temp/folder', roizer.call_args_list[0][0][2], 1.5, 2.5, 1000.5, 2000.5, log_Writer, False,1)
        
        assertArraysEqual(self, [
            'roigen: processing any/rec/uri',
            'roigen: cutting at 1.5 to 2.5 and filtering from 1000.5 to 2000.5',
            'roigen: no audio err any/rec/uri',
        ], log_Writer.calls, "roigen incorrect order of logger writer calls")
        
        assertArraysEqual(self, [
            {'f': 'cursor'}, {'f': 'cursor'}, {'f': 'cursor'}, {'f': 'close'}
        ], dbMock.calls, msg="roigen incorrect order of database calls")

        assertArraysEqual(self, [
            {'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'},
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'},
            {'f': 'close'},
            {'q': 'INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES (1,1) ', 'f': 'execute'},
            {'f': 'close'},
        ], close_obj_calls, msg="incorrect number of database calls")


    @patch('MySQLdb.connect')
    def test_roigen_ok_roizer_hasdata(self,mysql_connect):
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
        config = ['host', 'user', 'pass', 'db', 'aws', 'key', 'secret', 'region']
        with mock.patch('contextlib.closing', mock_closing , create=False):
            with mock.patch('a2audio.training_lib.Logger', logger, create=False):
                with mock.patch('a2audio.training_lib.Roizer', roizer, create=False):
                    with mock.patch('a2pyutils.storage.BotoBucketStorage', Mock_BotoBucketStorage, create=False):
                        roi_with_Data = Status_mock('HasData')
                        roizer.return_value = roi_with_Data
                        ret = roigen(lineData,config,'/any/temp/folder','/any/cuur/dir' ,1,False,1)
                        assertArraysEqual(self, [
                            roi_with_Data, '2_3'
                        ], ret, msg="roigen should have returned a ROI object and the class")
        
        logger.assert_called_once(1, 'training.py', 'roigen')
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')

        self.assertTrue(roizer.called, msg='Roizer should have been called')
        self.assertTrue(isinstance(roizer.call_args_list[0][0][2], a2pyutils.storage.AbstractStorage), msg="roizer arg #3 should be instance of AbstractStorage")
        roizer.assert_called_once('any/rec/uri', '/any/temp/folder', roizer.call_args_list[0][0][2], 1.5, 2.5, 1000.5, 2000.5, log_Writer, False,1)

        assertArraysEqual(self, [
            'roigen: processing any/rec/uri',
            'roigen: cutting at 1.5 to 2.5 and filtering from 1000.5 to 2000.5',
            'roigen: no audio err any/rec/uri',
            'roigen: processing any/rec/uri',
            'roigen: cutting at 1.5 to 2.5 and filtering from 1000.5 to 2000.5',
            'roigen: done'
        ], log_Writer.calls, msg="roigen incorrect order of logger writer calls")

        assertArraysEqual(self, [
            {'f': 'cursor'}, {'f': 'cursor'}, {'f': 'close'}
        ], dbMock.calls, msg="incorrect number of db connection calls")
        
        assertArraysEqual(self, [
            {'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'},
            {'f': 'fetch_one'},
            {'f': 'close'},
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'},
            {'f': 'close'}
        ], close_obj_calls, msg="incorrect number of database calls")
        
    @patch('MySQLdb.connect')
    @patch('__builtin__.open')
    def test_recnilize_err_on_invalid_pid(self,mock_open,mysql_connect):
        global close_obj_calls
        global status_mock_calls
        from a2audio.roizer import Roizer
        close_obj_calls = []
        status_mock_calls = [] 
        Mock_BotoBucketStorage.calls.clear()
        from a2audio.training_lib import recnilize
        import numpy
        lineData = ['any/rec/uri',2,3,1.5,2.5,1000.5,2000.5,'any/rec/uri']
        config = ['host', 'user', 'pass', 'db', 'aws', 'key', 'secret', 'region']
        dbMock = db_mock(None)
        radnMatrx = numpy.random.rand(10,10)
        mysql_connect.return_value = dbMock
        with mock.patch('contextlib.closing', mock_closing , create=False):
            with mock.patch('a2pyutils.storage.BotoBucketStorage', Mock_BotoBucketStorage, create=False):
                ret = recnilize(lineData,config,'/tmp', 1,[radnMatrx,1,2,3,4],False,False,None,1)
                self.assertEqual(ret,'err',msg="recnilize should have returned err")
        del dbMock
        BotoBucketStorageCalls = [
            ('__init__', ('region', 'aws', 'key', 'secret'), {})
        ]
        
        assertArraysEqual(self, BotoBucketStorageCalls, Mock_BotoBucketStorage.calls.traced, msg="recnilize incorrect number of connection calls")
        mysql_connect.assert_any_call(passwd='pass', host='host', db='db', user='user')
        assertArraysEqual(self, [{'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'}, 
            {'f': 'close'}, 
            {'q': 'select `cancel_requested` from`jobs`  where `job_id` = 1', 'f': 'execute'}, 
            {'f': 'fetch_one'}, 
            {'f': 'close'}, 
            {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'}, 
            {'f': 'fetch_one'}, 
            {'f': 'close'}, 
            {'q': 'INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES (1000,1) ', 'f': 'execute'}, 
            {'f': 'close'}
        ], close_obj_calls, msg="recnilize incorrect number of db calls")        
        assertArraysEqual(self, [], status_mock_calls, msg="recnilize incorrect number of status calls")

    @patch('MySQLdb.connect')
    @patch('__builtin__.open')
    def test_recnilize_err_on_recnalizer_ret_noaudio(self, mock_open, mysql_connect):
        global close_obj_calls
        global status_mock_calls
        from a2audio.roizer import Roizer
        close_obj_calls = []
        status_mock_calls = [] 
        Mock_BotoBucketStorage.calls.clear()
        from a2audio.training_lib import recnilize
        import numpy
        lineData = ['any/rec/uri',2,3,1.5,2.5,1000.5,2000.5,'any/rec/uri']
        config = ['host', 'user', 'pass', 'db', 'aws', 'key', 'secret', 'region']
        dbMock = db_mock(None)
        radnMatrx = numpy.random.rand(10,10)
        mysql_connect.return_value = dbMock
        del dbMock
        dbMock = db_mock([1])
        mysql_connect.return_value = dbMock
        recanalizer = MagicMock()
        mock_writerow = MagicMock()
        cancelStatusM = MagicMock(return_value=None)
        with mock.patch('csv.writer',mock_writerow,create=False):
            with mock.patch('a2audio.training_lib.cancelStatus', cancelStatusM, create=False):
                with mock.patch('a2audio.training_lib.Recanalizer', recanalizer, create=False):
                    with mock.patch('contextlib.closing', mock_closing , create=False):
                        with mock.patch('a2pyutils.storage.BotoBucketStorage', Mock_BotoBucketStorage, create=False):
                            recanalizer.return_value = Status_mock('NoAudio')
                            ret = recnilize(lineData,config,'/tmp', 1,[radnMatrx,1,2,3,4],False,False,None,1)
                            self.assertEqual(ret,'err',msg="recnilize should have returned err with noAudio")
        BotoBucketStorageCalls = [
            ('__init__', ('region', 'aws', 'key', 'secret'), {})
        ]
        assertArraysEqual(self, BotoBucketStorageCalls, Mock_BotoBucketStorage.calls.traced, msg="recnilize incorrect number of connection calls")

        mysql_connect.assert_called_once(passwd='pass', host='host', db='db', user='user')
        assertArraysEqual(self, close_obj_calls, [
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'}, 
            {'f': 'close'}, 
            {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'}, 
            {'f': 'fetch_one'}, 
            {'f': 'close'}, 
            {'q': 'INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES (1000,1) ', 'f': 'execute'}, 
            {'f': 'close'}
        ], msg="recnilize incorrect number of db calls")
        statusCalls = ['features', 'getVector']
        assertArraysEqual(self, [], status_mock_calls, msg="recnilize incorrect number of status calls")
        self.assertFalse(mock_open.called, msg='open should not have been called')
        recanalizer.assert_called_once('any/rec/uri',radnMatrx, 2, 3, '/tmp', 'aws', None, False, False, bIndex=1, step=16, numsoffeats=41, ransakit=False, oldModel=False)

    @patch('MySQLdb.connect')
    @patch('__builtin__.open')
    def test_recnilize_recnalizer_ret_success(self,mock_open,mysql_connect):
        global close_obj_calls
        global status_mock_calls
        from a2audio.roizer import Roizer
        close_obj_calls = []
        status_mock_calls = [] 
        Mock_BotoBucketStorage.calls.clear()
        from a2audio.training_lib import recnilize
        import numpy
        lineData = ['any/rec/uri',2,3,1.5,2.5,1000.5,2000.5,'any/rec/uri']
        config = ['host', 'user', 'pass', 'db', 'aws', 'key', 'secret', 'region']
        radnMatrx = numpy.random.rand(10,10)
        dbMock = db_mock([1])
        mysql_connect.return_value = dbMock
        recanalizer = MagicMock()
        mock_writerow = MagicMock()
        cancelStatusM = MagicMock(return_value=None)
        with mock.patch('csv.writer',mock_writerow,create=False):
            with mock.patch('a2audio.training_lib.cancelStatus', cancelStatusM, create=False):
                with mock.patch('a2audio.training_lib.Recanalizer', recanalizer, create=False):
                    with mock.patch('contextlib.closing', mock_closing , create=False):
                        with mock.patch('a2pyutils.storage.BotoBucketStorage', Mock_BotoBucketStorage, create=False):
                            recanalizer.return_value = Status_mock('Processed', [1, 2, 3], [0,0,1,1,2,2,0,0])
                            ret = recnilize(lineData,config,'/tmp', 1,[radnMatrx,1,2,3,4],False,False,None,1)

        recanalizer.assert_called_once('any/rec/uri',radnMatrx, 2, 3, '/tmp', 'aws', None, False, False, bIndex=1, step=16, numsoffeats=41, ransakit=False, oldModel=False)

        assertArraysEqual(self, [
            'features', 'getVector'
        ], status_mock_calls, msg="recnilize incorrect number of status calls")

        assertArraysEqual(self, [
            ('__init__', ('region', 'aws', 'key', 'secret'), {}),
            ('put_file', ('project_1/training_vectors/job_1/uri', '0,0,1,1,2,2,0,0'), {'acl': 'public-read'})
        ], Mock_BotoBucketStorage.calls.traced, "recnilize incorrect number of connection calls")

        mysql_connect.assert_called_once(passwd='pass', host='host', db='db', user='user')
        assertArraysEqual(self, [
            {'q': 'update `jobs` set `state`="processing", `progress` = `progress` + 1 where `job_id` = 1', 'f': 'execute'}, 
            {'f': 'close'}, 
            {'q': 'SELECT `project_id` FROM `jobs` WHERE `job_id` =  1', 'f': 'execute'}, 
            {'f': 'fetch_one'}, 
            {'f': 'close'}
        ], close_obj_calls, msg="recnilize incorrect number of db calls")
        
if __name__ == '__main__':
    unittest.main()

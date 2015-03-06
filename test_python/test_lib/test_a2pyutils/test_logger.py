import unittest
import mock
from mock import mock_open
from mock import patch

os_path_exists_calls = []
def os_path_exists(pathn):
    os_path_exists_calls.append(pathn)
    return False

os_makedirs_calls = []
def os_makedirs(pathn):
    os_makedirs_calls.append(pathn)
    pass

os_path_isfile_calls = []
def os_path_isfile(filen):
    os_path_isfile_calls.append(filen)
    return False


class Test_logger(unittest.TestCase):

    def test_import(self):
        """Test logger module can be imported"""
        try:
            from a2pyutils.logger import Logger
        except ImportError:
            self.fail("Cannot load a2pyutils.logger module")
    
    @patch('time.strftime')
    @patch('time.time')
    @patch('time.gmtime')
    @patch('tempfile.gettempdir')
    def test_init(self,mock_tempfile,time_gmtime,time_time,time_strftime):
        mock_tempfile.return_value = '/tmp'
        time_gmtime.return_value = 234567890
        time_time.return_value = 123456789
        time_strftime.return_value = '2222-01-01 00:00:00'
        
        """Test logger init arguments"""
        from a2pyutils.logger import Logger
        import os
        import shutil
  
        """Test invalid arguments"""
        raisingargs3 =[
            ['1',"script","logFor"],
            [1,1,"logFor"],
            [1,"script",1]
        ]
        global os_path_exists_calls 
        global os_makedirs_calls 
        global os_path_isfile_calls
        m = mock_open()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('os.path.isfile',os_path_isfile, create=False):
                with mock.patch('os.makedirs',os_makedirs, create=False):
                    with mock.patch('os.path.exists',os_path_exists, create=False):
                        
                        for ar in raisingargs3:
                            self.assertRaises(ValueError,Logger,ar[0],ar[1],ar[2])
                            
                        self.assertRaises(ValueError,Logger,1,"script",'logFor',1)
                        self.assertIsInstance( Logger(1,"script",'logFor',False) ,Logger)
                        self.assertEqual(len(m.mock_calls),0,msg="Logger error: no log should have been written yet")
                        self.assertIsInstance( Logger(1,"script",'logFor',True) ,Logger)
                        self.assertEqual(len(m.mock_calls),3,msg="Logger error: only three calls should have been made: open, write and close.")                        
                        logs = Logger(1,"tester",'test',False)
                        self.assertEqual(len(m.mock_calls),3,msg="Logger error: only three calls should have been made: open, write and close.")

        self.assertEqual(len(os_path_exists_calls),1,msg="Logger: wrong os path exists calls")
        self.assertEqual(len(os_makedirs_calls),1,msg="Logger: wrong os makedirs calls")
        self.assertEqual(len(os_path_isfile_calls),1,msg="Logger: wrong os path isfile calls")    
        os_path_exists_calls = []
        os_makedirs_calls = []
        os_path_isfile_calls = []
 
    @patch('time.strftime')
    @patch('time.time')
    @patch('time.gmtime')
    @patch('tempfile.gettempdir')       
    def test_write(self,mock_tempfile,time_gmtime,time_time,time_strftime):
        mock_tempfile.return_value = '/tmp'
        time_gmtime.return_value = 234567890
        time_time.return_value = 123456789
        time_strftime.return_value = '2222-01-01 00:00:00'
        
        """Test logger write function"""
        from a2pyutils.logger import Logger
        import os
        import shutil
        global os_path_exists_calls 
        global os_makedirs_calls 
        global os_path_isfile_calls
        m = mock_open()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('os.path.isfile',os_path_isfile, create=False):
                with mock.patch('os.makedirs',os_makedirs, create=False):
                    with mock.patch('os.path.exists',os_path_exists, create=False):
                        logs = Logger(1,"tester",'test')
                        searchContent = ['tester log file','write this','test text logger','another test string','debug this error logger']
                        for ss in searchContent:
                            logs.write(ss)
                        for ss in searchContent:
                            found = False
                            for cc in m.mock_calls :
                               if ss in str(cc):
                                    found = True
                                    break
                            self.assertTrue(found,msg="Logger: string was not written into log. Log failed")               
                        
        self.assertEqual(len(os_path_exists_calls),1,msg="Logger: wrong os path exists calls")
        self.assertEqual(len(os_makedirs_calls),1,msg="Logger: wrong os makedirs calls")
        self.assertEqual(len(os_path_isfile_calls),1,msg="Logger: wrong os path isfile calls")    
        os_path_exists_calls = []
        os_makedirs_calls = []
        os_path_isfile_calls = []
 
    @patch('time.strftime')
    @patch('time.time')
    @patch('time.gmtime')
    @patch('tempfile.gettempdir')          
    def test_write_clean(self,mock_tempfile,time_gmtime,time_time,time_strftime):
        mock_tempfile.return_value = '/tmp'
        time_gmtime.return_value = 234567890
        time_time.return_value = 123456789
        time_strftime.return_value = '2222-01-01 00:00:00'
        
        """Test logger write_clean function"""
        from a2pyutils.logger import Logger
        import os
        import shutil
        global os_path_exists_calls 
        global os_makedirs_calls 
        global os_path_isfile_calls
        m = mock_open()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('os.path.isfile',os_path_isfile, create=False):
                with mock.patch('os.makedirs',os_makedirs, create=False):
                    with mock.patch('os.path.exists',os_path_exists, create=False):
                        logs = Logger(1,"tester",'test')
                        searchContent = ['tester log file','write this','test text logger','another test string','debug this error logger']
                        for ss in searchContent:
                            logs.write_clean(ss)
                        for ss in searchContent:
                            found = False
                            for cc in m.mock_calls :
                               if ss in str(cc):
                                    found = True
                                    break
                            self.assertTrue(found,msg="Logger: string was not written into log. Log failed")               
                        
        self.assertEqual(len(os_path_exists_calls),1,msg="Logger: wrong os path exists calls")
        self.assertEqual(len(os_makedirs_calls),1,msg="Logger: wrong os makedirs calls")
        self.assertEqual(len(os_path_isfile_calls),1,msg="Logger: wrong os path isfile calls")    
        os_path_exists_calls = []
        os_makedirs_calls = []
        os_path_isfile_calls = []

 
    @patch('time.strftime')
    @patch('time.time')
    @patch('time.gmtime')
    @patch('tempfile.gettempdir')          
    def test_time_delta(self,mock_tempfile,time_gmtime,time_time,time_strftime):
        mock_tempfile.return_value = '/tmp'
        time_gmtime.return_value = 234567890
        time_time.return_value = 123456789
        time_strftime.return_value = '2222-01-01 00:00:00'
        
        """Test logger write_clean function"""
        from a2pyutils.logger import Logger
        import os
        import time
        import shutil
        global os_path_exists_calls 
        global os_makedirs_calls 
        global os_path_isfile_calls
        m = mock_open()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('os.path.isfile',os_path_isfile, create=False):
                with mock.patch('os.makedirs',os_makedirs, create=False):
                    with mock.patch('os.path.exists',os_path_exists, create=False):
                        logs = Logger(1,"tester",'test')
                        searchContent = ['tester log file','write this','test text logger','another test string','debug this error logger']
                        for ss in searchContent:
                            logs.time_delta(ss,time.time())
                        for ss in searchContent:
                            found = False
                            for cc in m.mock_calls :
                               if ss in str(cc):
                                    found = True
                                    break
                            self.assertTrue(found,msg="Logger: string was not written into log. Log failed")               
                        
        self.assertEqual(len(os_path_exists_calls),1,msg="Logger: wrong os path exists calls")
        self.assertEqual(len(os_makedirs_calls),1,msg="Logger: wrong os makedirs calls")
        self.assertEqual(len(os_path_isfile_calls),1,msg="Logger: wrong os path isfile calls")    
        os_path_exists_calls = []
        os_makedirs_calls = []
        os_path_isfile_calls = []
            
if __name__ == '__main__':
    unittest.main()

import unittest
from mock import MagicMock
import mock
from mock import patch

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
            exit_error('TESTING MESSAGE : EXIT_ERROR FUNCTION : THIS IS NOT AN ERROR')
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
        
if __name__ == '__main__':
    unittest.main()

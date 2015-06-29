import unittest
import mock

def mock_os_path_join(v1,v2=''):
    if v2 == '':
        return v1
    else:
        return v1+"/"+v2
    
class File_mock(object):
    def __init__(self, filen):
        self.f = filen
    def __exit__(self,a,c,d):
        return self.f
    def __enter__(self ):
        return self.f    
    
def mock_open_custom(filen):
    stringParts = str(filen).split("/")
    filen = stringParts[len(stringParts)-1]
    fmockinst = File_mock
    returnMockFile = fmockinst(filen)
    return returnMockFile

def mock_json_load(filen):
    data = {
        "aws.json" : {'secretAccessKey': 'awsAccess_password_Data_test', 'region': 'some_Regions_in_the_us', 'bucketName': 'a_bucket_name_somewhere', 'accessKeyId': 'awsAccess_Data_test'},
        "db.json" : {'timezone': 'config_test', 'host': 'dummy_host_test', 'password': 'great_password_test', 'user': 'arbimon2_user_test', 'database': 'an_arbimon2_test'}
    }
    return data[filen]

def mock_os_path_isfile(f):
    return False

class Test_config(unittest.TestCase):

    def test_import(self):
        """Test a2pyutils.config module can be imported"""
        try:
            from a2pyutils.config import Config
        except ImportError:
            self.fail("Cannot load a2pyutils.config module")
            
    def test_load_config(self):
        """Test a2pyutils.config init arguments"""
        from a2pyutils.config import Config
        with mock.patch('os.path.join', mock_os_path_join, create=False):
            with mock.patch('os.path.isfile',mock_os_path_isfile, create=False):
                with mock.patch('__builtin__.open', mock_open_custom, create=False):
                    with mock.patch('json.load', mock_json_load, create=False):
                        configuration = Config("test_python/data/configs")
                        config = configuration.data()
                        testData = ['dummy_host_test', 'arbimon2_user_test', 'great_password_test', 'an_arbimon2_test', 'a_bucket_name_somewhere', 'awsAccess_Data_test', 'awsAccess_password_Data_test', 'some_Regions_in_the_us']
                        for cc in range(len(config)):
                            self.assertEqual(config[cc],testData[cc],msg="a2pyutils.config loaded wrong configuration data")

if __name__ == '__main__':
    unittest.main()

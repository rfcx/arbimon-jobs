import unittest

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
        configuration = Config("test_python/data/configs")
        config = configuration.data()
        testData = ['dummy_host_test', 'arbimon2_user_test', 'great_password_test', 'an_arbimon2_test', 'a_bucket_name_somewhere', 'awsAccess_Data_test', 'awsAccess_password_Data_test']
        for cc in range(len(config)):
            self.assertEqual(config[cc],testData[cc],msg="a2pyutils.config loaded wrong configuration data")

if __name__ == '__main__':
    unittest.main()

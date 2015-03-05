import unittest

class Test_logger(unittest.TestCase):

    def test_import(self):
        """Test logger module can be imported"""
        try:
            from a2pyutils.logger import Logger
        except ImportError:
            self.fail("Cannot load a2pyutils.logger module")
            
    def test_init(self):
        """Test logger init arguments"""
        from a2pyutils.logger import Logger
        import os
        import shutil
        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')
            
        """Test invalid arguments"""
        raisingargs3 =[
            ['1',"script","logFor"],
            [1,1,"logFor"],
            [1,"script",1]
        ]
        
        for ar in raisingargs3:
            self.assertRaises(ValueError,Logger,ar[0],ar[1],ar[2])
            
        self.assertRaises(ValueError,Logger,1,"script",'logFor',1)
        self.assertIsInstance( Logger(1,"script",'logFor',False) ,Logger)

        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')
            
        logs = Logger(1,"tester",'test',False)
        logFile = '/tmp/logs/job_1/tester_test_0.log'
        self.assertFalse(os.path.isfile(logFile),msg="Logger failed: created logFile with flag logOn set to False")
        
    def test_write(self):
        """Test logger write function"""
        from a2pyutils.logger import Logger
        import os
        import shutil
        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')
        logs = Logger(1,"tester",'test')
        logFile = '/tmp/logs/job_1/tester_test_0.log'
        self.assertTrue(os.path.isfile(logFile),msg="Logger failed to create log file in /tmp/logs")
        searchContent = ['tester log file','write this','test text logger','another test string','debug this error logger']
        for ss in searchContent:
            logs.write(ss)
        fContent = None
        if os.path.isfile(logFile):
            with open(logFile) as f:
                fContent = f.read()
        for ss in searchContent:
            self.assertTrue(ss in fContent,msg="Logger failed to write correct string")
        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')

    def test_write_clean(self):
        """Test logger write_clean function"""
        from a2pyutils.logger import Logger
        import os
        import shutil
        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')
        logs = Logger(1,"tester",'test')
        logFile = '/tmp/logs/job_1/tester_test_0.log'
        self.assertTrue(os.path.isfile(logFile),msg="Logger failed to create log file in /tmp/logs")
        searchContent = ['tester log file','write this','test text logger','another test string','debug this error logger']
        for ss in searchContent:
            logs.write_clean(ss)  
        fContent = None
        if os.path.isfile(logFile):
            with open(logFile) as f:
                fContent = f.read() 
        for ss in searchContent:
            self.assertTrue(ss in fContent,msg="Logger failed to write correct string")
        if os.path.exists('/tmp/logs/'):
            shutil.rmtree('/tmp/logs/')
                       
if __name__ == '__main__':
    unittest.main()

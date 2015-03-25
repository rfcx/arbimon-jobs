import unittest
from mock import MagicMock

class Test_r(unittest.TestCase):

    def test_r(self):
        """Run R Tests"""
        import os
        import subprocess

        currDir = (os.path.dirname(os.path.realpath(__file__)))

        proc = subprocess.Popen([
            '/usr/bin/Rscript', currDir+'/test_run_r_tests.R',
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate()

        self.assertTrue('Number of test functions: 9' in stdout,msg='R tests: test functions should have been 9')
        self.assertTrue('Number of errors: 0 ' in stdout,msg='R tests: errors should have been 0')
        self.assertTrue('Number of failures: 0' in stdout,msg='R tests: failures should have been 0')
        
if __name__ == '__main__':
    unittest.main()

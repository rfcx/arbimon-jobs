import unittest

sys_exit_calls = []
class sys_exit:
    def __init__(self):
        pass
    def __call__(self,v):
        pass
    def exit(self):
        global sys_exit_calls
        sys_exit_calls.append({'f':'exit'})
        
outputstringcorrect="""job_id
    job_id - job id in database"""

run_mock_calls = []
def run_mock(a):
    global run_mock_calls
    run_mock_calls.append(a)
    return True
    
class Test_classify(unittest.TestCase):
    def test_file_can_be_called(self):
        from cStringIO import StringIO
        import sys
        import imp
        global sys_exit_calls
        output = StringIO()
        saved_stdout = sys.stdout
        sys.stdout = output
        classify = imp.load_source('classify', 'scripts/PatternMatching/classify.py')
        classify.sys = sys_exit()
        classify.main([])
        outputString = output.getvalue()
        output.close()
        sys.stdout = saved_stdout
        self.assertEqual(sys_exit_calls[0],{'f': 'exit'},msg="incorrect sys exit call")
        #self.assertTrue(outputstringcorrect in outputString,msg="file_can_be_called: Incorrect output message")
        
    def test_file_can_be_called_with_args(self):
        from cStringIO import StringIO
        import sys
        import imp
        global sys_exit_calls
        global run_mock_calls 
        run_mock_calls = []
        sys_exit_calls = []
        output = StringIO()
        saved_stdout = sys.stdout
        sys.stdout = output
        classify = imp.load_source('classify', 'scripts/PatternMatching/classify.py')
        classify.sys =  sys_exit()
        classify.run_classification = run_mock
        classify.main(['script/name',1999])
        outputString = output.getvalue()
        output.close()
        sys.stdout = saved_stdout
        self.assertEqual(len(sys_exit_calls),0,msg="no exit calls expected")
        self.assertEqual(run_mock_calls,[1999],msg="incorrect call to run function")
        self.assertEqual('end\n',outputString,msg="file_can_be_called_with_args: Incorrect output message")
        
if __name__ == '__main__':
    unittest.main()
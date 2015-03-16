import unittest
from mock import MagicMock
import json
from mock import patch
import mock

def os_stat_raising(f):
    raise OSError(2, 'No such file or directory', f)

class Mock_cache(object):
    mock_calls = {}
    def _init_(self):
        pass
    def key2File(self,f):
        if "key2File" in self.mock_calls:
            self.mock_calls["key2File"][f] = True
        else:
            self.mock_calls["key2File"] = {}
            self.mock_calls["key2File"][f] =True
        return "dummy"
    def put(self,f,d):
        if "put" in self.mock_calls:
            self.mock_calls["put"][f] = True
            self.mock_calls["put"][d] = True
        else:
            self.mock_calls["put"] = {}
            self.mock_calls["put"][f] = True
            self.mock_calls["put"][d] = True
    def get(self,f):
        if "get" in self.mock_calls:
            self.mock_calls["get"][f] = True
        else:
            self.mock_calls["get"] = {}
            self.mock_calls["get"][f] = True
        return "dummy"
    def has_call(self,who,*arg):
        args_count = len(arg)
        if who in self.mock_calls:
            cc =  self.mock_calls[who]
            hasAll = True
            for a in arg:
                hasAll = hasAll and a in cc
            return 'Found'
        else:
            return 'NotFound'
    
class Test_tempfilecache_Cache(unittest.TestCase):

    def test_import(self):
        try:
            from a2pyutils import tempfilecache
        except ImportError:
            self.fail("Cannot load a2pyutils.tempfilecache module")
            
    def test_instance_Cache(self):
        from a2pyutils import tempfilecache 
        cacheTest = tempfilecache.Cache('/dummy/root/folder/')
        self.assertIsInstance(cacheTest,tempfilecache.Cache,msg="Not an instance of tempfilecache.Cache")

class Test_tempfilecache_Cache_usage(unittest.TestCase):
            
    def setUp(self):
        from a2pyutils import tempfilecache 
        self.cacheTest = tempfilecache.Cache('/dummy/root/folder/')
        with open('test_python/data/filecachehashes.json') as fd:
            self.hashesTest= json.load(fd)
            
    def test_hash_key(self):
        """Test the Cache.hash_key function"""
        for hk in self.hashesTest:
            self.assertEqual(self.cacheTest.hash_key(hk["key"]),hk["hash"],msg="tempfilecache.Cache.hash_key hash is incorrect")
    
    def test_key2File(self):
        """Test the Cache.hash_key function"""     
        for hk in self.hashesTest:
            self.assertEqual(self.cacheTest.key2File(hk["key"]),'/dummy/root/folder/'+hk["hash"],msg="tempfilecache.Cache.key2File path is incorrect")
    
    @patch("os.stat")
    def test_checkValidity(self,os_stat):
        """Test Cache.checkValidity function"""
        import numpy   
        for hk in self.hashesTest:
            randomStats = numpy.random.rand(5)
            os_stat.return_value =  randomStats 
            isVlid = self.cacheTest.checkValidity('/dummy/root/folder/'+hk["hash"])
            self.assertEqual(isVlid["path"],'/dummy/root/folder/'+hk["hash"],msg="Cache.checkValidity returned invalid path")
            stats = isVlid["stat"]
            for i in range(len(randomStats)):
                self.assertEqual(stats[i],randomStats[i],msg="Cache.checkValidity returned invalid stats")
                
    def test_checkValidity_invalid(self):
        """Test Cache.checkValidity function"""
        with mock.patch('os.stat', os_stat_raising , create=False):
            isVlid = self.cacheTest.checkValidity('/dummy/root/folder/anyinvalidfile')
            self.assertIsNone(isVlid,msg="Cache.checkValidity: should have returned None (invalid file)")
 
    @patch("os.stat")
    def test_get(self,os_stat):
        """Test Cache.get function"""
        import numpy     
        for hk in self.hashesTest:
            randomStats = numpy.random.rand(5)
            os_stat.return_value =  randomStats
            getReturn = self.cacheTest.get(hk["key"])
            self.assertEqual(getReturn["path"],'/dummy/root/folder/'+hk["hash"],msg="tempfilecache.Cache.get returned path is incorrect")
            stats = getReturn["stat"]
            for i in range(len(randomStats)):
                self.assertEqual(stats[i],randomStats[i],msg="Cache.get  returned invalid stats")
    
    @patch("__builtin__.open")
    def test_put(self,mock_open):
        """Test Cache.put function"""
        import numpy
        for hk in self.hashesTest:
            randomData = numpy.random.rand(100)
            self.cacheTest.put(hk["key"],randomData )
            mock_open.assert_any_calls(hk["hash"],"wb")
            mock_open.assert_any_calls(randomData)
            mock_open.reset_mock()
            
    @patch("os.stat")
    def test_fetch(self,os_stat):
        """Test Cache.fetch function"""
        import numpy     
        for hk in self.hashesTest:
            randomStats = numpy.random.rand(5)
            os_stat.return_value =  randomStats
            getReturn = self.cacheTest.fetch(hk["key"])
            self.assertEqual(getReturn["path"],'/dummy/root/folder/'+hk["hash"],msg="tempfilecache.Cache.get returned path is incorrect")
            stats = getReturn["stat"]
            for i in range(len(randomStats)):
                self.assertEqual(stats[i],randomStats[i],msg="Cache.get  returned invalid stats")
                
    def test_checkValidity_invalid(self):
        """Test Cache.checkValidity function"""
        from a2pyutils import tempfilecache
        with mock.patch('os.stat', os_stat_raising , create=False):
            isVlid = self.cacheTest.fetch('/dummy/root/folder/anyinvalidfile')
            self.assertIsInstance(isVlid,tempfilecache.CacheMiss,msg="Cache.checkValidity: should have returned None (invalid file)")

class Test_tempfilecache_CacheMiss(unittest.TestCase):
    
    def setUp(self):
        from a2pyutils import tempfilecache 
        self.cacheTest = Mock_cache()
            
    def test_instance_Cache(self):
        from a2pyutils import tempfilecache 
        cacheMissTest = tempfilecache.CacheMiss(self.cacheTest,'/dummy/root/folder/')
        self.assertIsInstance(cacheMissTest,tempfilecache.CacheMiss,msg="Not an instance of tempfilecache.Cache")
        self.assertEqual(self.cacheTest.has_call('key2File','/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.key2File")

    def test_set_file_data(self):
        from a2pyutils import tempfilecache 
        cacheMissTest = tempfilecache.CacheMiss(self.cacheTest,'/dummy/root/folder/')
        self.assertIsInstance(cacheMissTest,tempfilecache.CacheMiss,msg="Not an instance of tempfilecache.Cache")
        self.assertEqual(self.cacheTest.has_call('key2File','/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.key2File")
        cacheMissTest.set_file_data('some_dummy_data')
        self.assertEqual(self.cacheTest.has_call('put','some_dummy_data', '/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.put")
 
    def test_set_file_data(self):
        from a2pyutils import tempfilecache 
        cacheMissTest = tempfilecache.CacheMiss(self.cacheTest,'/dummy/root/folder/')
        self.assertIsInstance(cacheMissTest,tempfilecache.CacheMiss,msg="Not an instance of tempfilecache.Cache")
        self.assertEqual(self.cacheTest.has_call('key2File','/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.key2File")
        cacheMissTest.set_file_data('some_dummy_data')
        self.assertEqual(self.cacheTest.has_call('put','some_dummy_data', '/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.put")
        cacheMissTest.retry_get()
        self.assertEqual(self.cacheTest.has_call('get', '/dummy/root/folder/'),'Found',msg="CacheMiss: did not call Cache.get")
        
if __name__ == '__main__':
    unittest.main()
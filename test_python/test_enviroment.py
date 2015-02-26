import unittest
import imp

libs = ["numpy","scikits","skimage","virtualenv","argparse","png","wsgiref","boto","MySQLdb","scipy","joblib","matplotlib","sklearn"]

def load(lib):
    return imp.find_module(lib)
    
class Test_enviroment(unittest.TestCase):
    def test_libs_imports(self):
        for i in libs:
            self.assertIsNotNone(load(i))

if __name__ == '__main__':
    unittest.main()

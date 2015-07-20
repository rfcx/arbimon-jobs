import storage

class LocalFile(object):
    def __init__(self, fd):
        self.fd = fd

    def read(self, size=None):
        pass
            
    @staticmethod
    def line_reader(fd):
       pass

    def readline(self, size=None):
        pass
        
class LocalStorage(storage.AbstractStorage):
    def __init__(self, folder):
        self.folder = folder
        
    def get_file_uri(self, file):
        pass
        
    def get_file(self, file):
        pass
    
    def put_file(self, file, filedata, acl=None):
        pass

    def __getstate__(self):
        return {}
        
    def __setstate__(self, state):
        pass
        

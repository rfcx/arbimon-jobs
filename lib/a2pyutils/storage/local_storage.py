import storage

class LocalFile(object):
    def __init__(self, file):
        self.file = file
        self.fd = open(file)

    def read(self, size=None):
       return self.fd.read()
            
    @staticmethod
    def line_reader(fd):
       pass

    def readline(self, size=None):
        pass
        
class LocalStorage(storage.AbstractStorage):
    def __init__(self, folder):
        self.folder = folder
        self.fd = None
        
    def get_file_uri(self, file):
        return self.folder
        
    def get_file(self, file):
        return  LocalFile(self.folder+'/'+file)
    
    def put_file(self, file, filedata, acl=None):
        pass

    def __getstate__(self):
        return {}
        
    def __setstate__(self, state):
        pass
        

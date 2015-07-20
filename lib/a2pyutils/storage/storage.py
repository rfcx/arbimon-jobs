class StorageError(StandardError):
    pass
    
class AbstractStorage(object):
    """Represents a place where files can be obtained from and stored to."""
    
    def get_file_uri(self, file):
        return ''
        
    def get_file(self, file):
        return None

    def put_file(self, file, filedata, acl=None):
        raise StorageError("Cannot put file " + file + " to " + self.__class__.__name__)

    def put_file_fd(self, file, fd, acl=None):
        self.put_file(file, fd.read(), acl=acl)

    def put_file_path(self, file, filepath, acl=None):
        with open(filepath, 'rb') as fd:
            self.put_file_fd(file, fd, acl=acl)

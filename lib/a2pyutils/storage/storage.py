class StorageError(StandardError):
    pass
    
class AbstractStorage(object):
    """Represents a place where files can be obtained from and stored to."""
    
    def get_file_uri(self, file):
        return ''
        
    def get_file(self, file):
        return None
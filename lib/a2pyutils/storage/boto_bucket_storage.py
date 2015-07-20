import boto3
import storage
import botocore.exceptions

class BotoBucketFile(object):
    def __init__(self, fd):
        self.fd = fd

    def read(self, size=None):
        if size is None:
            return self.fd.read()
        else:
            return self.fd.read(size)
            
    @staticmethod
    def line_reader(fd):
        c = fd.read(1)
        while c != '':
            yield c
            if c == '\n':
                break
            c = fd.read(1)

    def readline(self, size=None):
        return ''.join(c for c in self.line_reader(self.fd))
        
class BotoBucketStorage(storage.AbstractStorage):
    def __init__(self, region, bucketName, accessKeyId=None, secretAccessKey=None, **kwdargs):
        params = {'region_name': region};
        if accessKeyId:
            params['aws_access_key_id'] = accessKeyId
        if secretAccessKey:
            params['aws_secret_access_key'] = secretAccessKey
            
        self.__setstate__([bucketName, params])
        
    def get_file_uri(self, file):
        """Returns an URI representing the given file in this storage."""
        return 's3:/'+self.bucket+'/'+file
        
    def get_file(self, file):
        """Fetches a file from storage."""
        keyobject = self.s3.Object(bucket_name=self.bucket, key=file)
        try:
            response = keyobject.get()
            return BotoBucketFile(response['Body'])
        except botocore.exceptions.ClientError, e:
            raise storage.StorageError(e.message)

    def put_file(self, file, filedata, acl=None):
        """Puts a file in the storage with filedata as its contents. Also allows setting the ACL."""
        params={'Body':filedata}
        if acl:
            params['ACL'] = acl
        keyobject = self.s3.Object(bucket_name=self.bucket, key=file)
        try:
            response = keyobject.put(**params)
        except botocore.exceptions.ClientError, e:
            raise storage.StorageError(e.message)

    def __getstate__(self):
        return self.bucket, self._params
        
    def __setstate__(self, state):
        bucketName, params = state
        self.s3 = boto3.resource("s3", **params)
        self._params = params
        self.bucket = bucketName
        

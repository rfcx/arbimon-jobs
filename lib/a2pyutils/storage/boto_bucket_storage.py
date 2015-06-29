import boto3
import storage
import botocore.exceptions

class BotoBucketStorage(storage.AbstractStorage):
    def __init__(self, region, bucketName, accessKeyId=None, secretAccessKey=None, **kwdargs):
        params = {'region_name': region};
        if accessKeyId:
            params['aws_access_key_id'] = accessKeyId
        if secretAccessKey:
            params['aws_secret_access_key'] = secretAccessKey
            
        self.s3 = boto3.resource("s3", **params)
        self.bucket = bucketName
        
    def get_file_uri(self, file):
        """Returns an URI representing the given file in this storage."""
        return 's3:/'+self.bucket+'/'+file
        
    def get_file(self, file):
        """Fetches a file from storage."""
        keyobject = self.s3.Object(bucket_name=self.bucket, key=file)
        try:
            response = keyobject.get()
            return response['Body']
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


import boto3
import storage
import botocore.exceptions

class BotoBucketStorage(storage.AbstractStorage):
    def __init__(self, aws_region, bucket_name, access_key=None, secret_access_key=None):
        params = {'region_name': aws_region};
        if access_key:
            params['aws_access_key_id'] = access_key
        if secret_access_key:
            params['aws_secret_access_key'] = secret_access_key
            
        self.s3 = boto3.resource("s3", **params)
        self.bucket = bucket_name
        
    def get_file_uri(self, file):
        return 's3:/'+self.bucket+'/'+file
        
    def get_file(self, file):
        keyobject = self.s3.Object(bucket_name=self.bucket, key=file)
        try:
            response = keyobject.get()
            return response['Body']
        except botocore.exceptions.ClientError, e:
            raise storage.StorageError(e.message)

    def put_file(self, file, filedata, acl=None):
        params={'Body':filedata}
        if acl:
            params['ACL'] = acl
        keyobject = self.s3.Object(bucket_name=self.bucket, key=file)
        try:
            response = keyobject.put(**params)
        except botocore.exceptions.ClientError, e:
            raise storage.StorageError(e.message)
        
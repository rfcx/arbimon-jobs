"""
bucket.py

Utility module for using a default configured singleton connection to an s3
bucket, plus some utility functions.
"""
import config
import urllib
import urllib2
import httplib
import time
import boto

def get_bucket():
    "Returns a reference to a default configured singleton bucket connection instance"
    cfg = config.get_config()

    bucket_name = cfg.awsConfig['bucket_name']
    aws_key_id = cfg.awsConfig['access_key_id']
    aws_key_secret = cfg.awsConfig['secret_access_key']

    conn = boto.s3.connection.S3Connection(aws_key_id, aws_key_secret)

    return conn.get_bucket(bucket_name, validate=False)

def get_url(uri=''):
    "returns the url to a bucket object"
    cfg = config.get_config()
    bucket_name = cfg.awsConfig['bucket_name']
    return 'https://s3.amazonaws.com/' + bucket_name + '/' + urllib.quote(uri)

def open_url(uri='', retries=5):
    "returns a file-like instance with the contents of a public bucket object."
    contents = None
    url = get_url(uri)

    retryCount = 0
    while not contents and retryCount < retries:
        try:
            contents = urllib2.urlopen(url)
        except httplib.HTTPException:
            time.sleep(1.5 ** retryCount) # exponential waiting
        except urllib2.HTTPError:
            time.sleep(1.5 ** retryCount) # exponential waiting
        except urllib2.URLError:
            time.sleep(1.5 ** retryCount) # exponential waiting
        retryCount += 1

    return contents

def upload_string(key, contents, acl=None):
    "uploads a string to the bucket."
    key_object = get_bucket().new_key(key)
    key_object.set_contents_from_string(contents)
    if acl:
        key_object.set_acl(acl)

def upload_filename(key, filename, acl=None):
    "uploads a string to the bucket."
    key_object = get_bucket().new_key(key)
    key_object.set_contents_from_filename(filename)
    if acl:
        key_object.set_acl(acl)
    
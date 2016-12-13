import config
import urllib
import urllib2
import httplib
import time
import boto

def get_bucket():
    cfg = config.get_config()
    
    bucketName = cfg.awsConfig['bucket_name']
    awsKeyId = cfg.awsConfig['access_key_id']
    awsKeySecret = cfg.awsConfig['secret_access_key']

    conn = boto.s3.connection.S3Connection(awsKeyId, awsKeySecret)

    return conn.get_bucket(bucketName, validate=False)

def get_url(uri=''):
    cfg = config.get_config()
    bucketName = cfg.awsConfig['bucket_name']
    return 'https://s3.amazonaws.com/' + bucketName + '/' + urllib.quote(uri)

def open_url(uri='', retries=5):
    f = None
    url = get_url(uri)

    retryCount = 0
    while not f and retryCount < retries:
        try:
            f = urllib2.urlopen(url)
        except httplib.HTTPException:
            time.sleep(1.5 ** retryCount) # exponential waiting
        except urllib2.HTTPError:
            time.sleep(1.5 ** retryCount) # exponential waiting
        except urllib2.URLError:
            time.sleep(1.5 ** retryCount) # exponential waiting
        retryCount += 1
    
    return f

import math
import os
import time
import sys
import warnings
from urllib import quote
import urllib2
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    from scikits.audiolab import Sndfile, Format
import contextlib
import numpy as np
from a2pyutils.logger import Logger
from scikits.samplerate import resample

encodings = {
    "pcms8":8,
    "pcm16":16,
    "pcm24":32,
    "pcm32":32,
    "pcmu8":8,
    "float32":32,
    "float64":64,
    "ulaw":16,
    "alaw":16,
    "ima_adpcm":16,
    "gsm610":16,
    "dww12":16,
    "dww16":16,
    "dww24":32,
    "g721_32":32,
    "g723_24":32,
    "vorbis":16,
    "vox_adpcm":16,
    "ms_adpcm":16,
    "dpcm16":16,
    "dpcm8":8
}

analysis_sample_rates = [16000.0,32000.0,48000.0,96000.0,192000.0]

class Rec:

    filename = ''
    samples = 0
    sample_rate = 0
    channs = 0
    status = 'NotProcessed'
    
    def __init__(self, uri, tempFolder, bucketName, logs=None, removeFile=True , test=False):
        
        if type(uri) is not str and type(uri) is not unicode:
            raise ValueError("uri must be a string")
        if type(tempFolder) is not str:
            raise ValueError("invalid tempFolder")
        if not os.path.exists(tempFolder):
            raise ValueError("invalid tempFolder")
        elif not os.access(tempFolder, os.W_OK):
            raise ValueError("invalid tempFolder")
        if type(bucketName) is not str:
            raise ValueError("bucketName must be a string")
        if logs is not None and not isinstance(logs,Logger):
            raise ValueError("logs must be a a2pyutils.Logger object")
        if type(removeFile) is not bool:
            raise ValueError("removeFile must be a boolean")
        if type(test) is not bool:
            raise ValueError("test must be a boolean")
        start_time = time.time()
        self.logs = logs
        self.localFiles = tempFolder
        self.bucket = bucketName    
        self.uri = uri
        self.removeFile = removeFile
        self.original = []
        tempfilename = uri.split('/')
        self.filename = tempfilename[len(tempfilename)-1]
        self.seed = "%.16f" % ((sys.maxint*np.random.rand(1)))
        self.localfilename = self.localFiles+self.filename.replace(" ","_")+self.seed
        while os.path.isfile(self.localfilename):
            self.seed = "%.16f" % ((sys.maxint*np.random.rand(1)))
            self.localfilename = self.localFiles+self.filename.replace(" ","_")+self.seed
        if self.logs :
            self.logs.write("Rec.py : init completed:" + str(time.time() - start_time))
            
        if not test:
            start_time = time.time()
            self.process()
            if self.logs :
                self.logs.write("Rec.py : process completed:" + str(time.time() - start_time))
        else:
            self.status = 'TestRun'
        
    def process(self):
        start_time = time.time()
        if not self.getAudioFromUri():
           self.status = 'KeyNotFound'
           return None  
        if self.logs :
            self.logs.write("Rec.py : getAudioFromUri:" + str(time.time() - start_time))
        
        start_time = time.time()
        if not self.readAudioFromFile():
            self.status = 'CorruptedFile'
            return None
        
        if float(self.sample_rate) > 192000.0:
            self.status = 'SamplingRateNotSupported'
            return None
        
        if self.logs :
            self.logs.write("Rec.py : readAudioFromFile:" + str(time.time() - start_time))
        
        if not self.removeFiles():
            if self.logs :
                self.logs.write("Rec.py : removeFiles: warning some files could not be removed")
        
        if self.channs> 1:
            self.status = 'StereoNotSupported'
            return None
        
        if self.samples == 0:
            self.status = 'NoData'
            return None
        
        if self.samples != len(self.original):
            self.status = 'CorruptedFile'
            return None
        
        if float(self.sample_rate) not in analysis_sample_rates:
            self.resample()
          
        self.status = 'HasAudioData'
    
    def resample(self):
        to_sample = self.calc_resample_factor()
        self.original   = resample(self.original, float(to_sample)/float(self.sample_rate) , 'sinc_best')
        self.samples = len(self.original)
        self.sample_rate = to_sample
        
    def calc_resample_factor(self):
        for sr in analysis_sample_rates:
            if self.sample_rate <= sr:
                return sr
    
    def getAudioFromUri(self):
        start_time = time.time()
        f = None
        #if self.logs :
            #self.logs.write('https://s3.amazonaws.com/'+self.bucket+'/'+self.uri+ ' to '+self.localfilename)
        try:
            f = urllib2.urlopen('https://s3.amazonaws.com/'+self.bucket+'/'+quote(self.uri))
            if self.logs :
                self.logs.write('Rec.py : urlopen success')
        except urllib2.HTTPError, e:
            if self.logs :
                self.logs.write("Rec.py : bucket http error:" + str(e.code ))
            return False
        except urllib2.URLError, e:
            if self.logs :
                self.logs.write("Rec.py : bucket url error:" + str(e.reason ))
            return False  
        if f:
            try:
                with open(self.localfilename, "wb") as local_file:
                    local_file.write(f.read())
            except:
                if self.logs :
                    self.logs.write('Rec.py : error f.read')
                return False
        else:
            return False
        
        if self.logs :
            self.logs.write('Rec.py : f.read success')
            self.logs.write("Rec.py : retrieve recording:" + str(time.time() - start_time))
        
        status = 'Downloaded'
        
        return True

    def parseEncoding(self,enc_key):
        enc = 16
        if enc_key in encodings:
            enc = encodings[enc_key]
        return enc
    
    def readAudioFromFile(self):
        try:
            with contextlib.closing(Sndfile(self.localfilename)) as f:
                if self.logs :
                    self.logs.write("Rec.py : sampling rate = {} Hz, length = {} samples, channels = {}".format(f.samplerate, f.nframes, f.channels))
                self.bps = 16 #self.parseEncoding(f.encoding)
                self.channs = f.channels
                self.samples = f.nframes
                self.sample_rate = f.samplerate
                self.original = f.read_frames(f.nframes,dtype=np.dtype('int'+str(self.bps)))
            self.status = 'AudioInBuffer'
            return True
        except:
            if self.logs :
                self.logs.write("Rec.py : error opening : "+self.filename)
            return False

    def removeFiles(self):
        start_time = time.time()
        if '.flac' in self.filename: #if flac convert to wav
            if not self.removeFile:
                try:
                    format = Format('wav')
                    f = Sndfile(self.localfilename+".wav", 'w', format, self.channs, self.sample_rate)
                    f.write_frames(self.original)
                    f.close()
                    os.remove(self.localfilename)
                    self.localfilename = self.localfilename+".wav"
                except:
                    if self.logs :
                        self.logs.write("Rec.py : error creating wav copy : "+self.localfilename) 
                    return False
            
        if self.removeFile:
            if os.path.isfile(self.localfilename):
                os.remove(self.localfilename)
            if self.logs :
                self.logs.write("Rec.py : remove temporary file:" + str(time.time() - start_time))
        
        return True

    def appendToOriginal(self,i):
        self.original.append(i)
        
    def getAudioFrames(self):
        return self.original   
    
    def setLocalFileLocation(self,loc):
        self.localfilename = loc
        
    def getLocalFileLocation(self,ignore_not_exist = False):
        if ignore_not_exist:
            return self.localfilename;
        else:
            if os.path.isfile(self.localfilename):
                return self.localfilename;
            else:
                return None;

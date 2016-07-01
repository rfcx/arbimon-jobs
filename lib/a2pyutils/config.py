#!/usr/bin/env python
import json
import os
import os.path

class AbstractConfig(object):
    def __init__(self):
        self.cache = {}

    def data(self):
        return [
            self.dbConfig['host'],
            self.dbConfig['user'],
            self.dbConfig['password'],
            self.dbConfig['database'],
            self.awsConfig['bucket_name'],
            self.awsConfig['access_key_id'],
            self.awsConfig['secret_access_key']
        ]

    def __getattr__(self, identifier):
        cfg, magic = identifier[:-6], identifier[-6:]
        if cfg and magic == "Config":
            if cfg not in self.cache:
                return self.load(cfg)
            else:
                return self.cache[cfg]

    def load(self, cfg):
        config = {}
        self.cache[cfg] = config
        return config

    

class Config(AbstractConfig):
    scache = {}

    def __init__(self, basepath=None):
        super(Config, self).__init__()

        self.basepath = basepath if basepath else "config"

        self.load('aws')
        self.load('db')
        self.load('path')

    @classmethod
    def for_path(cls, basepath):
        if basepath not in cls.scache:
            cls.scache[basepath] = cls(basepath)
        return cls.scache[basepath]


    def load(self, cfg):
        cfgbasepath = os.path.join(self.basepath, cfg)

        if os.path.isfile(cfgbasepath + '.local.json'):
            cfgpath = cfgbasepath + '.local.json'
        else:
            cfgpath = cfgbasepath + '.json'

        with open(cfgpath) as filedata:
            config = json.load(filedata)

        attr = cfg + "Config"
        self.cache[cfg] = config
        return config


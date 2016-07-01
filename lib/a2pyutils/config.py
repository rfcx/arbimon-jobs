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


class EnvironmentConfig(AbstractConfig):
    scache = {}

    def __init__(self, env=None, env_file=None, sample_file=None):
        super(EnvironmentConfig, self).__init__()
        
        if not env:
            env = os.environ
            
        self.env_file = env_file if env_file else 'config/config.env'
        self.sample_file = sample_file if sample_file else 'config/config.env.sample'
        
        self.read_env_file(env)
        self.check_against_sample_file(env)
        self.parse_env(env)
        
    def read_env_file(self, env, env_file=None):
        env_file = env_file if env_file else self.env_file
        if env_file:
            with open(env_file) as finp:
                for line in (x.strip() for x in finp):
                    if not line or line[0] == '#':
                        continue
                    attr, val = line.split("=", 1)
                    if attr not in env:
                        if val and val[0]+val[-1] in ('""', "''"):
                            val = val[1:-1]
                        env[attr] = val
        return env
        
    def check_against_sample_file(self, env):
        if self.sample_file:
            sample_env = self.read_env_file({}, self.sample_file)
            missing = [attr for attr in sample_env.keys() if attr not in env]
            
            if missing:
                raise StandardError("Environment variables missing: " + ", ".join(missing))
        
        
    def parse_env(self, env):
        for attr, val in env.items():
            comps = attr.lower().split('__')
            attr = comps.pop()
            
            node = self.cache
            while comps:
                comp = comps.pop(0)
                if comp not in node:
                    node[comp] = {}
                node = node[comp]
            node[attr] = val

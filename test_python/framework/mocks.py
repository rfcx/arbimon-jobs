import StringIO
import a2pyutils.storage

class CallTracer:
    "Traces calls"
    def __init__(self):
        self.clear()
        
    def trace(self, *args):
        "appends a trace"
        self.traced.append(args)

    def trace_fn(self, fn, name=None):
        "decorates a function to trace each call to it"
        if not name:
            name = fn.__name__
        def fnspy(tobj, *args, **kwargs):
            self.trace(name, args, kwargs)
            return fn(tobj, *args, **kwargs)
        return fnspy

    def clear(self):
        "Clears current trace log"
        self.traced = []

class Mock_BotoBucketStorage(a2pyutils.storage.AbstractStorage):
    calls = CallTracer()

    @calls.trace_fn
    def __init__(self, *args, **kwdargs):
        self.filelist = None
        pass
        
    @calls.trace_fn
    def get_file_uri(self, file):
        return "file_uri://" + file
        
    @calls.trace_fn
    def get_file(self, file):
        entry = self.filelist[file] if self.filelist and file in self.filelist else {'data':'file_data'}
        if not entry.get('exists', True):
            entry = None
        if entry is None:
            entry = {'data':'file_data'}
        if 'file' in entry:
            return open(entry['file'], 'r'+entry.get('mode', 'b'))
        elif 'raise' in entry and entry['raise']:
            raise a2pyutils.storage.StorageError(entry['raise'])
        else:
            return StringIO.StringIO(entry.get('data', "file_data"))

    @calls.trace_fn
    def put_file(self, file, filedata, acl=None):
        entry = self.filelist[file] if self.filelist and file in self.filelist else None
        if entry and 'raise' in entry:
            raise a2pyutils.storage.StorageError(entry['raise'])

    @calls.trace_fn
    def put_file_fd(self, img_uri, img_file, acl=None):
        entry = self.filelist[file] if self.filelist and file in self.filelist else None
        if entry and 'raise' in entry:
            raise a2pyutils.storage.StorageError(entry['raise'])

    @calls.trace_fn
    def put_file_path(self, img_uri, img_file, acl=None):
        entry = self.filelist[file] if self.filelist and file in self.filelist else None
        if entry and 'raise' in entry:
            raise a2pyutils.storage.StorageError(entry['raise'])
        
    def set_file_list(self, filelist):
        self.filelist = filelist

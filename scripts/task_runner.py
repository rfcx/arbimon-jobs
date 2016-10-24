#! .env/bin/python

"""
task_runner.py
Server for running job tasks.
"""

import json
import bottle
import subprocess

MAX_CONCURRENCY = 4
PORT = 8760
HOST = 'localhost'

def provides_route(path, method='GET'):
    "Annotates a decorated member function as providing a given route"
    def decorate(fn):
        if not hasattr(fn, "provides_route"):
            fn.provides_route = []
        fn.provides_route.append({'path':path, 'method':method})
        return fn
    return decorate

def register_provided_routes(fn):
    "Registers annotated member functions as routes for the decorated bottle app"
    def proxy(self, *args, **kwargs):
        provided_routes = [
            getattr(self, _)
            for _ in dir(self)
            if hasattr(self, _) and hasattr(getattr(self, _), 'provides_route')
        ]
        fn(self, *args, **kwargs)
        for item in provided_routes:
            for route_privided in item.provides_route:
                method = route_privided.get('method', 'route').lower()
                getattr(self, method)(route_privided['path'])(item)


    return proxy

class TaskRunnerBottle(bottle.Bottle):
    @register_provided_routes
    def __init__(self, max_concurrency):
        super(TaskRunnerBottle, self).__init__()
        self.max_concurrency = max_concurrency
        self.tasks = []
        self.reporter_uri = None

    @provides_route('/health')
    def health(self):
        "returns health check"
        bottle.response.content_type = 'application/json'
        return json.dumps({"status": "ok"})

    @provides_route('/status')
    def status(self):
        "returns status report"
        bottle.response.content_type = 'application/json'
        return json.dumps({
            "status": "ok",
            "reporter": self.reporter_uri,
            "tasks": [t for t in self.tasks]
        })

    @provides_route('/task/<task:int>', 'POST')
    @provides_route('/task/<task:int>/<step:int>', 'POST')
    def run_task(self, task, step=None):
        "runs a task"
        bottle.response.content_type = 'application/json'
        return json.dumps({
            "task": task,
            "step": step
        })



if __name__ == '__main__':
    tbr = TaskRunnerBottle(MAX_CONCURRENCY)
    bottle.run(app=tbr, host=HOST, port=PORT)

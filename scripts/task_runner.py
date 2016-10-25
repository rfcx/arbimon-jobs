#! .env/bin/python

"""
task_runner.py
Server for running job tasks.
"""

import json
import subprocess
import bottle
import a2.job.taskrunner
import a2pyutils.config

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
        self.task_runner = a2.job.taskrunner.TaskRunner(
            a2pyutils.config.EnvironmentConfig(),
            max_concurrency
        )

    @provides_route('/health')
    def health(self):
        "returns health check"
        return {"status": "ok"}

    @provides_route('/status')
    def status(self):
        "returns status report"
        return {
            "status": "ok",
            "reporter": self.task_runner.reporter_uri,
            "tasks": [t for t in self.task_runner.tasks]
        }

    @provides_route('/task/<task:int>', 'POST')
    @provides_route('/task/<task:int>/<step:int>', 'POST')
    def run_task(self, task, step=None):
        "runs a task"
        try:
            return self.task_runner.run(task, step)
        except a2.job.taskrunner.AtMaximumConcurrencyError:
            raise bottle.HTTPError(429, 'At Maximum Concurrency')

    def default_error_handler(self, res):
        bottle.response.content_type = 'application/json'
        return json.dumps(dict(message=res.body, status="error"))

if __name__ == '__main__':
    tbr = TaskRunnerBottle(MAX_CONCURRENCY)
    bottle.run(app=tbr, host=HOST, port=PORT)

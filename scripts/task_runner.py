#! .env/bin/python

"""
task_runner.py
Server for running job tasks.
"""

import json
import traceback
import sys
import os.path
import time
import ws4py.client.threadedclient
import jwt
import a2.job.taskrunner
import a2.runtime.inject
import a2pyutils.config

class TaskRunnerWebSocketClient(ws4py.client.threadedclient.WebSocketClient):
    """Web socket client exposing a TaskRunner instance."""
    
    def __init__(self, config, runner_script):
        endpoint = config.hostsConfig['jobqueue']
        max_concurrency = config.tasksConfig['max_concurrency']
        print endpoint
        super(TaskRunnerWebSocketClient, self).__init__(
            endpoint, 
            protocols=['http-only', 'chat']
        )
        self.id = None
        self.config = config
        self.authenticated = False
        self.task_runner = a2.job.taskrunner.TaskRunner(
            config,
            max_concurrency,
            runner_script
        )

    def closed(self, code, reason=None):
        print "Closed down", code, reason
        
    def send_data(self, topic, data):
        self.send(json.dumps({
            'topic': topic,
            'data': data
        }))

    def received_message(self, m):
        try:
            msg = json.loads(str(m))
            topic, data = msg['topic'], msg['data']
        except StandardError:
            print traceback.print_exc()
        
        try:
            getattr(self, 'recieved_message_' + topic)(data)
        except StandardError, e:
            exc = traceback.format_exc()
            self.send_data('error', {
                'error': e.__class__.__name__,
                'traceback': exc,
                'topic': topic,
                'data': data
            })
        
            
    def recieved_message_auth(self, data):
        if data.get('action') == 'perform_auth':
            if 'result' in data:
                if data['result'] == 'confirmed':
                    # auth passed :-), now wait for work
                    self.authenticated = True
                    self.id = data.get('id')
                    print "Authentication passed. Task runner #{}. Now awiting for a job...".format(
                        self.id
                    )
                elif data['result'] == 'invalid':
                    # auth failed, we should just quit
                    print "Authentication with job queue failed. Exiting..."
                    self.close()
            else:
                payload = json.loads(self.config.hostsConfig['auth_options'])
                payload['time'] = time.time()
                token = jwt.encode(
                    payload,
                    self.config.hostsConfig['auth_secret']
                )
                self.send_data('auth', {
                    'password': token,
                    'cores': self.task_runner.max_concurrency
                })

    def recieved_message_error(self, data):
        print "recieved error:: ", data

    def recieved_message_run_task(self, data):
        print "runnning task...", data

        def resolve(arg):
            self.send_data('running_task', {
                'action':'finished',
                'data': arg
            })
            
        self.task_runner.run(data.get('task'), resolve)

if __name__ == '__main__':
    try:
        ws = TaskRunnerWebSocketClient(
            a2pyutils.config.EnvironmentConfig(), [
                sys.executable, 
                os.path.join(os.path.dirname(__file__), "./run_task.py")
            ]
        )
        ws.connect()
        ws.run_forever()
    except KeyboardInterrupt:
        ws.close()
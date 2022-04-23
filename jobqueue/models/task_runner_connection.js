
var q = require('q');
var counter=0;

var TaskRunnerConnection = function(ws, app){
    this.id = ++counter;
    this.ws  = ws;
    this.app = app;
    this.dispatcher = app.taskDispatcher;
    this.auth = null;
    this.tries = 0;

    console.log("Task Runner #" + this.id + " connected on websocket");
    ws.on('message', this.on_message.bind(this));
    ws.on('close', this.on_close.bind(this));
    
    this.send('auth', {action:'perform_auth'});

};

TaskRunnerConnection.prototype = {
    runTask: function(taskId){
        if(this.used < this.cores){
            console.log("Running task " + taskId + " on task runner #" + this.id + ".")
            this.send('run_task', {task:taskId});
            this.setUsedCores(this.used + 1);
        } else {
            throw new Error("All cores used. Cannot run task " + taskId);
        }
    },
    
    send: function(topic, data){
        data = data || {};
        try{
            this.ws.send(JSON.stringify({
                topic:topic, data:data
            }));
        } catch(e){
            this.on_error(e, "while sending message.");
        }
    },
    on_message: function(text){
        var message;
        try{
            message = JSON.parse(text);
            var message_fn = 'on_message_' + (this.auth ? 'auth_' : '') + 'topic_' + message.topic;
            if(this[message_fn]){
                return q.resolve().then( 
                        () => this[message_fn](message.data) 
                    ).catch(
                        e => this.on_error(e, "while processing message.")
                    );
            } else {
                console.log("Invalid topic " + message.topic);
                this.send('error', 'Invalid topic: ' + message.topic);
            }
        } catch(e){
            this.on_error(e, "while reading message.");
        }
    },
    
    setUsedCores: function(used){
        this.used  = used || 0;
        this.unused = this.cores - this.used;
        console.log("Task runner #" + this.id + " cores:" + this.cores + "(used:" + this.used + " / unused:" + this.unused + ")")
    },
    
    on_message_topic_auth: function(data){
        return this.app.verifyAuth(data).then((passed) => {
            if(passed){
                this.auth = true;
                this.cores = data.cores;
                this.setUsedCores(data.used);
                
                this.dispatcher.addTaskRunner(this);
                this.send('auth', {action:'perform_auth', result:'confirmed', id:this.id});
            } else {
                this.send('auth', {action:'perform_auth', result:'invalid'});
                this.ws.close();
            }
        });
    },
    
    on_message_auth_topic_running_task: function(data){
        console.log("Running task message:: " + data.action + ".")
        this.setUsedCores(data.used);
        if(data.action == 'finished'){
            this.dispatcher.notifyCoresAvailable();
        }
        return q.resolve();
    },
    
    on_message_auth_topic_error: function(data){
        console.error("Task Runner #" + this.id + " error ");
        console.error(data.error);
        console.error(data.traceback);

        if(data.error == 'AtMaximumConcurrencyError' && data.topic == 'run_task'){
            this.dispatcher.notifyTaskNotRun(data.data.task);
        }
            
    },
        
    on_error: function(e, when){
        console.error("Task Runner #" + this.id + " error ", when);
        console.error(e);
    },
    
    on_close: function(){
        console.log("closed websocket for Task Runner #" + this.id + ".");
        return this.dispatcher.removeTaskRunner(this);
    }
};

module.exports = TaskRunnerConnection;
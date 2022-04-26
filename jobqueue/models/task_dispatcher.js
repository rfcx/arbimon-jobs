var models = require('./index');
var dbpool = require('../utils/dbpool');
var promiseUtil = require('../utils/promise-util');
var debug = require('debug')('arbimon2:task:dispatcher');
var counter=0;

var TaskDispatcher = function(app, options){
    this.app = app;
    this.options = options;
    this.taskRunners = [];
};

TaskDispatcher.prototype = {
    /** Adds a task runner instance to this dispatcher.
     *  @param {Object} taskRunner - task runner instance.
     */
    addTaskRunner : function(taskRunner){
        var index = this.taskRunners.indexOf(taskRunner);
        if(index == -1){
            console.log("Adding new task runner #", taskRunner.id, " with " + taskRunner.cores + " cores.");
            this.taskRunners.push(taskRunner);
            this.notifyCoresAvailable();
        } else {
            console.warn("Trying to re-add task runner #" + this.id + ".");
        }
    },
    /** Removes a task runner instance to this dispatcher.
     *  @param {Object} taskRunner - task runner instance.
     */
    removeTaskRunner : function(taskRunner){
        var index = this.taskRunners.indexOf(taskRunner);
        if(index != -1){
            console.log("Removing task runner #", taskRunner.id, ".");
            this.taskRunners.splice(index, 1);
        }
    },
    /** Returns the status of this task dispatcher.
     *  @return {Object}  the status of this task runner.
     */
    getStatus: function(){
        return this.taskRunners.reduce(function(_, taskRunner){
            _.cores  = taskRunner.cores;
            _.used   = taskRunner.used;
            _.unused = taskRunner.unused;
            return _;
        }, {
            count  : this.taskRunners.length,
            cores  : 0,
            used   : 0,
            unused : 0,
        });
    },
    
    /** Runs the main job queue loop.
    * @return {Promise}  resolved when out of the loop (maybe because of an error).
    */
    runMainLoop: function(){
        if(this.loopPromise){
            return this.loopPromise;
        }
        
        var loop_while_more_jobs = this.options.loop_while_more_jobs;
        var loop_delay           = this.options.loop_delay;
        var rerun_interval       = this.options.rerun_interval;
        var delay, keepLooping = true;
        
        debug("  Running main loop.");
        debug("  options : " + JSON.stringify(this.options));
        this.state = 'running-loop';
        this.iteration = 0;
        this.running_loop = true;
        this.loopPromise = promiseUtil.whileLoop(() => keepLooping, () => {
            this.mainLoopTimer = promiseUtil.timeout();
            return this.loopOnce().catch((err) => {
                console.error(err);
            }).then((results) => {
                if(loop_while_more_jobs && results && results.run){
                    debug("  Ran %s more tasks. Looping in %s ms", results.run, loop_delay);
                    delay = loop_delay;
                } else if(rerun_interval){
                    debug("  Suspending task loop for : %s ms", rerun_interval);
                    delay = rerun_interval;
                } else {
                    debug("  Suspending task loop.");
                    delay = undefined;
                    keepLooping = false;
                }
                this.state = 'sleeping';                
                return this.mainLoopTimer.resolveDelayed(delay);
            });
        }).then(() => {
            this.running_loop = false;
        });
        
        return this.loopPromise;
    },

    /** Runs the main task dispatch loop for one iteration.
     * @private
     * @return {Promise} resolving after one iteration of the task dispatch loop.
     */
    loopOnce : function(){
        // bump the iteration counter
        ++this.iteration;
        // iterate
        this.last_updated = new Date();
        debug("Queue Loop Iteration #%s.", this.iteration);
        var jtimeout = this.options.job_inactivity_timeout;
        var rtimeout = this.options.job_requeue_delay;
        return models.Tasks.tagStalledTasks(jtimeout).then(
            () => models.Tasks.requeueStalledTasks(rtimeout)
        ).then(
            () => this.runTasks()
        );
    },
    
    runTasks: function(){
        var unused = this.taskRunners.reduce( 
            ((_, taskRunner) => _ + taskRunner.unused), 
            0
        );
        var tasksRun = 0;

        return models.Tasks.getFor({
            status:'waiting', 
            dependency_count: 0,
            random:true, 
            limit:unused
        }).then((tasks) => {
            return promiseUtil.whileLoop(
                (() => tasks.length), 
                (() => this.runTask(tasks.shift()).then(
                    () => ++tasksRun
                ))
            );
        }).then( () => ({
            run: tasksRun
        }));
    },
    
    getAvailableTaskRunner: function(){
        for(var i=0, l=this.taskRunners, e=l.length; i < e ; ++i){
            if(l[i].unused > 0){
                return l[i];
            }
        }
    },
    
    runTask: function(task){
        var taskRunner = this.getAvailableTaskRunner();
        if(taskRunner){
            debug("Running task %s.", task.task_id);
            return models.Tasks.updateTaskStatus(task.task_id, models.Tasks.status.assigned).then(function(){
                return taskRunner.runTask(task.task_id);
            });
        }
    },
    
    notifyCoresAvailable: function(){
        if(this.mainLoopTimer){
            // short circuit the wait timer
            this.mainLoopTimer.resolveNow();
        }
    },
    
    notifyTaskNotRun: function(task_id){
        return models.Tasks.updateTaskStatus(task_id, models.Tasks.status.waiting);
    },
};

module.exports = TaskDispatcher;
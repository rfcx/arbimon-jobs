var dbpool = require('../utils/dbpool');

var Tasks = {
    /** Set of states the task status can be in. */
    status: {
        waiting    : 'waiting'   ,
        assigned   : 'assigned'  ,
        processing : 'processing',
        stalled    : 'stalled'   ,
        completed  : 'completed' ,
        error      : 'error'     ,
    },
    
    /** Fetches a list of tasks.
     *  @params {Object} options - options object.
     *  @params {String|Array} options.status - filter by status
     *  @params {Boolean} options.count - fetch result count instead of task list
     *  @params {Number} options.limit - limit results to 
     *  @params {Boolean} options.random - randomize result order
     */
    getFor: function(options){
        var projection=[];
        var clauses=[], data=[];
        var order='', limit='';
        
        if(options.count){
            projection.push('COUNT(*) as count');
        } else {
            projection.push('T.task_id');
        }
        
        if(options.status){
            clauses.push((options.status instanceof Array) ? 'T.status IN (?)' : 'T.status = ?');
            data.push(options.status);
        }
        
        if('dependency_count' in options){
            var op = options.dependency_op || '=';
            clauses.push('T.dependency_counter ' + op + ' ?');
            data.push(options.dependency_count);
        }

        if(options.random){
            order = 'RAND()';
        }
        
        if('limit' in options){
            limit = '?';
            data.push(options.limit);
        }
        
        return dbpool.query(
            "SELECT " + projection.join(", ") + "\n" + 
            "FROM job_tasks T\n" +
            (clauses.length ? "WHERE (" + clauses.join(") AND (") + ")\n" :"") +
            (order ? "ORDER BY " + order + "\n" : "") +
            (limit ? "LIMIT " + limit + "\n" : ""),
            data
        );
    },
    
    /** Update a task's status.
     *  @param {Number} taskId - task id.
     *  @param {String} status - status to set.
     *  @return {Promise} resolved after the task's status is set.
     */
    updateTaskStatus: function(taskId, status){
        return dbpool.query(
            "UPDATE `job_tasks` T \n" +
            "SET T.status = ?, T.timestamp = NOW() \n" +
            "WHERE T.task_id = ?", [
                status, taskId
            ]
        );
    },
    /** Tag processing or assigned tasks that have timed out as stalled.
     *  @param  {Number} timeout - interval before a job is considered stalled.
     *  @return {Promise} resolved after the stalled tasks have been tagged.
     */
    tagStalledTasks: function (timeout){
        return dbpool.query(
            "UPDATE `job_tasks` T \n" +
            "SET T.status = 'stalled', T.timestamp = NOW() \n" +
            "WHERE (T.status='processing' OR T.status='assigned') \n"+
            "  AND T.timestamp < DATE_SUB(NOW(), INTERVAL "+(timeout/1000.0)+" SECOND)" 
        );
    },
    /** Re-queue stalled tasks.
     *  @param  {Number} timeout - interval before a stalled job is to be requeued.
     *  @return {Promise} resolved after the stalled tasks have been re-queued.
     */
    requeueStalledTasks: function (timeout){
        return dbpool.query(
            "UPDATE `job_tasks` T \n" +
            "SET T.status = 'waiting', T.timestamp = NOW() \n" +
            "WHERE T.status='stalled'\n"+
            "  AND T.timestamp < DATE_SUB(NOW(), INTERVAL "+(timeout/1000.0)+" SECOND)" 
        );
    }
}

module.exports = Tasks;
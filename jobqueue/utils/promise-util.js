var q = require('q');

module.exports = {
    whileLoop: function(condition, loopFunction, value){
        return q.Promise((resolve, reject) => {
            var loop = q.resolve();
            function iterate(){
                return q.resolve(value).then(condition).catch(reject).then(result => {
                    if(result){
                        return q.resolve(value).then(
                            loopFunction
                        ).catch(reject).then(
                            new_value => value = new_value
                        ).then(() => {
                            loop = loop.then(iterate)
                        });
                    } else {
                        resolve(value);
                    }
                })
            }
            
            loop = loop.then(iterate);
        });
    },
    
    /** Returns a promise that gets resolve after a given delay.
     *  @param {Number} delay - milliseconds after wich the promise will be resolved.
     *  @param {Object} resolveValue - value to resolve the promise to.
     *  @return {Promise} resolved after a given delay, and with two defined methods:
     *          cancel() - cancels the timeout
     *          resolveNow() - resolves the promise immediately, instead of awaiting the delay.
     */
    timeout: function(delay, resolveValue){
        var handle;
        var resolve, reject;
        
        var p = q.Promise((_resolve, _reject) => {
            resolve = _resolve;
            reject = _reject;
        });
        
        p.resolveDelayed = function(_delay, _resolveValue){
            handle = setTimeout(function(){
                resolve(_resolveValue);
            }, _delay);
            return p;
        };
        
        p.cancel = function(){
            if(handle){
                clearTimeout(handle);
                handle = null;
            }
            reject(new Error("Timeout canceled"));
            return p;
        };
        
        p.resolveNow = function(){
            if(handle){
                clearTimeout(handle);
                handle = null;
            }
            resolve(resolveValue);
            return p;
        }
        
        if(delay !== undefined){
            p.resolveDelayed(delay, resolveValue);
        }
        
        return p;
    }
};
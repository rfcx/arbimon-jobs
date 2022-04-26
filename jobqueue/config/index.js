/* jshint node:true */
'use strict';

var path = require('path');

require('dotenv-safe').load({
    silent: true,
    path: path.join(__dirname, 'config.env'),
    sample: path.join(__dirname, 'config.env.sample'),
});

// cache
var cache = {};

module.exports = function(config_file){
    if(!cache[config_file]){
        cache[config_file] = Object.keys(process.env).reduce(function(_, key){
            var key_comps = key.split('__').map(function(_){
                return _.toLowerCase();
            });
            
            if(key_comps.shift() == config_file){
                var attr = key_comps.pop();
                var node = _;
                while(key_comps.length){
                    var comp = key_comps.shift().toLowerCase();
                    if(!node[comp]){
                        node[comp] = {};
                    }
                    node = node[comp];
                }
                node[attr] = process.env[key];
            }
            
            return _;
        }, {});
    }
    
    return cache[config_file];
};

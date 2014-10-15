angular.module('a2services',[])
.factory('Project', ['$location', '$http', function($location, $http) {
    var urlparse = document.createElement('a');
    urlparse.href = $location.absUrl();
    var nameRe = /\/project\/([\w\_\-]+)/;

    var url = nameRe.exec(urlparse.pathname)[1];

    return {
        getInfo: function(callback) {
            $http.get('/api/project/'+url+'/info')
            .success(function(data) {
                callback(data);
            });
        },

        getSites: function(callback) {
            $http.get('/api/project/'+url+'/sites')
            .success(function(data) {
                callback(data);
            });
        },

        getSpecies: function(callback) {
            $http.get('/api/project/'+url+'/species')
            .success(function(data) {

            });
        },

        getClasses: function(callback) {
            $http.get('/api/project/'+url+'/classes')
            .success(function(data) {
                callback(data);
            });
        },

        getRecs: function(query, callback) {
            if(typeof query === "function") {
                callback = query;
                query = "";
            }

            $http.get('/api/project/'+url+'/recordings/'+query)
            .success(function(data) {
                callback(data);
            });
        },

        getRecTotalQty: function(callback) {
            $http.get('/api/project/'+url+'/recordings/count/')
            .success(function(data) {
                callback(data[0].count);
            });
        },

        getName: function(){
            var urlparse = document.createElement('a');
            urlparse.href = $location.absUrl();
            var nameRe = /\/project\/([\w\_\-]+)/;

            return nameRe.exec(urlparse.pathname)[1];
        },
        getRecordings: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/'+key).success(function(data) {
                callback(data);
            });
        },
        getOneRecording: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/find/'+key).success(function(data) {
                callback(data);
            });
        },
        getRecordingAvailability: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/available/'+key).success(function(data) {
                callback(data);
            });
        },
        getRecordingInfo: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/info/'+key).success(function(data) {
                callback(data);
            });
        },
        getNextRecording: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/next/'+key).success(function(data) {
                callback(data);
            });
        },
        getPreviousRecording: function(key, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/recordings/previous/'+key).success(function(data) {
                callback(data);
            });
        },
        validateRecording: function(recording_uri, validation, callback){
            var projectName = this.getName();
            $http.post('/api/project/'+projectName+'/recordings/validate/'+recording_uri, validation).success(function(data) {
                callback(data);
            });
        },

        getTrainingSets: function(callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/training-sets/').success(function(data) {
                callback(data);
            });
        },

        addTrainingSet: function(tset_data, callback) {
            var projectName = this.getName();
            $http.post('/api/project/'+projectName+'/training-sets/add', tset_data).success(function(data) {
                callback(data);
            });
        },

        getTrainingSetDatas: function(training_set, recording_uri, callback) {
            var projectName = this.getName();
            $http.get('/api/project/'+projectName+'/training-sets/list/'+training_set+'/'+recording_uri).success(function(data) {
                callback(data);
            });
        },

        recExists: function(site_id, filename, callback) {
            $http.get('/api/project/'+url+'/recordings/exists/site/'+ site_id +'/file/' + filename)
            .success(function(data) {
                callback(data.exists);
            });
        }
    };
}])

.factory('Species',['$http', function($http){
    var species;

    return {
        get: function(callback) {
            if(species)
                callback(species);

            $http.get('/api/species/list/100')
            .success(function(data) {
                species = data;
                callback(species);
            });
        }
    };
}])

.factory('Songtypes',['$http', function($http){
    var songs;

    return {
        get: function(callback) {
            if(songs)
                return callback(songs);

            $http.get('/api/songtypes/all')
            .success(function(data) {
                songs = data;
                callback(songs);
            });
        }
    };
}])

;

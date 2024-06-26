var config = require('./config');
var app = new (require('./jobqueue-app'))();
var debug = require('debug')('arbimon2:jobqueue');

app.server.set('port', config('job_queue').port || 3007);

var server = app.server.listen(app.server.get('port'), function() {
    debug('Express server listening on port ' + server.address().port);
});

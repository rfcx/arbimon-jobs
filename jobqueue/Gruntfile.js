
module.exports = function(grunt) {
    var initcfg = {
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            jobqueue: {
                files: [
                    'jobqueue-app.js',
                    'models/job_queues.js',
                    'utils/**/*.js',
                    'config/**/*.js',
                    'config/**/*.json'
                ],
                tasks: ['express:jobqueue'],
                options: {
                    spawn: false // for grunt-contrib-watch v0.5.0+
                }
            },
        },
        express: {
            jobqueue: {
                options: {
                    script: 'main'
                }
            }
        },
        clean: {
            packages: ['node_modules']
        }
    };
    
    
    grunt.initConfig(initcfg);

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-express-server');
    grunt.loadNpmTasks('grunt-contrib-clean');

    grunt.registerTask('default', []);
    grunt.registerTask('server', ['express:jobqueue', 'watch:jobqueue']);
};

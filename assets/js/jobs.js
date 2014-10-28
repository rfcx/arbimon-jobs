
(function(angular)
{ 
    var jobs = angular.module('jobs',['a2services']);
    
    jobs.service('JobsData',
        function ($http, $interval,Project)
        {
            var jobslength = 0;
            var jobs;
            var url;
            var intervalPromise;
            var p = Project.getInfo(
            function(data)
            {
                url = data.url;
                $http.get('/api/project/'+url+'/progress')
                .success
                (
                    function(data) 
                    {
                        jobs = data;
                        jobslength = jobs.length;
                     }
                );
            });
            
        return {
                geturl : function(){
                    return url;  
                },
                getjobLength: function() {
                    return jobslength;
                },
                getJobs: function() {
                    return jobs;
                },
                updateJobs: function() {
                    $http.get('/api/project/'+url+'/progress')
                    .success
                    (
                        function(data) 
                        {
                            jobs = data;
                            jobslength = jobs.length;
                         }
                    );
                },
                startTimer : function(){
                    $interval.cancel(intervalPromise);
                    if (typeof jobs != 'undefined' && jobs.length>0) {
                        intervalPromise = 
                        $interval(function(){
                            var cancelInterval = true;
                            for(var i =0;i < jobs.length ; i++)
                            {
                                if (jobs[i].percentage < 100)
                                {
                                    cancelInterval = false;
                                    break;
                                }
                            }
                            if (cancelInterval) {
                                $interval.cancel(intervalPromise);
                            }
                            else if ( jobs.length < 1) {
                                $interval.cancel(intervalPromise);
                            }else
                                $http.get('/api/project/'+url+'/progress')
                                .success
                                (
                                    function(data) 
                                    {
                                        jobs = data;
                                        jobslength = jobs.length;
                                     }
                                );
                        },1000);
                    }
                    
                },
                cancelTimer : function(){
                    $interval.cancel(intervalPromise);                   
                }
            }
                
        }
    );
    
    jobs.controller('StatusBarNavIndexController',
        function ($scope, $http, $timeout,JobsData)          
        {
            $scope.$watch
            (
             function(){
                return JobsData.getjobLength();
                }
                ,
                function()
                {
                    $scope.jobslength  = JobsData.getjobLength();
                    
                }
            );
        }         
    );
    

   jobs.controller
    ('UnfinishedJobInstanceCtrl', 
        function ($scope, $modalInstance) 
        {

            $scope.ok = function () {
                $modalInstance.close( {"ok":"delete"}  );
            };

            $scope.cancel = function () {
                 $modalInstance.dismiss('cancel');
            };

        }
    ) ;
    
    jobs.controller('StatusBarNavController',
        function ($scope, $http,$modal,$interval, Project,JobsData)
        {
            $scope.showClassifications = true;
            $scope.showTrainings = true;
            $scope.url = '';
            $scope.successInfo = "";
            $scope.showSuccesss = false;
            $scope.errorInfo = "";
            $scope.showErrors = false;
            $scope.jobs = [];
            $scope.$watch
            (
             function(){
                return JobsData.getJobs();
                }
                ,
                function()
                {
                    $scope.jobs = JobsData.getJobs();
                    JobsData.startTimer();
                }
            );
            
            $scope.$on('$destroy', function () { JobsData.cancelTimer() });
            
            $scope.hideJob =
            function(jobId)
            {
                var continueFalg = true;
                for(var i =0;i < $scope.jobs.length ; i++)
                {
                    if ($scope.jobs[i].job_id == jobId) 
                    {
                        if ($scope.jobs[i].percentage < 100)
                        {
                            continueFalg = false;
                            var modalInstance = $modal.open
                            (
                                {
                                    template: '<div class="modal-header">'  +
                                                    '<h3 class="modal-title">Hide running job</h3> '+ 
                                                '</div>  '+
                                                '<div class="modal-body"> '+
                                                'Job has not finished. Hide anyway?'+
                                                '</div>  '+
                                                '<div class="modal-footer">  '+
                                                    '<button class="btn btn-primary" ng-click="ok()">Submit</button>  '+
                                                    '<button class="btn btn-warning" ng-click="cancel()">Cancel</button>  '+
                                                '</div>  ',
                                    controller: 'UnfinishedJobInstanceCtrl',
                                }
                            );
                            
                            modalInstance.result.then
                            (
                                function (data) 
                                {
                                    if(data.ok)
                                    {
                                        $http.get('/api/project/'+JobsData.geturl()+'/job/hide/'+jobId)
                                        .success
                                        (
                                            function(data) 
                                            {
                                                if (data.err)
                                                {
                                                    console.log(data.err)
                                               }
                                                else
                                                {
                                                    JobsData.updateJobs();
                                                    $scope.successInfo = "Job Hidden Successfully";
                                                    $scope.showSuccesss = true;
                                                    $scope.showClassifications = true;
                                                    $scope.showTrainings = true;
                                                    $("#successDivs").fadeTo(3000, 500).slideUp(500,
                                                   function()
                                                    {
                                                        $scope.showSuccesss = false;
                                                    });
                                                }
                                             }
                                        );
                                    }
                                }
                            );                            
                        }
                    }
                }
                
                if (continueFalg)
                {
                    $http.get('/api/project/'+JobsData.geturl()+'/job/hide/'+jobId)
                    .success
                    (
                        function(data) 
                        {
                            if (data.err)
                            {
                                console.log(data.err)
                           }
                            else
                            {
                                JobsData.updateJobs();
                                $scope.successInfo = "Job Hidden Successfully";
                                $scope.showSuccesss = true;
                                $scope.showClassifications = true;
                                $scope.showTrainings = true;
                                $("#successDivs").fadeTo(3000, 500).slideUp(500,
                               function()
                                {
                                    $scope.showSuccesss = false;
                                });
                            }
                         }
                    );
                }
            };
            
            $scope.$watch('showTrainings ',
                function()
                {
                    if ($scope.showTrainings )
                    {
                        $('.jobtype1').show();
                    }
                    else
                    {
                        $('.jobtype1').hide();
                        if (!$scope.showClassifications )
                        {
                           $('.jobtype2').show();
                           $scope.showClassifications = true;
                        }
                    }
                }
            );
                        
            $scope.$watch('showClassifications',
                function()
                {
                    if ($scope.showClassifications)
                    {
                        $('.jobtype2').show();
                    }
                    else
                    {
                        $('.jobtype2').hide();
                        if (!$scope.showTrainings )
                        {
                           $('.jobtype1').show();
                           $scope.showTrainings = true;
                        }
                    }
                }
            );
        }
    );   
}
)(angular);

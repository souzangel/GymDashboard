var app = angular.module('myApp', []);

app.controller('myCtrl', function($scope, $http, $location) {
        
    $scope.user = new user();

    $scope.submitLogin = function() {        
        // change page
        window.location.assign('/home.html');
        
        // var url = 'http://localhost:3001/login';
        // $http.get(url)
        // .then(function(response) {            
        //     if (response){
                
        //     }            
        // });
    }
});

// User Constructor
function user() {
    this.username = '';
    this.password = '';
}
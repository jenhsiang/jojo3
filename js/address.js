var app = angular.module('app', []);

app.controller('mainCrtl', function ($scope , $http , $filter) {
    //$scope.add_city = $scope.townName[0].city;
	
   /* $scope.$watch('add_city', function() {
        $scope.setTownName = $filter('filter')( $scope.townName , { city : $scope.add_city } );
        $scope.add_town = $scope.setTownName[0]; 
    });*/
	 $scope.getcitytown = function() {
        $scope.setTownName = $filter('filter')( $scope.townName , { city : $scope.add_city } );
        $scope.add_town = $scope.setTownName[0]; 
    }
	 $scope.setcity = function(r,s) {
			 $http.get("/json/search_city.jsp").then(function(a){
					$scope.cityName = a.data;
					$scope.add_city = r;
				});	 
			 $http.get("/json/search_town.jsp").then(function(a){
					$scope.townName = a.data;
					$scope.setTownName = $filter('filter')( $scope.townName , { city : $scope.add_city } );
					$scope.setTown = $filter('filter')( $scope.setTownName , { town : s } );
					$scope.add_town = $scope.setTown[0];
				});	 
		}; 
	
});
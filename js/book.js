var app = angular.module('app', []);

app.controller('mainCrtl', function ($scope , $http , $filter ) {

	$scope.stocks = [];
	$scope.firstName = [
                { search_type :"類別" },
                { search_type :"推薦" },
                ];
   /* $scope.$watch('add_city', function() {
        $scope.setTownName = $filter('filter')( $scope.townName , { city : $scope.add_city } );
        $scope.add_town = $scope.setTownName[0]; 
    });*/
		 $scope.getFirst = function() {
        $scope.setSecondName = $filter('filter')( $scope.secondName , { search_type : $scope.add_first } );
        $scope.add_second = $scope.setSecondName[0]; 
    }
	 $scope.setFirst =  function(r,s) {
			 $scope.add_first = r;
			 $http.get("/json/search_book.jsp").then(function(a){
					$scope.secondName = a.data;
					 $scope.setSecondName = $filter('filter')( $scope.secondName , { search_type : $scope.add_first } );
					 $scope.add_second = $scope.setSecondName[s]; 
				});	  
		}; 
});
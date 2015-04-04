caloriesPerMeal = angular.module('caloriesPerMeal',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

caloriesPerMeal.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MealsController'
      )
])

controllers = angular.module('controllers',[])

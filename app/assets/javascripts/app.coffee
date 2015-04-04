caloriesPerMeal = angular.module('caloriesPerMeal',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

caloriesPerMeal.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MealsController'
      ).when('/meals/:mealId',
        templateUrl: "show.html"
        controller: "RecipeController"
      )
])

controllers = angular.module('controllers',[])

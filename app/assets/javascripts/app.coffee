caloriesPerMeal = angular.module('caloriesPerMeal',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

caloriesPerMeal.config([ '$routeProvider', 'flashProvider'
  ($routeProvider,flashProvider)->
    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'MealsController'
      ).when('/meals/new',
        templateUrl: "form.html"
        controller: "MealController"
      ).when('/meals/:mealId',
        templateUrl: "show.html"
        controller: "MealController"
      ).when('/meals/:mealId/edit',
        templateUrl: "form.html"
        controller: "MealController"
      )
])

controllers = angular.module('controllers',[])

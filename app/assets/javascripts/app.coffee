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
controllers.controller("MealsController", [ '$scope', '$routeParams', '$location','$resource'
  ($scope,$routeParams,$location,$resource)->
    # $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)
    
    
    #$scope.search = (date_to)->  $location.path("/").search('date_to',date_to)
    #$scope.search = (date_from)->  $location.path("/").search('date_from',date_from)
    $scope.search = (date_from,date_to)->  $location.path("/").search({date_from: date_from,date_to:date_to})

    Meal = $resource('/meals/:recipeId', { mealId: "@id", format: 'json' })

    # if $routeParams.keywords
    if $routeParams.date_from && $routeParams.date_to
      #keywords = $routeParams.keywords.toLowerCase()
      date_from = $routeParams.date_from
      date_to = $routeParams.date_to

      # $scope.meals = meals.filter (meal)-> meal.description.toLowerCase().indexOf(keywords) != -1 
      #Meal.query(keywords: $routeParams.keywords, (results)-> $scope.meals = results)

      #The query method is executing a GET request and expects an array to be returned
      #Meal.query(keywords: $routeParams.keywords, (results)-> $scope.meals = results)
      Meal.query({date_from: $routeParams.date_from, date_to: $routeParams.date_to}, (results)-> $scope.meals = results)
    else
      $scope.meals = []
])

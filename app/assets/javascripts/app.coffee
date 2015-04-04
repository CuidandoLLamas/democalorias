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
    $scope.search = (date_from,date_to)->  $location.path("/").search({date_from: date_from,date_to:date_to})

    #This statement creates a resource that will have methods to execute REST requests
    Meal = $resource('/meals/:recipeId', { mealId: "@id", format: 'json' })

    if $routeParams.date_from && $routeParams.date_to
      date_from = $routeParams.date_from
      date_to = $routeParams.date_to

      #The query method is executing a GET request and expects an array to be returned
      Meal.query({date_from: $routeParams.date_from, date_to: $routeParams.date_to}, (results)-> $scope.meals = results)
    else
      #This means no input date_from and date_to dates were provided, we fill the default current week start and end dates

      monday=moment().isoWeekday(1)
      sunday=moment().isoWeekday(7)
      $scope.date_from=monday.format("DD/MM/YYYY")
      $scope.date_to=sunday.format("DD/MM/YYYY")

      #We'll loop day by day from start to end date
      day=monday
      endDay=sunday

      days=[]
      while (!day.isSame(endDay,'day'))
        days.push(day)
        console.log("Dia:" + day)
        day.add(1, 'days');

      console.log("Dia:" + day)
      days.push(day)

      $scope.days=days
      Meal.query({date_from: $scope.date_from, date_to: $scope.date_to}, (results)-> $scope.meals = results)

      #TODO see if it's a good idea to fill the days array with date from meals on each day
])

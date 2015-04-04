controllers = angular.module('controllers')
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

      Meal.query({date_from: $scope.date_from, date_to: $scope.date_to}, (results)-> $scope.meals = results)

    $scope.view = (mealId)-> $location.path("/meals/#{mealId}")
])

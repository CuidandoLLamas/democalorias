controllers = angular.module('controllers')
controllers.controller("MealController", [ '$scope', '$routeParams', '$resource','flash'
  ($scope,$routeParams,$resource,flash)->
    Meal = $resource('/meals/:mealId', { mealId: "@id", format: 'json' })
    Meal.get({mealId: $routeParams.mealId},
      ( (meal)-> $scope.meal = meal ),
      ( (httpResponse)-> 
        $scope.meal = null
        flash.error = "There is no meal with ID #{$routeParams.mealId}"
      )
    )

])
controllers = angular.module('controllers')
controllers.controller("MealController", [ '$scope', '$routeParams', '$resource','$location','flash',
  ($scope,$routeParams,$resource,$location,flash)->
    Meal = $resource('/meals/:mealId', { mealId: "@id", format: 'json' })
    Meal.get({mealId: $routeParams.mealId},
      ( (meal)-> $scope.meal = meal ),
      ( (httpResponse)-> 
        $scope.meal = null
        flash.error = "There is no meal with ID #{$routeParams.mealId}"
      )
    )

    $scope.back = -> $location.path("/")

    $scope.delete = (recipeId) -> 
      Meal = $resource('/meals/:mealId', { mealId: "@id", format: 'json' })
      Meal.remove({mealId: $routeParams.mealId},
        ( (meal)-> 
          $location.path("/")
        ),
        ( (httpResponse)-> 
          $location.path("/")
          #flash.error = "There is no meal with ID #{$routeParams.mealId}"
        )
      )


])
controllers = angular.module('controllers')
controllers.controller("MealController", [ '$scope', '$routeParams', '$resource','$location','flash',
  ($scope,$routeParams,$resource,$location,flash)->
    Meal = $resource('/meals/:mealId', { mealId: "@id", format: 'json' },
      {
        #Rails requires PUT for update and POST for create, we have to change the defaults
        'save': {method: 'PUT'},
        'create': {method: 'POST'}
      }
    )

    if $routeParams.mealId
      Meal.get({mealId: $routeParams.mealId},
        ( (meal)-> $scope.meal = meal ),
        ( (httpResponse)-> 
          $scope.meal = null
          flash.error = "There is no meal with ID #{$routeParams.mealId}"
        )
      )
    else
      $scope.meal={}

    #Implementation of back Method
    $scope.back = -> 
      $location.path("/")

    #Implementation of save Method
    $scope.save = -> 
      onError = (_httpResponse)-> 
        flash.error = "Something went wrong"
      if $scope.meal.id
        $scope.meal.$save(
          ( () -> $location.path("/meals/#{$scope.meal.id}") ),
           onError 
        )
      else
        Meal.create($scope.meal,
          ( (newMeal)-> $location.path("/meals/#{newMeal.id}") ),
          onError
        )

    $scope.delete = -> 
      $scope.meal.$delete()
      $scope.back()

])
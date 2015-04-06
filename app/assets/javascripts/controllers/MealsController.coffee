controllers = angular.module('controllers')
controllers.controller("MealsController", [ '$scope', '$routeParams', '$location','$resource','$route'
  ($scope,$routeParams,$location,$resource,$route)->


    #Setup for the calendars

    $scope.isCollapsed=true


    #open functions
    $scope.open_date_from = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.date_from_opened = true

    $scope.open_date_to = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.date_to_opened = true
    

    
    #End for setting up calendars

    #Search action
    $scope.search = (date_from,date_to)-> 
      $scope.date_from=date_from
      $scope.date_to=date_to
      $location.path("/").search(
        {
        date_from: moment(date_from).format("DD/MM/YYYY"),
        date_to:moment(date_to).format("DD/MM/YYYY")
        }
      )

    if $routeParams.date_from && $routeParams.date_to
      #This statement creates a resource that will have methods to execute REST requests
      Meal = $resource('/meals/:recipeId', { mealId: "@id", format: 'json' })
      #$scope.date_from = $routeParams.date_from
      #$scope.date_to = $routeParams.date_to

      $scope.date_from=moment($routeParams.date_from,"DD/MM/YYYY")._d
      $scope.date_to=moment($routeParams.date_to,"DD/MM/YYYY")._d

      #The query method is executing a GET request and expects an array to be returned
      Meal.query({date_from: $routeParams.date_from, date_to: $routeParams.date_to},
        (results)-> 
          $scope.meals = results
      )
    else
      $scope.meals = []
      #This means no input date_from and date_to dates were provided, we fill the default current week start and end dates

      $scope.dateOptions = 
      formatYear: 'yy',
      startingDay: 1
    
      monday=moment().isoWeekday(1)
      sunday=moment().isoWeekday(7)
      $scope.date_from=monday._d #.format("DD/MM/YYYY")
      $scope.date_to=sunday._d #.format("DD/MM/YYYY")

    $scope.view = (mealId)-> 
      $location.path("/meals/#{mealId}")


    $scope.deleteMeal = (mealId) -> 
      Meal = $resource('/meals/:mealId', { mealId: "@id", format: 'json' })
      Meal.remove({mealId: mealId},
        ( (meal)-> 
          #As we're on same page we ask angular to reload it
          $route.reload()
        ),
        ( (httpResponse)-> 
          $route.reload()
          #flash.error = "There is no meal with ID #{mealId}"
        )
      )

    $scope.newMeal = ->
      $location.path("/meals/new")

    $scope.editMeal = (mealId) ->
      $location.path("/meals/#{mealId}/edit")

    $scope.getDateOutOfMeal = (meal) ->
      moment(meal.moment).format("DD/MM/YYYY")

    $scope.getTimeOutOfMeal = (meal) ->
      moment(meal.moment).format("hh:mm")

        
])

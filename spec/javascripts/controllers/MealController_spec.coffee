describe "MealController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  location     = null
  mealId     = 42

  fakeMeal   =
    id: mealId
    description: "Baked Potatoes"
    calories: 10023
    moment: "2015-04-02T18:44:10.191Z"

  setupController =(mealExists=true, mealId=42)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller , _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.mealId = mealId if mealId
      flash=_flash_

      if mealId
        request = new RegExp("\/meals/#{mealId}")
        results = if mealExists
          [200,fakeMeal]
        else
          [404]

        httpBackend.expectGET(request).respond(results[0],results[1])

      ctrl        = $controller('MealController',
                                $scope: scope)
    )

  beforeEach(module("caloriesPerMeal"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'meal is found', ->
      beforeEach(setupController())
      it 'loads the given meal', ->
        httpBackend.flush()
        expect(scope.meal).toEqualData(fakeMeal)
    describe 'meal is not found', ->
      beforeEach(setupController(false))
      it 'loads the given meal', ->
        httpBackend.flush()
        expect(scope.meal).toBe(null)
        expect(flash.error).toBe("There is no meal with ID #{mealId}")

  describe 'create', ->
    newMeal=
      id:13
      description: 'Toast'
      calories: 1212
      moment: '2015-04-04T17:23:50.750Z'
    beforeEach ->
      setupController(false,false)
      request = new RegExp("\/meals")
      httpBackend.expectPOST(request).respond(201,newMeal)

    it 'posts to the backend', ->
      scope.meal.description         = newMeal.description
      scope.meal.calories         = newMeal.calories
      scope.meal.moment         = newMeal.moment
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/meals/#{newMeal.id}")


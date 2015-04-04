describe "MealController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  mealId     = 42

  fakeMeal   =
    id: mealId
    description: "Baked Potatoes"
    calories: 10023
    moment: "2015-04-02T18:44:10.191Z"

  setupController =(mealExists=true)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller , _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.mealId = mealId
      flash=_flash_

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
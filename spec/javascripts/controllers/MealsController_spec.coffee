describe "MealsController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null

  # access injected service later
  httpBackend  = null

  setupController =(keywords,results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend,$controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      routeParams = $routeParams
      routeParams.keywords = keywords

      # capture the injected service
      httpBackend = $httpBackend 

      if results
        request = new RegExp("\/meals.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)
      ctrl        = $controller('MealsController',
                                $scope: scope
                                $location: location)
    )

  beforeEach(module("caloriesPerMeal"))
  beforeEach(setupController())

  it 'defaults to no meals', ->
    expect(scope.meals).toEqualData([])
#TODO spec not working
describe "MealsController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null

  # access injected service later
  httpBackend  = null

  #setupController =(keywords,results)->
  setupController =(date_from,date_to,results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend,$controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      routeParams = $routeParams
      #routeParams.keywords = keywords
      routeParams.date_from = date_from
      routeParams.date_to = date_to

      # capture the injected service
      httpBackend = $httpBackend 

      if results
        #request = new RegExp("\/meals.*keywords=#{keywords}")
        request = new RegExp("\/meals.*date_from=#{date_from}&date_to=#{date_to}")
        httpBackend.expectGET(request).respond(results)
      ctrl        = $controller('MealsController',
                                $scope: scope
                                $location: location)
    )

  beforeEach(module("caloriesPerMeal"))
  beforeEach(setupController())

  it 'defaults to no meals', ->
    expect(scope.meals).toEqualData([])
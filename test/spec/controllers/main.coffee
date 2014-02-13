"use strict"

describe "Controller:MainController", ()->
  $controller = undefined
  $rootScope = undefined
  $scope = undefined
  Debug = undefined
  createController = undefined
  $httpBackend = undefined
  beforeEach( ()->
    module('angularDcjsApp')
    inject(($injector)->
      $rootScope = $injector.get('$rootScope')
      $scope = $rootScope.$new()
      Debug = $injector.get('Debug')
      $controller = $injector.get('$controller')
      $httpBackend = $injector.get('$httpBackend');

      createController = ()->
        return $controller('MainController', {'$scope':$scope, 'Debug': Debug})
      return
    )
    return
  )

  afterEach( ()->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it "should have array in measures", ()->
    controller = createController();
    expect($scope.measures).toEqual jasmine.any(Array)

  it "Debug should be loaded", ()->
    controller = createController();
    expect($scope.debug).not.toBeNull

  it "should add an input value", ()->
    controller = createController();
    $scope.debug.input('Test')
    expect($scope.debug.output().length).toBe 1

  it "GridsterOpts to equal an Object", ()->
    controller = createController();
    expect($scope.gridOpts).toEqual jasmine.any(Object)

  it "Items to equal an Array", ()->
    controller = createController();
    expect($scope.items).toEqual jasmine.any(Array)

  it "should get the data from backend Mock", ()->
    $httpBackend.when('GET','sampledata.json').respond(200)
    controller = createController();

  it "should have array in metadata", ()->
    controller = createController();
    expect($scope.metadata).toEqual jasmine.any(Array)

  it "should find MEASURES and log them", ()->
    controller = createController();
    expect($scope.debug.output().length).toBe > 0
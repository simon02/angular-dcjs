"use strict"

describe "Controller:MainController", ()->
  $controller = undefined
  $rootScope = undefined
  $scope = undefined
  Debug = undefined
  $httpBackend = undefined
  dataAPI = undefined
  dataResponse = undefined
  MainController = undefined

  beforeEach( ()->
    module('angularDcjsApp')
  )

  beforeEach( ()->
    inject(($injector, _Debug_, _dataAPI_)->
      Debug = _Debug_
      dataAPI = _dataAPI_
      $rootScope = $injector.get('$rootScope')
      $scope = $rootScope.$new()
      $controller = $injector.get('$controller')
      $httpBackend = $injector.get('$httpBackend')
      dataResponse = [
        ["DATETIME:date", "MEASURE: Units", "MEASURE: Royalty Price", "MEASURE: Customer Price", "DIMENSION:Vendor Identifier", "DIMENSION:Title", "DIMENSION:Label/Studio/Network", "DIMENSION:Product Type Identifier", "DIMENSION: Order Id", "DIMENSION:Postal Code", "DIMENSION: Customer Identifier", "DIMENSION:Sale/Return", "DIMENSION:Customer Currency", "DIMENSION:Country Code", "DIMENSION:Royalty Currency", "DIMENSION:Asset/Content Flavor"],
        ["9/27/13", 1, 3.49, 4.99, "0144_20121109", "Headh", "Yello", "D", "5.02E+09", "49915-2504", 2240000173, "S", "USD", "CL", "USD", "HD"],
        ["9/24/13", 1, 1.39, 1.99, "0099_20120827", "A Ond", "Const", "D", "2.03E+09", "29284-3466", 1642627348, "S", "USD", "BR", "USD", "SD"],
      ]

      MainController = $controller('MainController', {'$scope':$scope, 'Debug': Debug})
      return
    )
    return
  )

  afterEach( ()->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
  )

  it "should be an array in measures", ()->
    expect($scope.measures).toEqual jasmine.any(Array)

  it "Debug should be loaded", ()->
    expect(Debug).not.toBeNull

  it "should call retrieve ", ()->
    spyOn($scope,'retrieveData').andCallThrough()
    $scope.retrieveData()
    expect($scope.retrieveData).toHaveBeenCalled()

  it "should populate rows", ()->
    $scope.rows = dataResponse
    expect($scope.rows).toEqual jasmine.any(Array)

  it "should call identifyHeaders", ()->
    spyOn($scope,'identifyHeaders').andCallThrough()
    $scope.identifyHeaders()
    expect($scope.identifyHeaders).toHaveBeenCalled()

  it "should call getMeasures", ()->
    spyOn($scope,'getMeasures').andCallThrough()
    $scope.getMeasures()
    expect($scope.getMeasures).toHaveBeenCalled()

  it "should call log for Measures", ()->
    spyOn($scope,'log').andCallThrough()
    $scope.log()
    expect($scope.log).toHaveBeenCalled()

  it "should call getDimensions", ()->
    spyOn($scope,'getDimensions').andCallThrough()
    $scope.getDimensions()
    expect($scope.getDimensions).toHaveBeenCalled()

  it "should call log for Dimensions", ()->
    spyOn($scope,'log').andCallThrough()
    $scope.log()
    expect($scope.log).toHaveBeenCalled()

  it "should add measures", ()->
    expect($scope.measures.length).toBe > 0



  it "should add an input value", ()->
    spyOn(Debug, 'input').andCallThrough()
    Debug.input('Test')
    expect(Debug.input).toHaveBeenCalled()

  it "should call output and get more than one item in array", ()->
    spyOn(Debug, 'output').andCallThrough()
    expect(Debug.output().length).toBe > 0
    expect(Debug.output).toHaveBeenCalled()

  it "should find MEASURES and log them", ()->
    expect(Debug.output().length).toBe > 0
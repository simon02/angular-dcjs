"use strict"
describe "Controller:MainController", ()->

  beforeEach (module('angularDcjsApp'))

  it "list should be equal an array", inject(($controller, $rootScope)->

    $scope = $rootScope.$new();
    controller = $controller('MainController', {'$scope':$scope})
  ),
  ()->
    $scope.list = []

    expect($scope.list).toEqual([])
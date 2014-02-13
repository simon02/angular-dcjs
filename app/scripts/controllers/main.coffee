angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','$http',
  ($scope, Debug, $http)->
    $scope.debug = Debug;

    $scope.debug.input("Teste")
    $scope.metadata = []

    $http.get('sampledata.json').then((response)->
      $scope.metadata = response.data
    )


    $scope.gridOpts = {
      margins: [20, 20],
      draggable: {
        enabled: true
      },
      resizable: {
        enabled: false
      }
    }

    $scope.items = [
      { sizeX: 2, sizeY: 1, row: 0, col: 0 },
      { sizeX: 2, sizeY: 2, row: 0, col: 2 },
      { sizeX: 1, sizeY: 1, row: 0, col: 4 },
      { sizeX: 1, sizeY: 1, row: 0, col: 5 },
      { sizeX: 2, sizeY: 1, row: 1, col: 0 },
      { sizeX: 1, sizeY: 1, row: 1, col: 4 },
      { sizeX: 1, sizeY: 2, row: 1, col: 5 },
      { sizeX: 1, sizeY: 1, row: 2, col: 0 },
      { sizeX: 2, sizeY: 1, row: 2, col: 1 },
      { sizeX: 1, sizeY: 1, row: 2, col: 3 },
      { sizeX: 1, sizeY: 1, row: 2, col: 4 }
    ];

])
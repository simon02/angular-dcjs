angular.module('angularDcjsApp').

controller('MainController', ['$scope',
  ($scope)->

    $scope.gridOpts = {
      margins: [20, 20],
      draggable: {
        enabled: true
      },
      resizable: {
        enabled: false
      }
    }

    $scope.customItems = [
      { sizeX: 3, sizeY: 3, row: 0, col: 0 },
      { sizeX: 3, sizeY: 2, row: 0, col: 1 },
      { sizeX: 3, sizeY: 3, row: 0, col: 2 }
    ];
])
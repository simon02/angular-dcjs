angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','$http',
  ($scope, Debug, $http)->
    $scope.debug = Debug;

    $scope.measures = []
    $scope.metadata = []

    $http.get('sampledata.json').then((response)->
      $scope.metadata = response.data
    )

    $scope.$watch('metadata', (data)->
      $scope.findMeasures() if data
    )

    $scope.findMeasures = ()->
      $scope.debug.clear()
      items = []
      if $scope.metadata[0]
        angular.forEach($scope.metadata[0],(value)->
          input = value.match(/MEASURE:(.*)/)
          if input
            items.push(input[1])
        )
        if items.length > 0
          $scope.debug.input({
            name:'Measures Available',
            'items': items
          })

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
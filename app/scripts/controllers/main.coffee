angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','dataAPI',
  ($scope, Debug, dataAPI)=>

    $scope.measures = []
    $scope.dimensions = []

    $scope.log = (value)=>
      Debug.input(value)

    $scope.getLog = ()->
      return Debug.output()

    $scope.retrieveData = ()->
      d3.csv('sampledata.csv', (response)->
        $scope.$apply(()->
          $scope.rows = crossfilter(response)
        )
      )
      ###dataAPI.getData().then((response)->
        $scope.rows = response.data
        $scope.identifyHeaders(response.data)
        return
      )###
      return

    $scope.identifyHeaders = (data) =>
      $scope.getMeasures(data)
      $scope.getDimensions(data)


    $scope.getDimensions = (data)=>
      items = []
      if data
        angular.forEach(data[0],(value)=>
          input = value.match(/DIMENSION:(.*)/)
          if input
            items.push(input[1])
        )
        if items.length > 0
          $scope.measures = items
          $scope.log({
            name:'Dimensions',
            'items': items
          })

    $scope.getMeasures= (data)=>
      items = []
      if data
        angular.forEach(data[0],(value)=>
          input = value.match(/MEASURE:(.*)/)
          if input
            items.push(input[1])
        )
        if items.length > 0
          $scope.dimensions = items
          $scope.log({
            name:'Measures',
            'items': items
          })

    $scope.retrieveData()

])
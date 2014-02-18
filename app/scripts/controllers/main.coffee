angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','dataAPI',
  ($scope, Debug, dataAPI)=>

    $scope.measures = []
    $scope.dimensions = []

    $scope.getLog = ()->
      return Debug.output()

    $scope.retrieveData = ()->
      dataAPI.getData().then((response)->
        if response.data
          response.data.forEach((d)->
            d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date'])
            return
          )
          $scope.rows = crossfilter(response.data)
          $scope.identifyHeaders(response.data)
        return
      )
      return

    $scope.identifyHeaders = (data) =>
      $scope.getParams(data, 'Datetime')
      $scope.getParams(data, 'Dimension')
      $scope.getParams(data, 'Measure')

    $scope.getParams = (data, index)=>
      if data and index
        items = []
        pattern = new RegExp(index.toUpperCase() + ':(.*)')
        angular.forEach(data[0],(value, key)=>
          input = key.match(pattern)
          if input
            items.push(input[1])
        )
        if items.length > 0
          $scope[index] = items

          Debug.input({
            name: index,
            'items': items
          })

    $scope.retrieveData()

])
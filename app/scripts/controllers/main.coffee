angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','dataAPI',
  ($scope, Debug, dataAPI)=>

    $scope.measures = []
    $scope.dimensions = []
    $scope.datetime= []

    $scope.gridsterOpts = {
      margins: [20, 20]
      draggable: {
        enabled: true
      }
      resizable: {
        enabled: false
      }
    }

    $scope.customItems = [
      { sizeX: 2, sizeY: 1, row: 0, col: 0},
      { sizeX: 2, sizeY: 2, row: 0, col: 2},
      { sizeX: 1, sizeY: 1, row: 0, col: 4}
    ]

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
          $scope.lineChartDim = $scope.rows.dimension((d)->
            return d['DATETIME:date']
          )

          $scope.seriesChartDim = $scope.rows.dimension((d)->
            return [d['DATETIME:date'] , d['DIMENSION:Asset/Content Flavor']]
          )
          $scope.pieChartDim = $scope.rows.dimension((d)->
            return d['DIMENSION:Asset/Content Flavor']
          )

          $scope.setChartDim()
          $scope.identifyHeaders(response.data)
        return
      )
      return

    $scope.identifyHeaders = (data) =>
      $scope.getParams(data, 'Datetime')
      $scope.getParams(data, 'Dimension')
      $scope.getParams(data, 'Measure')

    $scope.setChartDim = ()->
      $scope.seriesChartOpts = {
        data: $scope.rows
        dimension: $scope.seriesChartDim
        sum: $scope.seriesChartDim.group().reduceSum((d)->
          return d['MEASURE:Customer Price']
        )
        minDate: $scope.seriesChartDim.bottom(1)[0]['DATETIME:date']
        maxDate: $scope.seriesChartDim.top(1)[0]['DATETIME:date']
      }
      $scope.lineChartOpts = {
        data: $scope.rows
        dimension: $scope.lineChartDim
        sum: $scope.lineChartDim.group().reduceSum((d)->
            return d['MEASURE:Customer Price']
          )
        minDate: $scope.lineChartDim.bottom(1)[0]['DATETIME:date']
        maxDate: $scope.lineChartDim.top(1)[0]['DATETIME:date']
      }

      $scope.pieChartOpts = {
        data: $scope.rows
        dimension: $scope.pieChartDim
        sum: $scope.pieChartDim.group().reduceSum((d)->
          return d['MEASURE:Customer Price']
        )
      }

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


    $scope.generateDimensions = ()->
      angular.forEach($scope.Dimension,(value, key)->
        dimensions = $scope.rows.dimension((d)->
          return d['DIMENSION:' + value]
        )
        angular.forEach(dimensions.group().all(),(value2,key2)->
          $scope.filterSource.push(
            'DIMENSION:' + value + ':' + value2.key
            )
        )
      )

    $scope.generateMeasures = ()->
      angular.forEach($scope.Measure,(value, key)->
        dimensions = $scope.rows.dimension((d)->
          return d['MEASURE:' + value]
        )
        angular.forEach(dimensions.group().all(),(value2,key2)->
          $scope.filterSource.push(
            'MEASURE:' + value + ':' + value2.key
            )
        )
      )

    $scope.generateDatetime= ()->
      angular.forEach($scope.Datetime,(value, key)->
        dimensions = $scope.rows.dimension((d)->
          return d['DATETIME:' + value]
        )
        angular.forEach(dimensions.group().all(),(value2,key2)->
          $scope.filterSource.push(
            'DATETIME:' + value + ':' + value2.key.toUTCString()
          )
        )
      )

    $scope.filter = ()->
      if $scope.pieChartOpts.dimension
        $scope.pieChartOpts.dimension.filter((d)->
          if d is $scope.include
            d
        )
        return


    $scope.useFilter = ()->
#      if($scope.include)
#        $scope.exclude = null
#        pattern = new RegExp('(.*):(.*):(.*)')
#        input = $scope.include.match(pattern)
#        if(input)
#          if(input.length >= 4)
#            if input[3] isnt ""
#              $scope.filter = {
#                dimension: input[1] + ':' + input[2],
#                value: input[3]
#              }
#              $scope.setFilter()
#              return
#            else
#              if $scope.newFilter
#                $scope.newFilter.filter(null)
#                return

    $scope.removeFilter = ()->

])
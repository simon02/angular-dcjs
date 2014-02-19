angular.module('angularDcjsApp').

controller('MainController', ['$scope','Debug','dataAPI',
  ($scope, Debug, dataAPI)=>

    $scope.measures = []
    $scope.dimensions = []
    $scope.datetime= []

    $scope.searchData = []

    $scope.select2Opt = {
      'multiple':true,
      'simples_tags': true,
      'tags': [$scope.measures, $scope.dimensions, $scope.datetime]
    }

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
          $scope.myDim = $scope.rows.dimension((d)->
            return d['DATETIME:date']
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
      $scope.lineChartOpts = {
        dimension: ()->
          $scope.rows.dimension((d)->
            return d['DATETIME:date']
          )
        sum: ()->
          @dimension().group().reduceSum((d)->
            return d['MEASURE:Customer Price']
          )
        minDate: ()->
          @dimension().bottom(1)[0]['DATETIME:date']
        maxDate: ()->
          @dimension().top(1)[0]['DATETIME:date']
      }

      $scope.pieChartOpts = {
        dimension: ()->
          $scope.rows.dimension((d)->
            return d['DIMENSION:Asset/Content Flavor']
          )
        sum: ()->
          @dimension().group().reduceSum((d)->
            return d['MEASURE:Customer Price']
          )
      }

      $scope.pieChartOpts2 = {
        dimension: ()->
          $scope.rows.dimension((d)->
            return d['DIMENSION:Title']
          )
        sum: ()->
          @dimension().group().reduceSum((d)->
            return d['MEASURE:Customer Price']
          )
      }
      return

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

    $scope.useFilter = ()->
      if($scope.include)
        $scope.exclude = null
        pattern = new RegExp('(.*):(.*):(.*)')
        input = $scope.include.match(pattern)
        if(input)
          if(input.length >= 4)
            if input[3] isnt ""
              $scope.filter = {
                dimension: input[1] + ':' + input[2],
                value: input[3]
              }
              $scope.setFilter()
              return
            else
              if $scope.newFilter
                $scope.newFilter.filter(null)
                return

    $scope.setFilter = ()->
      $scope.newFilter = $scope.rows.dimension((d)->
        d['DATETIME:date']
      )
      $scope.newFilter.filter($scope.filter.value)

      dc.redrawAll()



    $scope.removeFilter = ()->

])
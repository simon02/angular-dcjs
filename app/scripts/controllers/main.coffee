angular.module('angularDcjsApp').

controller('MainController', ['$scope','$filter','$log','Debug','dataAPI',
  ($scope, $filter, $log, Debug, dataAPI)=>

    $scope.filterSearch = []
    $scope.include = {}

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
      { sizeX: 2, sizeY: 2, row: 0, col: 0},
      { sizeX: 2, sizeY: 2, row: 0, col: 2},
      { sizeX: 2, sizeY: 2, row: 0, col: 4}
    ]

    $scope.getLog = ()->
      return Debug.output()

    $scope.checkFilter = (rows)->
      return rows.length > 0

    $scope.render = ()->
      if($scope.filter)
        if($scope.checkFilter($filter('filter')($scope.sourceData, $scope.filter)))
          $scope.rows = crossfilter($filter('filter')($scope.sourceData, $scope.filter))
        else
          $log.warn("No content Found")
          return false
      else
        $scope.rows = crossfilter($scope.sourceData)

      $scope.lineChartDim = $scope.rows.dimension((d)->
        return d['DATETIME:date']
      )
      $scope.composeChartDim = $scope.rows.dimension((d)->
        return d['DATETIME:date']
      )
      $scope.pieChartDim = $scope.rows.dimension((d)->
        return d['DIMENSION:Asset/Content Flavor']
      )

      renderers = jQuery.extend(jQuery.pivotUtilities.renderers,
        jQuery.pivotUtilities.gchart_renderers)

      jQuery("#pivottable").pivotUI(
        $scope.lineChartDim.top(Infinity)
        {
          renderers: renderers
        }
      )
      $scope.setChartDim()

    $scope.retrieveData = ()->
      dataAPI.getData().then((response)->
        if response.data
          response.data.forEach((d)->
            d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date'])
            return
          )

          $scope.sourceData = response.data
          $scope.identifyHeaders($scope.sourceData)
          $scope.render()
        return
      )
      return


      
    $scope.identifyHeaders = (data) =>
      $scope.getParams(data, 'Datetime')
      $scope.getParams(data, 'Dimension')
      $scope.getParams(data, 'Measure')

    $scope.setChartDim = ()->

      $scope.composeChartOpts = {
        data: $scope.rows
        dimension: $scope.composeChartDim
        sum:
          title: ["HD","SD"]
          object: $scope.composeChartDim.group().reduce(
            (p, v)->
              if(v['DIMENSION:Asset/Content Flavor'] == 'HD')
                p.HD += +v['MEASURE:Customer Price']
              if(v['DIMENSION:Asset/Content Flavor'] == 'SD')
                p.SD += +v['MEASURE:Customer Price']
              return p
            (p, v)->
              if(v['DIMENSION:Asset/Content Flavor'] == 'HD')
                p.HD -= +v['MEASURE:Customer Price']
              if(v['DIMENSION:Asset/Content Flavor'] == 'SD')
                p.SD -= +v['MEASURE:Customer Price']
              return p
            ()->
              return {
                HD: 0
                SD: 0
              }
          )
        min: $scope.composeChartDim.bottom(1)[0]['DATETIME:date']
        max: $scope.composeChartDim.top(1)[0]['DATETIME:date']
      }

      $scope.lineChartOpts = {
        data: $scope.rows
        dimension: $scope.lineChartDim
        sum: $scope.lineChartDim.group().reduceSum((d)->
            return d['MEASURE:Customer Price']
          )
        min: $scope.lineChartDim.bottom(1)[0]['DATETIME:date']
        max: $scope.lineChartDim.top(1)[0]['DATETIME:date']
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
          $scope.setFilterSearch(items, index.toUpperCase())
          $scope[index] = items

          Debug.input({
            name: index,
            'items': items
          })

    $scope.retrieveData()

    $scope.setFilterSearch = (items, index)->
      items.forEach((item)->
        $scope.filterSearch.push(index + ':' + item)
      )


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

    $scope.$watch('include', (include, oldInclude)->
      if include.type
        if include.type isnt oldInclude.type
          include.text = ""
        $scope.filter = {}
        $scope.filter[include.type] = if include.text then include.text else ""
        $scope.render()
    , true)

    return

])
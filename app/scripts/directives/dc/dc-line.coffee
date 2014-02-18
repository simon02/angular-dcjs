"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcLine',[]).

directive "dcLine", ()->
  scope:
    data: '='
    dimensions: '='
    filter: '='
  templateUrl: 'dc/line/template.html'
  link: ($scope, element, attrs)->

    $scope.chartId = if attrs.id then attrs.id else 'dcLineDefault'
    $scope.height = if attrs.height then attrs.height else 150
    $scope.dcLineChart = dc.lineChart('#' + $scope.chartId)

    $scope.$watch('data', (data)->
      if data
        $scope.chartData = data
        $scope.create()
        return
    )

    $scope.$watch('filter', (filter)->
      if filter
        $scope.setFilter(filter.dimension, filter.value)
    , true)

    $scope.setFilter = (dimension, value)->
      newDim = $scope.chartData.dimension((d)->
        return d['DATETIME:date']
      )

      sum = newDim.group().reduceSum((d)->
        return d[dimension]
      )

      $scope.dcLineChart.
      group(sum).
      yAxisLabel(dimension)

      if(value)
        $scope.dcLineChart.filter(value)
      else
        $scope.dcLineChart.filter()

      $scope.dcLineChart.render()

    $scope.create = ()=>
      dimensions = $scope.chartData.dimension((d)->
        return d['DATETIME:date']
      )

      totalSum = dimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      minDate = dimensions.bottom(1)[0]['DATETIME:date']
      maxDate = dimensions.top(1)[0]['DATETIME:date']

      $scope.dcLineChart.
        width(element.width()).
        height($scope.height).
        margins({ top: 10, left: 50, right: 10, bottom: 50 }).
        dimension(dimensions).
        group(totalSum, "Price").
        x(d3.time.scale().domain([minDate,maxDate])).
        yAxisLabel("Customer Price").
        xAxisLabel("Date").
        renderArea(true).
        elasticY(true).
        elasticX(true)

      $scope.dcLineChart.render()
      return
    return
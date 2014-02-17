"use strict"

angular.module('dcLine',[]).

directive "dcLine", ()->
  if not dc or not d3 or not crossfilter or not _
    throw 'You need to load DC, D3, Crossfilter and Underscore library'
  scope:
    data: '='
    dimensions: '='
  transclude: true
  templateUrl: 'dc/line/template.html'
  link: ($scope, element, attrs)->

    $scope.chartId = if attrs.id then attrs.id else 'dcLineDefault'
    $scope.height = if attrs.height then attrs.height else 150

    $scope.$watch('data', (data)->
      if data
        $scope.chartData = angular.copy(data)
        $scope.dcLineChart = dc.lineChart('#' + $scope.chartId)
        $scope.create()
        return
    )

    $scope.create = ()=>
      $scope.chartData.forEach((d)->
        d['dateLineParam'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date'])
        return
      )

      groups = crossfilter($scope.chartData)
      dateDimensions = groups.dimension((d)->
        return d['dateLineParam']
      )
      totalSum = dateDimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      minDate = dateDimensions.bottom(1)[0]['dateLineParam']
      maxDate = dateDimensions.top(1)[0]['dateLineParam']

      $scope.dcLineChart.
        width(element.width()).
        height($scope.height).
        dimension(dateDimensions).
        group(totalSum, "Price").
        x(d3.time.scale().domain([minDate,maxDate])).
        yAxisLabel("Total").
        xAxisLabel("Data")

      $scope.dcLineChart.render()
      return
    return
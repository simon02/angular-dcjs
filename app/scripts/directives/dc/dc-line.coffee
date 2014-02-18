"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcLine',[]).

directive "dcLine", ()->
  scope:
    data: '='
    dimensions: '='
  templateUrl: 'dc/line/template.html'
  link: ($scope, element, attrs)->

    $scope.chartId = if attrs.id then attrs.id else 'dcLineDefault'
    $scope.height = if attrs.height then attrs.height else 150

    $scope.$watch('data', (data)->
      if data
        $scope.chartData = data
        $scope.dcLineChart = dc.lineChart('#' + $scope.chartId)
        $scope.create()
        return
    )

    $scope.create = ()=>

      dateDimensions = $scope.chartData.dimension((d)->
        return d['DATETIME:date']
      )
      totalSum = dateDimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      minDate = dateDimensions.bottom(1)[0]['DATETIME:date']
      maxDate = dateDimensions.top(1)[0]['DATETIME:date']

      $scope.dcLineChart.
        width(element.width()).
        height($scope.height).
        margins({ top: 10, left: 50, right: 10, bottom: 50 }).
        dimension(dateDimensions).
        group(totalSum, "Price").
        x(d3.time.scale().domain([minDate,maxDate])).
        yAxisLabel("Customer Price").
        xAxisLabel("Date").
        elasticY(true);

      $scope.dcLineChart.render()
      return
    return
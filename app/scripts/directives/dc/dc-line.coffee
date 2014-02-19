"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcLine',[]).

directive "dcLine", ()->
  scope:
    dcLine: '='
    dimensions: '='
    measures: '='
  templateUrl: 'dc/line/template.html'
  link: ($scope, element, attrs)->
    attrs.$observe('id', (id)->
      $scope.chartId = if id then id else 'dcLineDefault'
      $scope.dcLineChart = dc.lineChart('#' + $scope.chartId)
    )

    attrs.$observe('height', (height)->
      $scope.height = if height then height else 150
    )


    $scope.$watch('dimensions',(dim)->
      if dim
        $scope.dimFilters = dim
    )

    $scope.$watch('measures',(measure)->
      if measure
        $scope.measureFilters = measure
    )

    $scope.$watch('dcLine', (dcLine)->
      if dcLine
        $scope.create()
        return
    )

    $scope.create = ()=>
      $scope.dcLineChart.
        width(element.width()).
        height($scope.height).
        margins({ top: 10, left: 50, right: 10, bottom: 50 }).
        dimension($scope.dcLine.dimension).
        group($scope.dcLine.sum).
        x(d3.time.scale().domain([$scope.dcLine.minDate,$scope.dcLine.maxDate])).
        yAxisLabel("Customer Price").
        xAxisLabel("Date").
        renderArea(true).
        elasticY(true)

      $scope.dcLineChart.render()
      return
    return
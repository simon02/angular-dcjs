"use strict"

angular.module('dcModule',['dcModule.templates']).

directive "dcLine", ($compile)->
  if not dc or not d3 or not crossfilter or not _
    throw 'You need to load DC, D3, Crossfilter and Underscore library'
  scope:
    data: '='
    dimensions: '='
  transclude: true
  templateUrl: 'dc/line/template.html'
  controller: ($scope, $compile)->


  link: ($scope, element, attrs)->

    $scope.$watch('data', (data)->
      if data
        $scope.dcLineChart = dc.lineChart('#dcLine')
        $scope.create()
        return
    )

    $scope.create = ()=>
      groups = crossfilter($scope.data)
      dateDimensions = groups.dimension((d)->
        return d['DATETIME:date']
      )
      totalSum = dateDimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      minDate = dateDimensions.bottom(1)[0].date
      maxDate = dateDimensions.top(1)[0].date

      $scope.dcLineChart.
        width(750).
        height(200).
        dimension(dateDimensions).
        group(totalSum, "Price").
        x(d3.time.scale().domain([new Date(minDate), new Date(maxDate)])).
        yAxisLabel("Total").
        xAxisLabel("Data")

      dc.renderAll()
      return
    return
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

    parseDate = d3.time.format("%m/%d/%Y").parse

    $scope.$watch('data', (data)->
      if data
        $scope.dcLineChart = dc.lineChart('#dcLine')
        $scope.create()
        return
    )

    $scope.create = ()=>
      $scope.data.forEach((d)->
        d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date'])
        return
      )

      groups = crossfilter($scope.data)
      dateDimensions = groups.dimension((d)->
        return d['DATETIME:date']
      )
      totalSum = dateDimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      minDate = dateDimensions.bottom(1)[0]['DATETIME:date']
      maxDate = dateDimensions.top(1)[0]['DATETIME:date']

      $scope.dcLineChart.
        width(700).
        height(250).
        dimension(dateDimensions).
        group(totalSum, "Price").
        x(d3.time.scale().domain([minDate,maxDate])).
        yAxisLabel("Total").
        xAxisLabel("Data")

      dc.renderAll()
      return
    return
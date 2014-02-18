"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcPie',[]).

directive "dcPie", ()->
  scope:
    data: '='
  templateUrl: 'dc/pie/template.html'
  link: ($scope, element, attrs)->
    $scope.chartId = if attrs.id then attrs.id else 'dcPieDefault'
    $scope.height = if attrs.height then attrs.height else 150

    $scope.$watch('data', (data)->
      if data
        $scope.chartData = data
        $scope.dcPieChart = dc.pieChart('#' + $scope.chartId)
        $scope.create()
        return
    )

    $scope.create = ()=>
      dateDimensions = $scope.chartData.dimension((d)->
        return d['DIMENSION:Asset/Content Flavor']
      )
      totalSum = dateDimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      $scope.dcPieChart.
        width(element.width()).
        height($scope.height).
        dimension(dateDimensions).
        group(totalSum)

      $scope.dcPieChart.render()
      return
    return
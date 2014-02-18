"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcPie',[]).

directive "dcPie", ()->
  scope:
    data: '='
    filter: '='
  templateUrl: 'dc/pie/template.html'
  link: ($scope, element, attrs)->
    $scope.chartId = if attrs.id then attrs.id else 'dcPieDefault'
    $scope.height = if attrs.height then attrs.height else 150
    $scope.dcPieChart = dc.pieChart('#' + $scope.chartId)

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
        return d[dimension]
      )

      $scope.dcPieChart.
        dimension(newDim)

      if(value)
        $scope.dcPieChart.filter(value)
      else
        $scope.dcPieChart.filter()


      $scope.dcPieChart.render()

    $scope.create = ()=>
      dimensions = $scope.chartData.dimension((d)->
        return d['DIMENSION:Asset/Content Flavor']
      )
      totalSum = dimensions.group().reduceSum((d)->
        return d['MEASURE:Customer Price']
      )

      $scope.dcPieChart.
        width(element.width()).
        height($scope.height).
        dimension(dimensions).
        group(totalSum)

      $scope.dcPieChart.render()
      return
    return
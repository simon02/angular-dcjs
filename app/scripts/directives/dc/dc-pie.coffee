"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcPie',[]).

directive "dcPie", ()->
  restrict: 'AC'
  transclude: true
  scope:
    dcPie: '='
    dimensions: '='
    measures: '='
  templateUrl: 'dc/pie/template.html'
  link: ($scope, element, attrs)->
    attrs.$observe('id', (id)->
      $scope.chartId = if id then id else 'dcPieDefault'
      $scope.dcPieChart = dc.pieChart('#' + $scope.chartId)
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

    $scope.$watch('dcPie', (dcPie)->
      if dcPie
        $scope.create()
        return
    )

    $scope.setMetrics = ()->
      if $scope.dimFilter and $scope.measureFilter
        $scope.dcPieChart.filterAll()
        $scope.dcPie.dimension = $scope.dcPie.data.dimension((d)->
          d['DIMENSION:' + $scope.dimFilter]
        )
        $scope.dcPie.sum  = $scope.dcPie.dimension.group().reduceSum((d)->
          return d['MEASURE:' + $scope.measureFilter]
        )
        $scope.dcPieChart.
          dimension($scope.dcPie.dimension).
          group($scope.dcPie.sum)
        $scope.dcPieChart.render()

    $scope.create = ()=>

      $scope.dcPieChart.
        width(element.width()).
        height($scope.height).
        dimension($scope.dcPie.dimension).
        group($scope.dcPie.sum)

      $scope.dcPieChart.render()
      return
    return
"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcCompose',[]).

directive "dcCompose", ()->
  scope:
    dcCompose: '='
    dimensions: '='
    measures: '='
    filter: '='
  templateUrl: 'dc/compose/template.html'
  link: ($scope, element, attrs)->
    attrs.$observe('id', (id)->
      $scope.chartId = if id then id else 'dcComposeDefault'
    )

    $scope.height = if attrs.height then attrs.height else 150


    $scope.$watch('dimensions',(dim)->
      if dim
        $scope.dimFilters = dim
    )

    $scope.$watch('measures',(measure)->
      if measure
        $scope.measureFilters = measure
    )

    $scope.$watch('dcCompose', (dcCompose)->
      if dcCompose
        $scope.create()
        return
    )

    $scope.$watch('filter',(filter)->
      if $scope.dcComposeChart
        $scope.dcComposeChart.filterAll()
        if filter
          $scope.dcComposeChart.filter(filter)
        $scope.dcComposeChart.redraw()
    )

    $scope.create = ()=>
      $scope.dcComposeChart = dc.lineChart('#' + $scope.chartId)
      $scope.dcComposeChart.
      width(element.width()).
      height($scope.height).
      margins({top: 40, right: 50, bottom: 30, left: 60}).
      dimension($scope.dcCompose.dimension).
      group($scope.dcCompose.sum.object, $scope.dcCompose.sum.title[0]).
      x(d3.time.scale().domain([$scope.dcCompose.min,$scope.dcCompose.max])).
      renderArea(true).
      renderHorizontalGridLines(true).
      elasticY(true).
      brushOn(true).
      valueAccessor((d)->
        return d.value[$scope.dcCompose.sum.title[0]]
      ).
      stack($scope.dcCompose.sum.object, $scope.dcCompose.sum.title[1], (d)->
        return d.value[$scope.dcCompose.sum.title[1]]
      ).
      legend(dc.legend().x(element.width() - 50).y(10)).
      title((d)->
        return d.key
      )
      $scope.dcComposeChart.render()
      return
    return
"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcComposite',[]).

directive "dcComposite", ()->
  scope:
    dcComposite: '='
    dimensions: '='
    measures: '='
    filter: '='
  templateUrl: 'dc/composite/template.html'
  link: ($scope, element, attrs)->
    attrs.$observe('id', (id)->
      $scope.chartId = if id then id else 'dcLineDefault'
      $scope.dcCompositeChart = dc.lineChart('#' + $scope.chartId)
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

    $scope.$watch('filter',(filter)->
      $scope.dcCompositeChart.filterAll()
      if filter
        $scope.dcCompositeChart.filter(filter)
      else
        $scope.dcCompositeChart.filterAll()
      dc.redrawAll($scope.dcCompositeChart.chartGroup());
    )

    $scope.create = ()=>

      $scope.dcCompositeChart.
      width(element.width()).
      height($scope.height).
      x(d3.scale.linear().domain([0,20])).
      xAxisLabel("Date").
      legend(dc.legend().x(80).y(20).itemHeight(13).gap(5)).
      renderHorizontalGridLines(true).
      compose([
          dc.lineChart($scope.dcCompositeChart).
          dimension(dim).
          colors('red').
          group(grp1, "Top Line").
          x(d3.time.scale().domain([$scope.dcComposite.minDate, $scope.dcComposite.maxDate])),
          dc.lineChart($scope.dcCompositeChart).
          dimension(dim).
          colors('blue').
          group(grp2, "Bottom Line").
          x(d3.time.scale().domain([$scope.dcComposite.minDate, $scope.dcComposite.maxDate]))
      ]).
      renderArea(true).
      renderHorizontalGridLines(true).
      elasticY(true)
      .render()


      $scope.dcCompositeChart.
      width(element.width()).
      height($scope.height).
      margins({ top: 10, left: 50, right: 10, bottom: 50 }).
      dimension($scope.dcLine.dimension).
      group($scope.dcLine.sum).
      x(d3.time.scale().domain([$scope.dcComposite.minDate,$scope.dcComposite.maxDate])).
      xAxisLabel("Date").
      renderArea(true).
      renderHorizontalGridLines(true).
      elasticY(true)

      $scope.dcLineChart.render()
      return
    return
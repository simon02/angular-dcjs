"use strict"
if not dc or not d3 or not crossfilter or not _
  throw 'You need to load DC, D3, Crossfilter and Underscore library'

angular.module('dcPie',[]).

directive "dcPie", ()->
  scope:
    dcPie: '='
  templateUrl: 'dc/pie/template.html'
  link: ($scope, element, attrs)->
    $scope.chartId = if attrs.id then attrs.id else 'dcPieDefault'
    $scope.height = if attrs.height then attrs.height else 150
    $scope.dcPieChart = dc.pieChart('#' + $scope.chartId)

    $scope.$watch('dcPie', (dcPie)->
      if dcPie
        $scope.create()
        return
    )

    $scope.create = ()=>

      $scope.dcPieChart.
        width(element.width()).
        height($scope.height).
        dimension($scope.dcPie.dimension).
        group($scope.dcPie.sum)

      $scope.dcPieChart.render()
      return
    return
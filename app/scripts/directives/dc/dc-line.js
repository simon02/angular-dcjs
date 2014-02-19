// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  if (!dc || !d3 || !crossfilter || !_) {
    throw 'You need to load DC, D3, Crossfilter and Underscore library';
  }

  angular.module('dcLine', []).directive("dcLine", function() {
    return {
      scope: {
        dcLine: '=',
        dimensions: '=',
        measures: '='
      },
      templateUrl: 'dc/line/template.html',
      link: function($scope, element, attrs) {
        var _this = this;
        $scope.chartId = attrs.id ? attrs.id : 'dcLineDefault';
        $scope.height = attrs.height ? attrs.height : 150;
        $scope.dcLineChart = dc.lineChart('#' + $scope.chartId);
        $scope.$watch('dimensions', function(dim) {
          if (dim) {
            return $scope.dimFilters = dim;
          }
        });
        $scope.$watch('measures', function(measure) {
          if (measure) {
            return $scope.measureFilters = measure;
          }
        });
        $scope.$watch('dcLine', function(dcLine) {
          if (dcLine) {
            $scope.create();
          }
        });
        $scope.create = function() {
          $scope.dcLineChart.width(element.width()).height($scope.height).margins({
            top: 10,
            left: 50,
            right: 10,
            bottom: 50
          }).dimension($scope.dcLine.dimension).group($scope.dcLine.sum).x(d3.time.scale().domain([$scope.dcLine.minDate, $scope.dcLine.maxDate])).yAxisLabel("Customer Price").xAxisLabel("Date").renderArea(true).elasticY(true);
          $scope.dcLineChart.render();
        };
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=dc-line.map
*/

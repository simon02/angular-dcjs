// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  if (!dc || !d3 || !crossfilter || !_) {
    throw 'You need to load DC, D3, Crossfilter and Underscore library';
  }

  angular.module('dcLine', []).directive("dcLine", function() {
    return {
      restrict: 'AC',
      scope: {
        dcLine: '=',
        dimensions: '=',
        measures: '=',
        filter: '='
      },
      templateUrl: 'dc/line/template.html',
      link: function($scope, element, attrs) {
        attrs.$observe('id', function(id) {
          return $scope.chartId = id ? id : 'dcLineDefault';
        });
        $scope.height = attrs.height ? attrs.height : 150;
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
        $scope.dcLine.update = function() {
          return $scope.create();
        };
        $scope.create = function() {
          $scope.dcLineChart = dc.lineChart('#' + $scope.chartId);
          $scope.dcLineChart.width(element.width()).height($scope.height).margins({
            top: 10,
            left: 50,
            right: 10,
            bottom: 50
          }).dimension($scope.dcLine.dimension).group($scope.dcLine.sum).x(d3.time.scale().domain([$scope.dcLine.min, $scope.dcLine.max])).yAxisLabel($scope.dcLine.indexBy.sum).xAxisLabel($scope.dcLine.indexBy.dimension).renderArea(true).brushOn($scope.dcLine.brush).renderHorizontalGridLines(true).elasticY(true).elasticX(true).render();
        };
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=dc-line.map
*/

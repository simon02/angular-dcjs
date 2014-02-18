// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  if (!dc || !d3 || !crossfilter || !_) {
    throw 'You need to load DC, D3, Crossfilter and Underscore library';
  }

  angular.module('dcLine', []).directive("dcLine", function() {
    return {
      scope: {
        data: '=',
        dimensions: '=',
        filter: '='
      },
      templateUrl: 'dc/line/template.html',
      link: function($scope, element, attrs) {
        var _this = this;
        $scope.chartId = attrs.id ? attrs.id : 'dcLineDefault';
        $scope.height = attrs.height ? attrs.height : 150;
        $scope.dcLineChart = dc.lineChart('#' + $scope.chartId);
        $scope.$watch('data', function(data) {
          if (data) {
            $scope.chartData = data;
            $scope.create();
          }
        });
        $scope.$watch('filter', function(filter) {
          if (filter) {
            return $scope.setFilter(filter.dimension, filter.value);
          }
        }, true);
        $scope.setFilter = function(dimension, value) {
          var newDim, totalSum;
          newDim = $scope.chartData.dimension(function(d) {
            return d['DATETIME:date'];
          });
          totalSum = newDim.group().reduceSum(function(d) {
            console.log(dimension);
            return d[dimension];
          });
          $scope.dcLineChart.group(totalSum).yAxisLabel(dimension).filter(value);
          return $scope.dcLineChart.redraw();
        };
        $scope.create = function() {
          var dimensions, maxDate, minDate, totalSum;
          dimensions = $scope.chartData.dimension(function(d) {
            return d['DATETIME:date'];
          });
          totalSum = dimensions.group().reduceSum(function(d) {
            return d['MEASURE:Customer Price'];
          });
          minDate = dimensions.bottom(1)[0]['DATETIME:date'];
          maxDate = dimensions.top(1)[0]['DATETIME:date'];
          $scope.dcLineChart.width(element.width()).height($scope.height).margins({
            top: 10,
            left: 50,
            right: 10,
            bottom: 50
          }).dimension(dimensions).group(totalSum, "Price").x(d3.time.scale().domain([minDate, maxDate])).yAxisLabel("Customer Price").xAxisLabel("Date").renderArea(true).elasticY(true).elasticX(true);
          $scope.dcLineChart.render();
        };
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=dc-line.map
*/

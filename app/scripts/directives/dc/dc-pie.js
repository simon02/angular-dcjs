// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  angular.module('dcPie', []).directive("dcPie", function() {
    if (!dc || !d3 || !crossfilter || !_) {
      throw 'You need to load DC, D3, Crossfilter and Underscore library';
    }
    return {
      scope: {
        data: '=',
        dimensions: '='
      },
      transclude: true,
      templateUrl: 'dc/pie/template.html',
      link: function($scope, element, attrs) {
        var _this = this;
        $scope.chartId = attrs.id ? attrs.id : 'dcPieDefault';
        $scope.height = attrs.height ? attrs.height : 150;
        $scope.$watch('data', function(data) {
          if (data) {
            $scope.chartData = angular.copy(data);
            $scope.dcPieChart = dc.pieChart('#' + $scope.chartId);
            $scope.create();
          }
        });
        $scope.create = function() {
          var dateDimensions, groups, totalSum;
          $scope.chartData.forEach(function(d) {
            d['datePieParam'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date']);
          });
          groups = crossfilter($scope.chartData);
          dateDimensions = groups.dimension(function(d) {
            return d['DIMENSION:Asset/Content Flavor'];
          });
          totalSum = dateDimensions.group().reduceSum(function(d) {
            return d['MEASURE:Customer Price'];
          });
          $scope.dcPieChart.width(element.width()).height($scope.height).dimension(dateDimensions).group(totalSum);
          $scope.dcPieChart.render();
        };
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=dc-pie.map
*/
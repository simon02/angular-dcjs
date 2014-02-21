// Generated by CoffeeScript 1.6.3
(function() {
  var _this = this;

  angular.module('angularDcjsApp').controller('MainController', [
    '$scope', '$filter', '$log', 'Debug', 'dataAPI', function($scope, $filter, $log, Debug, dataAPI) {
      $scope.measures = [];
      $scope.dimensions = [];
      $scope.datetime = [];
      $scope.gridsterOpts = {
        margins: [20, 20],
        draggable: {
          enabled: true
        },
        resizable: {
          enabled: false
        }
      };
      $scope.customItems = [
        {
          sizeX: 2,
          sizeY: 2,
          row: 0,
          col: 0
        }, {
          sizeX: 2,
          sizeY: 2,
          row: 0,
          col: 2
        }, {
          sizeX: 2,
          sizeY: 2,
          row: 0,
          col: 4
        }
      ];
      $scope.getLog = function() {
        return Debug.output();
      };
      $scope.checkFilter = function(rows) {
        return rows.length > 0;
      };
      $scope.render = function() {
        if ($scope.include) {
          if ($scope.checkFilter($filter('filter')($scope.sourceData, $scope.include))) {
            $scope.rows = crossfilter($filter('filter')($scope.sourceData, $scope.include));
          } else {
            $log.warn("No content Found");
            return false;
          }
        } else {
          $scope.rows = crossfilter($scope.sourceData);
        }
        $scope.lineChartDim = $scope.rows.dimension(function(d) {
          return d['DATETIME:date'];
        });
        $scope.composeChartDim = $scope.rows.dimension(function(d) {
          return d['DATETIME:date'];
        });
        $scope.pieChartDim = $scope.rows.dimension(function(d) {
          return d['DIMENSION:Asset/Content Flavor'];
        });
        return $scope.setChartDim();
      };
      $scope.retrieveData = function() {
        dataAPI.getData().then(function(response) {
          if (response.data) {
            response.data.forEach(function(d) {
              d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date']);
            });
            $scope.sourceData = response.data;
            $scope.identifyHeaders($scope.sourceData);
            $scope.render();
          }
        });
      };
      $scope.identifyHeaders = function(data) {
        $scope.getParams(data, 'Datetime');
        $scope.getParams(data, 'Dimension');
        return $scope.getParams(data, 'Measure');
      };
      $scope.setChartDim = function() {
        $scope.composeChartOpts = {
          data: $scope.rows,
          dimension: $scope.composeChartDim,
          sum: {
            title: ["HD", "SD"],
            object: $scope.composeChartDim.group().reduce(function(p, v) {
              if (v['DIMENSION:Asset/Content Flavor'] === 'HD') {
                p.HD += +v['MEASURE:Customer Price'];
              }
              if (v['DIMENSION:Asset/Content Flavor'] === 'SD') {
                p.SD += +v['MEASURE:Customer Price'];
              }
              return p;
            }, function(p, v) {
              if (v['DIMENSION:Asset/Content Flavor'] === 'HD') {
                p.HD -= +v['MEASURE:Customer Price'];
              }
              if (v['DIMENSION:Asset/Content Flavor'] === 'SD') {
                p.SD -= +v['MEASURE:Customer Price'];
              }
              return p;
            }, function() {
              return {
                HD: 0,
                SD: 0
              };
            })
          },
          min: $scope.composeChartDim.bottom(1)[0]['DATETIME:date'],
          max: $scope.composeChartDim.top(1)[0]['DATETIME:date']
        };
        $scope.lineChartOpts = {
          data: $scope.rows,
          dimension: $scope.lineChartDim,
          sum: $scope.lineChartDim.group().reduceSum(function(d) {
            return d['MEASURE:Customer Price'];
          }),
          min: $scope.lineChartDim.bottom(1)[0]['DATETIME:date'],
          max: $scope.lineChartDim.top(1)[0]['DATETIME:date']
        };
        return $scope.pieChartOpts = {
          data: $scope.rows,
          dimension: $scope.pieChartDim,
          sum: $scope.pieChartDim.group().reduceSum(function(d) {
            return d['MEASURE:Customer Price'];
          })
        };
      };
      $scope.getParams = function(data, index) {
        var items, pattern;
        if (data && index) {
          items = [];
          pattern = new RegExp(index.toUpperCase() + ':(.*)');
          angular.forEach(data[0], function(value, key) {
            var input;
            input = key.match(pattern);
            if (input) {
              return items.push(input[1]);
            }
          });
          if (items.length > 0) {
            $scope[index] = items;
            return Debug.input({
              name: index,
              'items': items
            });
          }
        }
      };
      $scope.retrieveData();
      $scope.generateDimensions = function() {
        return angular.forEach($scope.Dimension, function(value, key) {
          var dimensions;
          dimensions = $scope.rows.dimension(function(d) {
            return d['DIMENSION:' + value];
          });
          return angular.forEach(dimensions.group().all(), function(value2, key2) {
            return $scope.filterSource.push('DIMENSION:' + value + ':' + value2.key);
          });
        });
      };
      $scope.generateMeasures = function() {
        return angular.forEach($scope.Measure, function(value, key) {
          var dimensions;
          dimensions = $scope.rows.dimension(function(d) {
            return d['MEASURE:' + value];
          });
          return angular.forEach(dimensions.group().all(), function(value2, key2) {
            return $scope.filterSource.push('MEASURE:' + value + ':' + value2.key);
          });
        });
      };
      $scope.generateDatetime = function() {
        return angular.forEach($scope.Datetime, function(value, key) {
          var dimensions;
          dimensions = $scope.rows.dimension(function(d) {
            return d['DATETIME:' + value];
          });
          return angular.forEach(dimensions.group().all(), function(value2, key2) {
            return $scope.filterSource.push('DATETIME:' + value + ':' + value2.key.toUTCString());
          });
        });
      };
      $scope.$watch('include', function(include) {
        return $scope.render();
      });
    }
  ]);

}).call(this);

/*
//@ sourceMappingURL=main.map
*/

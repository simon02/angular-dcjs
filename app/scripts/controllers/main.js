// Generated by CoffeeScript 1.6.3
(function() {
  var _this = this;

  angular.module('angularDcjsApp').controller('MainController', [
    '$rootScope', '$scope', '$filter', '$log', 'Debug', 'dataAPI', function($rootScope, $scope, $filter, $log, Debug, dataAPI) {
      $scope.filterSearch = [];
      $scope.include = {};
      $scope.setScreenData = function() {
        if ($scope.screen) {
          angular.forEach($scope.screen.gridster.blocks, function(v) {
            v = $scope.createStructure(v);
          });
        }
      };
      $scope.getScreenParams = function() {
        dataAPI.getScreenParams().then(function(response) {
          $scope.screen = response.data;
          return $scope.setScreenData();
        });
      };
      $scope.createStructure = function(item) {
        var obj;
        if (item.type === 'dc-pie') {
          if (item.indexBy.dimension !== null && item.indexBy.sum !== null) {
            item.dimension = $scope.rows.dimension(function(d) {
              return d[item.indexBy.dimension];
            });
            item.sum = item.dimension.group().reduceSum(function(d) {
              return d[item.indexBy.sum];
            });
          }
        }
        if (item.type === 'dc-line') {
          if (item.indexBy.dimension !== null && item.indexBy.sum !== null) {
            item.dimension = $scope.rows.dimension(function(d) {
              return d[item.indexBy.dimension];
            });
            item.sum = item.dimension.group().reduceSum(function(d) {
              return d[item.indexBy.sum];
            });
            item.min = item.dimension.bottom(1)[0][item.indexBy.dimension];
            item.max = item.dimension.top(1)[0][item.indexBy.dimension];
          }
        }
        if (item.type === 'dc-compose') {
          if (item.indexBy.dimension !== null && item.indexBy.sum !== null) {
            item.dimension = $scope.rows.dimension(function(d) {
              return d[item.indexBy.dimension];
            });
            item.measure = item.dimension.group().reduceSum(function(d) {
              return d[item.indexBy.measure];
            });
            obj = [];
            angular.forEach(item.values, function(value) {
              var group;
              group = {};
              group.title = value;
              group.object = item.dimension.group().reduceSum(function(d) {
                if (d[item.indexBy.sum] === value) {
                  return d[item.indexBy.measure];
                } else {
                  return 0;
                }
              });
              return obj.push(group);
            });
            item.sum = {
              title: item.stack,
              objects: obj
            };
            item.min = item.dimension.bottom(1)[0][item.indexBy.dimension];
            item.max = item.dimension.top(1)[0][item.indexBy.dimension];
          }
        }
        if (item.type === 'pivot') {
          /* TODO: try to find another solution for filtering*/

          item.dimension = $scope.rows.dimension(function(d) {
            return d[item.indexBy.dimension];
          });
          item.data = $scope.sourceData;
        }
        if (item.update) {
          item.update();
        }
        return item;
      };
      $scope.retrieveData = function() {
        dataAPI.getData().then(function(response) {
          if (response.data) {
            response.data.forEach(function(d) {
              d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date']);
            });
            $scope.sourceData = response.data;
            $scope.getScreenParams();
            $scope.identifyHeaders($scope.sourceData);
            $scope.render();
          }
        });
      };
      $scope.setFilters = function() {
        var filter;
        filter = $filter('filter')($scope.sourceData, $scope.filter);
        if (filter.length > 0) {
          return $scope.rows = crossfilter(filter);
        } else {
          $log.info("Result not found");
          return $scope.rows = crossfilter($scope.sourceData);
        }
      };
      $scope.getLog = function() {
        return Debug.output();
      };
      $scope.checkFilter = function(rows) {
        return rows.length > 0;
      };
      $scope.render = function() {
        $scope.setFilters();
        $scope.setScreenData();
      };
      $scope.identifyHeaders = function(data) {
        $scope.getParams(data, 'Datetime');
        $scope.getParams(data, 'Dimension');
        return $scope.getParams(data, 'Measure');
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
            $scope.setFilterSearch(items, index.toUpperCase());
            $scope[index] = items;
            return Debug.input({
              name: index,
              'items': items
            });
          }
        }
      };
      $scope.setFilterSearch = function(items, index) {
        return items.forEach(function(item) {
          return $scope.filterSearch.push(index + ':' + item);
        });
      };
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
      $scope.$watch('include', function(include, oldInclude) {
        if (include.type) {
          if (include.type !== oldInclude.type) {
            include.text = "";
          }
          $scope.filter = {};
          $scope.filter[include.type] = include.text ? include.text : "";
          return $scope.render();
        }
      }, true);
      $scope.retrieveData();
    }
  ]);

}).call(this);

/*
//@ sourceMappingURL=main.map
*/

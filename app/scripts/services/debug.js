// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  angular.module('angularDcjsApp').service('Debug', function() {
    this.message = [];
    this.output = function() {
      return this.message;
    };
    this.input = function(message) {
      this.message.push(message);
    };
    this.clear = function() {
      this.message = [];
    };
  });

}).call(this);

/*
//@ sourceMappingURL=debug.map
*/

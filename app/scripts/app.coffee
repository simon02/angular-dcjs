"use strict"

angular.module('angularDcjsApp', ['ngRoute', 'gridster', 'dcModule'])

.config ($routeProvider)->
  $routeProvider
  .when("/", controller:'MainController', templateUrl:'views/main.html')
  .otherwise(redirectTo: "/")
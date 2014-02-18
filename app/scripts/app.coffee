"use strict"

angular.module('angularDcjsApp', ['ngRoute', 'gridster', 'dcModule','ui.select2'])

.config ($routeProvider)->
  $routeProvider
  .when("/", controller:'MainController', templateUrl:'views/main.html')
  .otherwise(redirectTo: "/")
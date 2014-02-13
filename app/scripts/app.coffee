"use strict"

angular.module('angularDcjsApp', ['ngRoute'])

.config ($routeProvider)->
  $routeProvider
  .when("/", controller:'MainController', templateUrl:'views/main.html')
  .otherwise(redirectTo: "/")
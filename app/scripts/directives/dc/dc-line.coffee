"use strict"

angular.module('dcModule',['dcModule.templates']).

directive "dcLine", ->
  if not dc or not d3 or not crossfilter or not _
    throw 'You need to load DC, D3, Crossfilter and Underscore library'
  scope:
    data: '='
  transclude: true
  templateUrl: 'dc/line/template.html'
  controller: ()->

  link: (scope, element, attrs, controller)->

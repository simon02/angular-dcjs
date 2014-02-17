"use strict"

angular.module('angularDcjsApp').

service "dataAPI", ($http, $q)->
  @getData = ->
    return $http.get('sampledata2.json')
  return
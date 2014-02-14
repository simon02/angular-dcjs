"use strict"

angular.module('angularDcjsApp').

service "dataAPI", ($http, $q)->
  @getData = ->
    return $http.get('sampledata.json')
  return
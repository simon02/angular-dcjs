"use strict"

angular.module('angularDcjsApp').

service "dataAPI", ($http, $q)->
  @getData = ->
    # return $http.get('sampledata2.json')
    return $http.get('sampledata.json')

  @getScreenParams = ->
    return $http.get('screen.json')
  return

"use strict"

angular.module('angularDcjsApp').

service 'Debug', ()->
  @message = []

  @output = ->
    @message

  @input = (message)->
    @message.push message
    return

  @clear= ()->
    @message = []
    return
  return
"use strict"

Debug = ->
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

describe "Service: Debug", ()->

  beforeEach(()->
    module('angularDcjsApp')
  )

  it "should be an instance of Debug", ()->
    expect(Debug).toBe instanceof Debug

  it "should have no messages", ()->
    debug = new Debug()
    expect(debug.output().length).toEqual 0

  it "should have input a message", ()->
    debug = new Debug()
    debug.input('Test')
    expect(debug.output().length).toEqual 1

  it "should have input a message and clear", ()->
    debug = new Debug()
    debug.input('Test')
    expect(debug.output().length).toEqual 1
    debug.clear()
    expect(debug.output().length).toEqual 0
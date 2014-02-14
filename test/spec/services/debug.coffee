"use strict"

describe "Service: Debug", ()->

  Debug = undefined

  beforeEach(()->
    module('angularDcjsApp')
  )

  beforeEach(inject((_Debug_)->
    Debug = _Debug_
    )
  )

  it "should have no messages", ()->
    expect(Debug.output().length).toEqual 0

  it "should have input a message", ()->
    Debug.input('Test')
    expect(Debug.output().length).toEqual 1

  it "should have input a message and clear", ()->
    Debug.input('Test')
    expect(Debug.output().length).toEqual 1
    Debug.clear()
    expect(Debug.output().length).toEqual 0
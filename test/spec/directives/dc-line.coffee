"use strict"

describe "Directive: Dc", ()->

  scope = undefined
  element = undefined
  attrs = undefined
  controller = undefined


  beforeEach(()->
    module('dcModule.templates')
    return
  )
  beforeEach(()->
    module('dcModule')
    return
  )

  beforeEach(inject(($rootScope)->
      scope = $rootScope.$new()
      return
    )
  )

  it "should start directive",inject(($compile)->
    element = angular.element('<div dc-line data="rows"></div>');
    element = $compile(element)(scope);
    expect(element.html()).not.toBeNull
  )

  it "should load data from scope", ()->
    expect(scope.data).toBeNull

  it "should change scope data and get an array", ()->
    scope.data = [
      ["DATETIME:date", "MEASURE: Units", "MEASURE: Royalty Price", "MEASURE: Customer Price", "DIMENSION:Vendor Identifier", "DIMENSION:Title", "DIMENSION:Label/Studio/Network", "DIMENSION:Product Type Identifier", "DIMENSION: Order Id", "DIMENSION:Postal Code", "DIMENSION: Customer Identifier", "DIMENSION:Sale/Return", "DIMENSION:Customer Currency", "DIMENSION:Country Code", "DIMENSION:Royalty Currency", "DIMENSION:Asset/Content Flavor"],
      ["9/27/13", 1, 3.49, 4.99, "0144_20121109", "Headh", "Yello", "D", "5.02E+09", "49915-2504", 2240000173, "S", "USD", "CL", "USD", "HD"],
      ["9/24/13", 1, 1.39, 1.99, "0099_20120827", "A Ond", "Const", "D", "2.03E+09", "29284-3466", 1642627348, "S", "USD", "BR", "USD", "SD"],
    ]
    expect(scope.data).toEqual jasmine.any(Array)
    expect(scope.data.length).toBe > 0

  it "should have D3 library", ()->
    expect(d3).not.toBeNull

  it "should have DC library", ()->
  expect(dc).not.toBeNull

  it "should have CrossFilter library", ()->
    expect(dc).not.toBeNull

  it "should have Underscore library", ()->
    expect(_).not.toBeNull
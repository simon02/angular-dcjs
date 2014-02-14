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
    element = angular.element('<div id="#dcLine" dc-line data="rows"></div>');
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
      ["9/24/13", 1, 1.39, 1.99, "0099_20120827", "A Ond", "Const", "D", "2.03E+09", "29284-3466", 1642627348, "S", "USD", "BR", "USD", "SD"],
      ["9/29/13", 1, 3.49, 4.99, "0144_20121109", "Headh", "Yello", "D", "5.70E+09", "26586-2424", 4967191007, "S", "USD", "CO", "USD", "HD"],
      ["9/28/13", 1, 2.79, 3.99, "0144_20121109", "Headh", "Yello", "D", "3.05E+09", "23322-2800", 3573922889, "S", "USD", "CL", "USD", "SD"],
      ["9/23/13", 1, 2.09, 2.99, "0211_20132108", "AlÌ©m", "Wakin", "D", "4.34E+09", "18509-2108", 4368359068, "S", "USD", "BR", "USD", "HD"],
      ["9/28/13", 1, 1.39, 1.99, "0145_20121109", "Habem", "Sache", "D", "3.77E+09", "16346-1910", 4481458708, "S", "USD", "BR", "USD", "SD"],
      ["9/26/13", 1, 2.99, 4.99, "0183_20130110", "O Ama", "2012 ", "D", "4.48E+09", "20425-2908", 1380109825, "S", "USD", "BR", "USD", "HD"],
      ["9/28/13", 1, 3.49, 4.99, "0212_20132108", "Foxfi", "Canal", "D", "1.08E+09", "41459-2577", 2801029109, "S", "USD", "BR", "USD", "HD"],
      ["9/27/13", 1, 1.4, 1.99, "0131_20121024", "Galin", "Brome", "M", "3.44E+09", "21878-4828", 3172794428, "S", "USD", "BR", "USD", "SD"],
      ["9/26/13", 1, 7, 9.99, "0043_20120702", "Pina", "Neue ", "M", "5.30E+09", "47489-2273", 2807609767, "S", "USD", "BR", "USD", "HD"],
      ["9/24/13", 1, 35, 50, "0144_20121109", "Headh", "Yello", "D", "4.94E+09", "37945-1054", 5076310037, "S", "MXN", "MX", "MXN", "HD"]
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

  it "should input lineChart into the element", ()->
    dcLine = dc.lineChart('#dcLine')
    expect(dcLine).not.toBeNull
    dcLine.renderArea()
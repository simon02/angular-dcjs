"use strict"

describe "Directive: Dc-Pie", ()->

  scope = undefined
  element = undefined
  data = undefined
  dataResponse = undefined
  dimension = undefined
  measure = undefined

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
    dataResponse = [
      {"DATETIME:date":"9/27/13","MEASURE:Units":1,"MEASURE:Royalty Price":3.49,"MEASURE:Customer Price":4.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"5.02E+09","DIMENSION:Postal Code":"49915-2504","DIMENSION:Customer Identifier":2240000173,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CL","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
      {"DATETIME:date":"9/24/13","MEASURE:Units":1,"MEASURE:Royalty Price":1.39,"MEASURE:Customer Price":1.99,"DIMENSION:Vendor Identifier":"0099_20120827","DIMENSION:Title":"A Ond","DIMENSION:Label/Studio/Network":"Const","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"2.03E+09","DIMENSION:Postal Code":"29284-3466","DIMENSION:Customer Identifier":1642627348,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"},
      {"DATETIME:date":"9/29/13","MEASURE:Units":1,"MEASURE:Royalty Price":3.49,"MEASURE:Customer Price":4.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"5.70E+09","DIMENSION:Postal Code":"26586-2424","DIMENSION:Customer Identifier":4967191007,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CO","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
      {"DATETIME:date":"9/28/13","MEASURE:Units":1,"MEASURE:Royalty Price":2.79,"MEASURE:Customer Price":3.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"3.05E+09","DIMENSION:Postal Code":"23322-2800","DIMENSION:Customer Identifier":3573922889,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CL","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"},
      {"DATETIME:date":"9/23/13","MEASURE:Units":1,"MEASURE:Royalty Price":2.09,"MEASURE:Customer Price":2.99,"DIMENSION:Vendor Identifier":"0211_20132108","DIMENSION:Title":"AlÃŒÂ©m","DIMENSION:Label/Studio/Network":"Wakin","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"4.34E+09","DIMENSION:Postal Code":"18509-2108","DIMENSION:Customer Identifier":4368359068,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
      {"DATETIME:date":"9/28/13","MEASURE:Units":1,"MEASURE:Royalty Price":1.39,"MEASURE:Customer Price":1.99,"DIMENSION:Vendor Identifier":"0145_20121109","DIMENSION:Title":"Habem","DIMENSION:Label/Studio/Network":"Sache","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"3.77E+09","DIMENSION:Postal Code":"16346-1910","DIMENSION:Customer Identifier":4481458708,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"}
    ]
    data = crossfilter(dataResponse)
    dimension = data.dimension((d)->
      return d['DIMENSION:Title']
    )
    measure = dimension.group().reduceSum((d)->
      return d['MEASURE:Customer Price']
    )
    scope.dcPie = {
      dimensions: dimension
      sum: measure
    }
    scope.setMetrics = ()->
      return
    scope.create = ()->
      return
    return
    )
  )

  it "should start directive",inject(($compile)->
    element = angular.element('<div id="#dcPie" dc-pie="dcPie"></div>');
    element = $compile(element)(scope);
    expect(element.html()).not.toBeNull
  )

  it "should have D3 library", ()->
    expect(d3).not.toBeNull

  it "should have DC library", ()->
  expect(dc).not.toBeNull

  it "should have CrossFilter library", ()->
    expect(dc).not.toBeNull

  it "should have Underscore library", ()->
    expect(_).not.toBeNull

  it "should input pieChart into the element", ()->
    scope.dcPieChart = dc.pieChart('#dcPie')
    expect(scope.dcPieChart).not.toBeNull

  it "should load measures from scope", ()->
    expect(scope.measures).toBeNull

  it "should load dimensions from scope", ()->
    expect(scope.dimensions).toBeNull

  it "should change scope dcPie and get an Object", ()->
    expect(scope.dcPie).toEqual jasmine.any(Object)

  it "should call create method", ()->
    spyOn(scope,'create').andCallThrough()
    scope.create()
    scope.dcPieChart = dc.pieChart('#dcPie')
    expect(scope.dcPieChart.dimension).not.toBeNull
    expect(scope.dcPieChart.sum).not.toBeNull

    scope.dcPieChart.
      dimension(scope.dcPie.dimension).
      group(scope.dcPie.sum)

    expect(scope.create).toHaveBeenCalled()

  it "should call setMetrics method", ()->
    spyOn(scope,'setMetrics').andCallThrough()
    scope.setMetrics()
    expect(scope.setMetrics).toHaveBeenCalled()
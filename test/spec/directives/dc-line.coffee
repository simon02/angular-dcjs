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
      scope.data = [
        {"DATETIME:date":"9/27/13","MEASURE:Units":1,"MEASURE:Royalty Price":3.49,"MEASURE:Customer Price":4.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"5.02E+09","DIMENSION:Postal Code":"49915-2504","DIMENSION:Customer Identifier":2240000173,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CL","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
        {"DATETIME:date":"9/24/13","MEASURE:Units":1,"MEASURE:Royalty Price":1.39,"MEASURE:Customer Price":1.99,"DIMENSION:Vendor Identifier":"0099_20120827","DIMENSION:Title":"A Ond","DIMENSION:Label/Studio/Network":"Const","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"2.03E+09","DIMENSION:Postal Code":"29284-3466","DIMENSION:Customer Identifier":1642627348,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"},
        {"DATETIME:date":"9/29/13","MEASURE:Units":1,"MEASURE:Royalty Price":3.49,"MEASURE:Customer Price":4.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"5.70E+09","DIMENSION:Postal Code":"26586-2424","DIMENSION:Customer Identifier":4967191007,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CO","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
        {"DATETIME:date":"9/28/13","MEASURE:Units":1,"MEASURE:Royalty Price":2.79,"MEASURE:Customer Price":3.99,"DIMENSION:Vendor Identifier":"0144_20121109","DIMENSION:Title":"Headh","DIMENSION:Label/Studio/Network":"Yello","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"3.05E+09","DIMENSION:Postal Code":"23322-2800","DIMENSION:Customer Identifier":3573922889,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"CL","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"},
        {"DATETIME:date":"9/23/13","MEASURE:Units":1,"MEASURE:Royalty Price":2.09,"MEASURE:Customer Price":2.99,"DIMENSION:Vendor Identifier":"0211_20132108","DIMENSION:Title":"AlÃŒÂ©m","DIMENSION:Label/Studio/Network":"Wakin","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"4.34E+09","DIMENSION:Postal Code":"18509-2108","DIMENSION:Customer Identifier":4368359068,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"HD"},
        {"DATETIME:date":"9/28/13","MEASURE:Units":1,"MEASURE:Royalty Price":1.39,"MEASURE:Customer Price":1.99,"DIMENSION:Vendor Identifier":"0145_20121109","DIMENSION:Title":"Habem","DIMENSION:Label/Studio/Network":"Sache","DIMENSION:Product Type Identifier":"D","DIMENSION:Order Id":"3.77E+09","DIMENSION:Postal Code":"16346-1910","DIMENSION:Customer Identifier":4481458708,"DIMENSION:Sale/Return":"S","DIMENSION:Customer Currency":"USD","DIMENSION:Country Code":"BR","DIMENSION:Royalty Currency":"USD","DIMENSION:Asset/Content Flavor":"SD"}
      ]
      scope.create = ()->
        return
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
    scope.dcLineChart = dc.lineChart('#dcLine')
    expect(scope.dcLineChart).not.toBeNull

  it "should call create method", ()->
    spyOn(scope,'create').andCallThrough()
    scope.create()
    expect(scope.create).toHaveBeenCalled()

  it "should populate groups with crossfilter, should populate dateDimensions with groups agrupment of date and render", ()->
    scope.dcLineChart = dc.lineChart('#dcLine')
    groups = crossfilter(scope.data)
    expect(groups).not.toBeNull
    dateDimensions = groups.dimension((d)->
      return d['DATETIME:date']
    )
    expect(dateDimensions).not.toBeNull

    totalSum = dateDimensions.group().reduceSum((d)->
      return d['MEASURE:Customer Price']
    )
    expect(totalSum).not.toBeNull

    minDate = dateDimensions.bottom(1)[0].date
    maxDate = dateDimensions.top(1)[0].date

    expect(minDate).not.toBeNull
    expect(maxDate).not.toBeNull

    scope.dcLineChart.
      width(750).
      height(200).
      dimension(dateDimensions).
      group(totalSum).
      x(d3.time.scale().domain([new Date(minDate), new Date(maxDate)])).
      yAxisLabel("Total").
      xAxisLabel("Data")

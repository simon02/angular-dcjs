"use strict"

describe "Services: dataAPI", ()->
  dataAPI = undefined
  $httpBackend = undefined
  beforeEach(()->
    module('angularDcjsApp')
  )

  beforeEach(inject(($injector, _dataAPI_, _$httpBackend_)->
      dataAPI = _dataAPI_
      $httpBackend = _$httpBackend_
    )
  )
  it "should call getData", ()->
    $httpBackend.expectGET('/sampledata.json').respond(200, [
      ["DATETIME:date", "MEASURE: Units", "MEASURE: Royalty Price", "MEASURE: Customer Price", "DIMENSION:Vendor Identifier", "DIMENSION:Title", "DIMENSION:Label/Studio/Network", "DIMENSION:Product Type Identifier", "DIMENSION: Order Id", "DIMENSION:Postal Code", "DIMENSION: Customer Identifier", "DIMENSION:Sale/Return", "DIMENSION:Customer Currency", "DIMENSION:Country Code", "DIMENSION:Royalty Currency", "DIMENSION:Asset/Content Flavor"],
      ["9/27/13", 1, 3.49, 4.99, "0144_20121109", "Headh", "Yello", "D", "5.02E+09", "49915-2504", 2240000173, "S", "USD", "CL", "USD", "HD"],
      ["9/24/13", 1, 1.39, 1.99, "0099_20120827", "A Ond", "Const", "D", "2.03E+09", "29284-3466", 1642627348, "S", "USD", "BR", "USD", "SD"],
    ])
    data = dataAPI.getData()

    expect(data).not.toBe(null);
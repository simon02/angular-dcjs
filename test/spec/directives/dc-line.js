// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  describe("Directive: Dc", function() {
    var attrs, controller, element, scope;
    scope = void 0;
    element = void 0;
    attrs = void 0;
    controller = void 0;
    beforeEach(function() {
      module('dcModule.templates');
    });
    beforeEach(function() {
      module('dcModule');
    });
    beforeEach(inject(function($rootScope) {
      scope = $rootScope.$new();
    }));
    it("should start directive", inject(function($compile) {
      element = angular.element('<div dc-line data="rows"></div>');
      element = $compile(element)(scope);
      return expect(element.html()).not.toBeNull;
    }));
    it("should load data from scope", function() {
      return expect(scope.data).toBeNull;
    });
    it("should change scope data and get an array", function() {
      scope.data = [["DATETIME:date", "MEASURE: Units", "MEASURE: Royalty Price", "MEASURE: Customer Price", "DIMENSION:Vendor Identifier", "DIMENSION:Title", "DIMENSION:Label/Studio/Network", "DIMENSION:Product Type Identifier", "DIMENSION: Order Id", "DIMENSION:Postal Code", "DIMENSION: Customer Identifier", "DIMENSION:Sale/Return", "DIMENSION:Customer Currency", "DIMENSION:Country Code", "DIMENSION:Royalty Currency", "DIMENSION:Asset/Content Flavor"], ["9/27/13", 1, 3.49, 4.99, "0144_20121109", "Headh", "Yello", "D", "5.02E+09", "49915-2504", 2240000173, "S", "USD", "CL", "USD", "HD"], ["9/24/13", 1, 1.39, 1.99, "0099_20120827", "A Ond", "Const", "D", "2.03E+09", "29284-3466", 1642627348, "S", "USD", "BR", "USD", "SD"]];
      expect(scope.data).toEqual(jasmine.any(Array));
      return expect(scope.data.length).toBe > 0;
    });
    it("should have D3 library", function() {
      return expect(d3).not.toBeNull;
    });
    it("should have DC library", function() {});
    expect(dc).not.toBeNull;
    it("should have CrossFilter library", function() {
      return expect(dc).not.toBeNull;
    });
    return it("should have Underscore library", function() {
      return expect(_).not.toBeNull;
    });
  });

}).call(this);

/*
//@ sourceMappingURL=dc-line.map
*/

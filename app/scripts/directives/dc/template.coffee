"use strict"

angular.module('dcModule.templates',[]).
run(($templateCache)->
  $templateCache.put "dc/line/template.html",
    "<div>"+
    "<h4>Line Chart</h4>"+
    "<div class='line-chart'>"+
    "<ul>"+
    "<li ng-repeat='item in data' ng-bind='item | json'></li>"+
    "</ul>"+
    "</div>"+
    "</div>"

  return
)
"use strict"

angular.module('dcModule.templates',[]).
run(($templateCache)->
  $templateCache.put "dc/line/template.html",
    "<div>"+
    "<h4>Line Chart</h4>"+
    "<div id='dcLine' class='line-chart'>"+
    "{{groups | json}}"+
    "</div>"+
    "</div>"

  return
)
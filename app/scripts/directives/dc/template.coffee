"use strict"

angular.module('dcModule.templates',[]).
run(($templateCache)->
  $templateCache.put "dc/line/template.html",
    "<div id='{{ chartId }}' class='line-chart'>"+
    "</div>"

  $templateCache.put "dc/pie/template.html",
    "<div id='{{ chartId }}' class='pie-chart'>"+
    "</div>"

  return
)
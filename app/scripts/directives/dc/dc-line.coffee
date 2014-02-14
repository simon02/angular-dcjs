"use strict"

angular.module('dcModule',['dcModule.templates']).

directive "dcLine", ($compile)->
  if not dc or not d3 or not crossfilter or not _
    throw 'You need to load DC, D3, Crossfilter and Underscore library'
  scope:
    data: '='
    dimensions: '='
  transclude: true
  templateUrl: 'dc/line/template.html'
  controller: ()->

  link: (scope, element, attrs, controller)->

    setGroups = ()->
      scope.groups = {}
      for item in scope.dimensions
        scope.groups[item] = []
      console.log scope.groups

    scope.$watch('data', (data)->
      if data
        data.dimension((d)->
          for item in scope.dimensions
            scope.groups[item].push(d[item])
          return
        )
        return
    )

    scope.$watch('dimensions',(data)->
      if data
        setGroups()
    )

    dcLine = dc.lineChart(element[0])
    dcLine
    .width(250)
    .height(250)
    .margins({top: 40, right: 50, bottom: 30, left: 60})
    .dimension(scope.groups)
    .group(crimeIncidentByYear, "Total by Year")
#    .valueAccessor((d)->
#      d.value.nonViolentCrimeAvg;
#    )
#    .stack(crimeIncidentByYear, "Violent Crime",
#      (d)->
#        return d.value.violentCrimeAvg
#    )
#    .x(d3.scale.linear().domain([1997, 2012]))
#    .renderHorizontalGridLines(true)
#    .centerBar(true)
#    .elasticY(true)
#    .brushOn(false)
#    .legend(dc.legend().x(250).y(10))
#    .title((d)->
#      return d.key
#      + "\nViolent crime per 100k population: " + Math.round(d.value.violentCrimeAvg)
#      + "\nNon-Violent crime per 100k population: " + Math.round(d.value.nonViolentCrimeAvg);
#    )
#    .xAxis().ticks(5).tickFormat(d3.format("d"))
#    $compile(element)(dcLine)


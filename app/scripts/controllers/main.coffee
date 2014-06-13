angular.module('angularDcjsApp').

controller('MainController', ['$rootScope','$scope','$filter','$log','Debug','dataAPI',
	($rootScope, $scope, $filter, $log, Debug, dataAPI)=>

		$scope.filterSearch = []
		$scope.include = {}

		$scope.setScreenData = ()->
			if $scope.screen
				angular.forEach($scope.screen.gridster.blocks, (v)->
					v = $scope.createStructure(v)
					return
				)
				return

		$scope.getScreenParams = ()->
			dataAPI.getScreenParams().then((response)->
				$scope.screen = response.data
				$scope.setScreenData()
			)
			return

		$scope.createStructure = (item)->
			if(item.type=='dc-pie')
				if(item.indexBy.dimension isnt null and item.indexBy.sum isnt null)

					item.dimension = $scope.rows.dimension((d)->
						return d[item.indexBy.dimension]
					)
					item.sum = item.dimension.group().reduceSum((d)->
						return d[item.indexBy.sum]
					)

			if(item.type=='dc-line')
				if(item.indexBy.dimension isnt null and item.indexBy.sum isnt null)
					item.dimension = $scope.rows.dimension((d)->
						return d[item.indexBy.dimension]
					)

					item.sum = item.dimension.group().reduceSum((d)->
						return d[item.indexBy.sum]
					)

					item.min = item.dimension.bottom(1)[0][item.indexBy.dimension]
					item.max = item.dimension.top(1)[0][item.indexBy.dimension]

			if(item.type=='dc-compose')
				if(item.indexBy.dimension isnt null and item.indexBy.sum isnt null)

					item.dimension = $scope.rows.dimension((d)->
						return d[item.indexBy.dimension]
					)

					item.measure= item.dimension.group().reduceSum((d)->
						return d[item.indexBy.measure]
					)

					obj = []
					angular.forEach(item.values, (value)->
						group = {}
						group.title = value
						group.object = item.dimension.group().reduceSum(
							(d)->
								if(d[item.indexBy.sum] == value)
									return d[item.indexBy.measure]
								else
									return 0
						)

						obj.push(group)
					)

					item.sum = {
						title: item.stack
						objects: obj
					}

					item.min = item.dimension.bottom(1)[0][item.indexBy.dimension]
					item.max = item.dimension.top(1)[0][item.indexBy.dimension]

			if(item.type=='pivot')

				### TODO: try to find another solution for filtering ###
				item.dimension = $scope.rows.dimension((d)->
					return d[item.indexBy.dimension]
				)
				item.data = $scope.sourceData

			if(item.update)
				item.update()

			return item


		$scope.retrieveData = ()->
			dataAPI.getData().then((response)->
				if response.data
					headers = _.first(response.data)
					reworkedData = _.map(_.rest(response.data), (d)->
						element = {}
						d.forEach((value, index) ->
							element[headers[index]] = value
						)
						element
					)
					#response.data.forEach((d)->
					#	d['DATETIME:date'] = d3.time.format("%m/%d/%Y").parse(d['DATETIME:date'])
					#	return
					#)

					# $scope.sourceData = response.data
					$scope.sourceData = reworkedData
					$scope.getScreenParams()
					$scope.identifyHeaders($scope.sourceData)
					$scope.render()
				return
			)
			return

		$scope.setFilters = ()->
			filter = $filter('filter')($scope.sourceData, $scope.filter)
			if filter.length > 0
				$scope.rows = crossfilter(filter)
			else
				$log.info("Result not found")
				$scope.rows = crossfilter($scope.sourceData)

		$scope.getLog = ()->
			return Debug.output()

		$scope.checkFilter = (rows)->
			return rows.length > 0

		$scope.render = ()->
			$scope.setFilters()
			$scope.setScreenData()
			return

		$scope.identifyHeaders = (data) =>
			$scope.getParams(data, 'Datetime')
			$scope.getParams(data, 'Dimension')
			$scope.getParams(data, 'Measure')

		$scope.getParams = (data, index)=>
			if data and index
				items = []
				pattern = new RegExp(index.toUpperCase() + ':(.*)')
				angular.forEach(data[0],(value, key)=>
					input = key.match(pattern)
					if input
						items.push(input[1])
				)
				if items.length > 0
					$scope.setFilterSearch(items, index.toUpperCase())
					$scope[index] = items

					Debug.input({
						name: index,
						'items': items
					})

		$scope.setFilterSearch = (items, index)->
			items.forEach((item)->
				$scope.filterSearch.push(index + ':' + item)
			)


		$scope.generateDimensions = ()->
			angular.forEach($scope.Dimension,(value, key)->
				dimensions = $scope.rows.dimension((d)->
					return d['DIMENSION:' + value]
				)
				angular.forEach(dimensions.group().all(),(value2,key2)->
					$scope.filterSource.push(
						'DIMENSION:' + value + ':' + value2.key
					)
				)
			)

		$scope.generateMeasures = ()->
			angular.forEach($scope.Measure,(value, key)->
				dimensions = $scope.rows.dimension((d)->
					return d['MEASURE:' + value]
				)
				angular.forEach(dimensions.group().all(),(value2,key2)->
					$scope.filterSource.push(
						'MEASURE:' + value + ':' + value2.key
					)
				)
			)

		$scope.generateDatetime= ()->
			angular.forEach($scope.Datetime,(value, key)->
				dimensions = $scope.rows.dimension((d)->
					return d['DATETIME:' + value]
				)
				angular.forEach(dimensions.group().all(),(value2,key2)->
					$scope.filterSource.push(
						'DATETIME:' + value + ':' + value2.key.toUTCString()
					)
				)
			)

		$scope.$watch('include', (include, oldInclude)->
			if include.type
				if include.type isnt oldInclude.type
					include.text = ""
				$scope.filter = {}
				$scope.filter[include.type] = if include.text then include.text else ""
				$scope.render()
		, true)

		$scope.retrieveData()

		return

])

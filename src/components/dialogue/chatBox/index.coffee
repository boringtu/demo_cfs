'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		list: []
	created: ->
		# 获取列表数据
		@fetchData()

	mounted: ->

	methods:
		# 获取数据
		fetchData: ->
			Utils.ajax ALPHA.API_PATH.dialogue.visitor
			.then (res) =>
				data = res.data
				now = +ALPHA.serverTime
				@list = data
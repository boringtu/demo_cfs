'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# view 对象
		view: @$parent
	created: ->
		# 获取列表数据
		@fetchData()
		# 开启计数器（每秒刷新一次
		@startCount()
	
	beforeDestroy: ->
		# 结束计数器
		@stopCount()

	computed:
		# 待接待访客列表
		list: -> @$store.state.visitorList

	filters:
		# 渠道图标
		channelIcon: (channel) ->
			tmp = 'icon-'
			switch channel
				when 1
					tmp + 'pc'
				when 0
					tmp + 'mobile'
		# 进入时间
		entryTime: (stamp) ->
			date = new Date stamp
			M = date.getMonth() + 1
			M = if (M + '').length > 1 then M else '0' + M
			d = date.getDate()
			d = if (d + '').length > 1 then d else '0' + d
			H = date.getHours()
			H = if (H + '').length > 1 then H else '0' + H
			m = date.getMinutes()
			m = if (m + '').length > 1 then m else '0' + m
			"#{ M }-#{ d } #{ H }:#{ m }"
		# 等待时间
		waitingTime: (time) ->
			m = time / 1000 / 60
			m = ~~m
			m = if (m + '').length > 1 then m else '0' + m
			s = time / 1000 % 60
			s = ~~s
			s = if (s + '').length > 1 then s else '0' + s
			"#{ m }分#{ s }秒"

	methods:
		# 获取数据
		fetchData: ->
			Utils.ajax ALPHA.API_PATH.dialogue.visitor
			.then (res) =>
				data = res.data
				now = +ALPHA.serverTime
				# 初始化等待时间
				item.conversation.waitingTime = now - item.conversation.addTime for item in data
				@$store.state.visitorList = data

		# 启动计数器（每秒刷新一次
		startCount: ->
			@handleCount = setInterval =>
				item.conversation.waitingTime += 1000 for item in @list
			, 1000

		# 结束计数器
		stopCount: ->
			clearInterval @handleCount

		# Event: 接待指定用户
		eventReceiveCustomer: (row) ->
			return if row.processing
			row.processing = 1
			id = row.id
			# 通知服务器要接待此用户
			@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.RECEIVING, id
'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# tab 标签当前下标
		tabIndex: 0
	created: ->
		# 获取数据
		@fetchChattingData()
		@fetchClosedData()

		# 初始化会话 ID（如果有
		@$store.state.dialogID = +@$route.params.id

	computed:
		# 正在进行中的会话列表
		chattingList: -> @$store.state.chattingList
		# 已关闭的会话列表
		closedList: -> @$store.state.closedList
		# 会话ID
		dialogID: -> @$store.state.dialogID

	filters:
		# 生成 chat 链接
		createChatRoute: (id) -> "/dialogue/#{ id }"
		# 渠道图标
		channelIcon: (channel) ->
			tmp = 'icon-'
			switch channel
				when 1
					tmp + 'pc'
				when 0
					tmp + 'mobile'
		# 格式化时间（用于最新消息的时钟和分钟
		formatTime: (stamp) ->
			date = new Date stamp
			H = date.getHours()
			H = if (H + '').length > 1 then H else '0' + H
			m = date.getMinutes()
			m = if (m + '').length > 1 then m else '0' + m
			"#{ H }:#{ m }"
		# 未读消息条数处理
		unreadCount: (n) ->
			return "#{ n }" if n < 100
			"99+"

	watch:
		chattingList: -> @resetDialogInfo()
		closedList: -> @resetDialogInfo()
		dialogID: -> @resetDialogInfo()

	methods:
		# 重置 dialog info object
		resetDialogInfo: ->
			info = null
			id = @dialogID
			if id
				# 先从正在进行中的会话列表中匹配
				for item in @chattingList when item.id is id
					info = item
					break
				# 如果在正在进行中的会话列表中没有匹配到，则再从已结束的会话列表中匹配
				unless info
					for item in @closedList when item.id is id
						info = item
						break
			@$store.state.dialogInfo = info
			console.log id, info

		# 获取正在进行中的会话列表
		fetchChattingData: ->
			Utils.ajax ALPHA.API_PATH.dialogue.chatting
			.then (res) =>
				data = res.data
				@$store.state.chattingList = data

		# 获取已结束的会话列表（目前不提供刷新功能，感觉没必要）
		fetchClosedData: ->
			count = @closedList.length
			params = count: count if count
			Utils.ajax ALPHA.API_PATH.dialogue.closed,
				params: params
			.then (res) =>
				data = res.data
				@$store.state.closedList = data

		# Event: mouseenter of tab title
		eventTabMouseEnter: (event) ->
			i = +event.currentTarget.parentNode.getAttribute 'data-index'
			target = @$refs.underline
			# 先写死，因为目前“对话列表”宽度是固定 428 的
			# 如果后期改宽度了，这里也要改
			# 如果后期改成自适应了，这里的逻辑也要改
			left = (428 / 2 - target.offsetWidth) / 2
			left += 428 / 2 if i
			target.style.left = "#{ left }px"

		# Event: mouseleave of tab title
		eventTabMouseLeave: (event) ->
			ulEl = event.currentTarget.parentNode.parentNode
			i = +ulEl.getElementsByClassName('active')[0].getAttribute 'data-index'
			target = @$refs.underline
			# 先写死，因为目前“对话列表”宽度是固定 428 的
			# 如果后期改宽度了，这里也要改
			# 如果后期改成自适应了，这里的逻辑也要改
			left = (428 / 2 - target.offsetWidth) / 2
			left += 428 / 2 if i
			target.style.left = "#{ left }px"
'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# tab 标签当前下标
		tabIndex: 0
		# 是否正在加载已结束对话的数据
		isLoadingClosedData: 0
		# 是否无更多已结束对话数据
		noMoreClosedData: 0
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
		formatTime: (message) ->
			return '' unless message
			stamp = message.timeStamp

			date = new Date stamp
			today = new Date()
			Y = date.getFullYear()
			Y = if (Y + '').length > 1 then Y else '0' + Y
			M = date.getMonth() + 1
			M = if (M + '').length > 1 then M else '0' + M
			d = date.getDate()
			d = if (d + '').length > 1 then d else '0' + d
			H = date.getHours()
			H = if (H + '').length > 1 then H else '0' + H
			m = date.getMinutes()
			m = if (m + '').length > 1 then m else '0' + m
			if today.getFullYear() isnt date.getFullYear()
				"#{ Y }-#{ M }-#{ d } #{ H }:#{ m }"
			else if today.getMonth() isnt date.getMonth() or today.getDate() isnt date.getDate()
				"#{ M }-#{ d } #{ H }:#{ m }"
			else
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

		# 获取正在进行中的会话列表
		fetchChattingData: ->
			Utils.ajax ALPHA.API_PATH.dialogue.chatting
			.then (res) =>
				data = res.data
				item.isChatting = 1 for item in data
				@$store.state.chattingList = data

		# 获取已结束的会话列表
		fetchClosedData: ->
			return if @isLoadingClosedData
			# 更改是否正在加载已结束回话的数据
			@isLoadingClosedData = 1
			count = @closedList.length
			params = count: count if count
			Utils.ajax ALPHA.API_PATH.dialogue.closed,
				params: params
			.then (res) =>
				data = res.data
				unless data.length
					# 更改是否正在加载已结束对话列表
					@isLoadingClosedData = 0
					# 无更多数据的状态
					@noMoreClosedData = 1
					return
				item.isChatting = 0 for item in data
				list = @$store.state.closedList
				@$store.state.closedList = [...list, ...data]
				# 更改是否正在加载已结束对话列表
				@isLoadingClosedData = 0

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

		# Event: 已结束对话列表滚动事件
		eventScrollClosed: ->
			return if @noMoreClosedData

			# 频率控制器
			return if @winScrollState
			@winScrollState = 1
			setTimeout (=> @winScrollState = 0), 20

			# win element
			win = @$refs.closedWindow
			# lines' wrapper
			wrap = @$refs.closedWrapper.$el
			# window's height
			wH = win.offsetHeight
			# window scrollTop
			sT = win.scrollTop
			# lines' total height
			tH = wrap.offsetHeight
			@fetchClosedData() if wH + sT > tH - 40
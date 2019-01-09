'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# view 对象
		view: @$parent
		# 输入的文本
		inputText: ''
		# 是否准备输入（输入框是否获取焦点）
		isReadyToType: 0
		# 是否正在加载历史数据的状态
		isLoadingHistory: 0
		# 是否需要确认结束当前对话
		confirmToClose: 0
		# 是否无更多历史消息的状态
		noMoreHistory: 0
		# 首屏消息条数
		msgInitCount: 5
		# 非首屏消息条数
		msgAppendCount: 5
		# 未读消息 element 引用列表（新消息在前）
		unreadElList: []
		# 新推送的未读消息 element 引用列表（顺序无所谓）
		newUnreadElList: []
		# 历史消息列表中第一条数据的timeStamp
		referTimeStamp: 0

	computed:
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo
		# 未读消息条数
		unreadCount: -> @unreadElList.length
		# 新推送的未读消息条数
		newUnreadCount: -> @newUnreadElList.length
		# 历史消息数据列表（新数据在后）
		chatHistoryList: -> @$store.state.chatHistoryList

	filters:
		# 历史消息区 消息 class 类名（区分己方/对方）
		sideClass: (side) ->
			switch side
				when 1
					'msg-self'
				when 2
					'msg-opposite'

		# 计算未读消息个数（超过99，则显示99+）
		calcUnReadCount: (n) ->
			return "#{ n }" if n < 99
			'99+'
		# 消息时间线
		timeline: (stamp) ->
			date = new Date stamp
			today = new Date()
			M = date.getMonth() + 1
			M = if (M + '').length > 1 then M else '0' + M
			d = date.getDate()
			d = if (d + '').length > 1 then d else '0' + d
			H = date.getHours()
			H = if (H + '').length > 1 then H else '0' + H
			m = date.getMinutes()
			m = if (m + '').length > 1 then m else '0' + m
			s = date.getSeconds()
			s = if (s + '').length > 1 then s else '0' + s
			if today.getMonth() is date.getMonth() and today.getDate() is date.getDate()
				"#{ H }:#{ m }:#{ s }"
			else
				"#{ M }-#{ d } #{ H }:#{ m }:#{ s }"

	watch:
		# 切换用户
		dialogInfo: (newInfo, oldInfo) ->
			unless newInfo
				## 理论上不会出现 newInfo 为 null 的情况，首次加载除外，所以应该不会进入这里
				# 清空数据
				@clearData()
			else if (oldInfo and newInfo.id isnt oldInfo.id) or !oldInfo
				# 清空数据
				@clearData()
				# 加载首屏历史消息数据
				@fetchHistory 1

	mounted: ->
		window.x = @
		window.u = Utils

	methods:
		# 清空数据
		clearData: ->
			# 清空 历史消息数据列表
			@$store.state.chatHistoryList = []
			# 清空 未读消息
			@clearUnread()
			# 清空 新推送的未读消息
			@clearNewUnread()
			# 重置 是否无更多历史消息的状态
			@noMoreHistory = 0

		# 获取历史消息数据
		fetchHistory: (isReset) ->
			return unless @dialogInfo
			return if @isLoadingHistory
			# 更改是否正在加载历史数据的状态
			@isLoadingHistory = 1

			## 请求参数
			params = {}
			# 用户 ID
			params.userId = @dialogInfo.id
			# 请求的消息条数
			if isReset
				params.size = @msgInitCount
				params.size = @dialogInfo.unreadCount if @dialogInfo.unreadCount > params.size
				# params.size = 5
			else
				params.size = @msgAppendCount
			# 目前最前面的那条消息的 timestamp（非首屏）
			params.timestamp = @referTimeStamp unless isReset
			
			# 发起请求
			promise = Utils.ajax ALPHA.API_PATH.dialogue.history,
				params: params
			promise.then (data) =>
				list = data.data
				unless list.length
					## 无更多数据
					# 更改是否正在加载历史数据的状态
					@isLoadingHistory = 0
					# 无更多数据的状态
					@noMoreHistory = 1
					return

				# 如果为首屏数据加载，初始化 referTimeStamp
				@referTimeStamp = list[0].timeStamp if isReset
				multiple = 0
				# 追加数据（包含首屏数据的情况）
				# list = list.concat @chatHistoryList
				list = [...list, ...@chatHistoryList]
				for item, i in list
					unless i
						item.hasTimeline = 1
						continue
					# 5 为 5分钟
					tempMultiple = ~~( (item.timeStamp - @referTimeStamp) / (5 * 60 * 1000) )
					if tempMultiple > multiple
						item.hasTimeline = 1
						multiple = tempMultiple
				# 更改是否正在加载历史数据的状态
				@isLoadingHistory = 0
				# 刷新数据
				@$store.state.chatHistoryList = list
				if isReset
					## 首屏时，滚动到最底部
					@$nextTick =>
						# 滚动到最底部
						@scrollToBottom 0
						# 处理未读消息
						@setUnreadList()
				else
					## 非首屏时，保持当前窗口中的可视消息位置
					# 记录当前 chatWindow scrollTop
					# sT = @$refs.chatWindow.scrollTop
			return

		# 历史消息滚动到最顶部
		scrollToTop: (duration = 200) ->
			@$refs.chatWindow.velocity scrollTop: 0, {duration: duration}

		# 历史消息滚动到最底部
		scrollToBottom: (duration = 200) ->
			# window element
			win = @$refs.chatWindow
			# window height
			winH = win.offsetHeight
			# content height
			conH = @$refs.chatWrapper.offsetHeight
			# difference value
			diff = conH - winH
			return if diff < 0
			win.velocity scrollTop: diff, {duration: duration}

		# Event: 消息发送事件
		eventSend: ->
			# 转义（防xss）
			text = @inputText.encodeHTML()
			# 发送消息体（messageType 1: 文字 2: 图片）
			sendBody = messageType: 1, message: text
			# 发送消息
			@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.MESSAGE, @dialogInfo.id, JSON.stringify sendBody
			# 清空消息框
			@inputText = ''

		# Event: 选择并发送图片
		eventChoosePicture: (event) ->
			# 弹出提示
			vm.$notify
				type: 'info'
				title: '开发中'
				message: '正在开发中，敬请期待'

		# 向输入框插入表情，并关闭表情选择面板
		insertEmoji: (emoji) ->
			# 向输入框追加表情
			@inputText += emoji
			# 关闭表情选择面板
			@$refs.emojiPicker.hide()
			# 使输入框获取焦点
			@$nextTick =>
				@$refs.input.focus()

		# 初始化/重置 历史消息列表的位置（到最底部）
		resetHistoryPosition: ->
			wrap = @$refs.historyWindow
			box = wrap.children[0]
			# window height
			wh = wrap.offsetHeight
			# content height
			ch = box.offsetHeight
			return if wh > ch
			wrap.scrollTop = ch - wh

		# Event: 历史消息列表滚动事件
		eventScrollHistory: ->
			return if @noMoreHistory

			# 频率控制器
			return if @winScrollState
			@winScrollState = 1
			setTimeout (=> @winScrollState = 0), 20

			## 获取更多历史消息数据
			# 12:	.chat-content padding-top
			# 14:	.time-line height
			# 9:	.msg-self/.msg-opposite padding-top
			# 34/2	.msg-bubble half height
			@fetchHistory() if @$refs.chatWindow.scrollTop < 12 + 14 + 9 + 34 / 2

		# Event: 显示上面的未读消息点击事件
		eventShowUpperUnread: ->
			# 清空 未读消息
			@clearUnread()
			# 滚动到顶部
			@scrollToTop()

		# Event: 显示下面的未读消息点击事件
		eventShowLowerUnread: ->
			# 清空 新推送的未读消息
			@clearNewUnread()
			# 滚动到底部
			@scrollToBottom()

		# 清空 未读消息
		clearUnread: ->
			# 清空 未读消息 element 引用列表
			@unreadElList = []

		# 清空 新推送的未读消息
		clearNewUnread: ->
			# 清空 新推送的未读消息 element 引用列表
			@newUnreadElList = []

		# Event: 结束当前对话
		eventCloseTheChat: ->
			@confirmToClose = 1

		# 结束当前对话
		closingTheChat: ->
			@$store.commit 'removeFromChattingList', @dialogInfo

		# 处理未读消息（只会在首屏时被执行
		setUnreadList: ->
			info = @dialogInfo
			return unless info
			return unless info.unreadCount
			# 推送给服务器端清空未读消息
			@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.READING, info.id
			# unread count
			count = info.unreadCount
			# window element
			win = @$refs.chatWindow
			# window height
			wh = win.offsetHeight
			# result height
			rh = 0
			# window element's children elements
			els = win.children
			# 计算窗口可见消息条数
			for i in [els.length - 1...0]
				rh += els[i].offsetHeight
				break if rh > wh
				--count
			# 计算刨除可见的消息以外的未读消息
			# TODO
			
			# @unreadElList

		# 处理新推送的未读消息（只会在非首屏时被执行
		setNewUnreadList: ->
'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# 输入的文本
		inputText: ''
		# 是否准备输入（输入框是否获取焦点）
		isReadyToType: 0
		# 是否正在加载历史数据的状态
		isLoadingHistory: 0
		# 是否无更多历史消息的状态
		noMoreHistory: 0
		# 首屏消息条数
		msgInitCount: 20
		# 非首屏消息条数
		msgAppendCount: 20
		# 历史消息数据列表（新数据在后）
		list: []
		# 未读消息 element 引用列表（新消息在前）
		unreadElList: []
		# 新推送的未读消息 element 引用列表（顺序无所谓）
		newUnReadElList: []
		# 历史消息列表中第一条数据的timeStamp
		referTimeStamp: 0

	computed:
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo
		# 未读消息条数
		unreadCount: -> @unreadElList.length
		# 新推送的未读消息条数
		newUnReadCount: -> @newUnReadElList.length

	filters:
		# 历史消息区 消息 class 类名（区分己方/对方）
		sideClass: (side) ->
			switch side
				when 1
					'msg-opposite'
				when 2
					'msg-self'

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
			@list.length = 0
			# 清空 未读消息 element 引用列表
			@unreadElList.length = 0
			# 清空 新推送的未读消息 element 引用列表
			@newUnReadElList.length = 0
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
			else
				params.size = @msgAppendCount
			# TODO 目前还没有历史消息接口，也许字段名不对
			# 目前最前面的那条消息的 timestamp（非首屏）
			params.timestamp = @referTimeStamp unless isReset
			
			# 发起请求
			promise = Utils.ajax ALPHA.API_PATH.dialogue.history,
				params: params
			promise.then (data) =>
				list = data.data
				console.log list
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
				list = list.concat @list
				for item, i in list
					unless i
						item.hasTimeline = 1
						continue
					# 5 为 5分钟
					tempMultiple = ~~( (item.timeStamp - @referTimeStamp) / (5 * 60 * 1000) )
					if tempMultiple > multiple
						item.hasTimeline = 1
						multiple = tempMultiple
				# TEST CODE
				console.log 'history: ', list
				# 记录当前 chatWindow scrollTop
				sT = @$refs.chatWindow.scrollTop
				# 更改是否正在加载历史数据的状态
				@isLoadingHistory = 0
				# 刷新数据
				@list = list
				# TODO 也许要考虑数据加载后会有闪屏的情况
				if isReset
					# 首屏时，滚动到最底部
					@$nextTick => @scrollToBottom()
				else
					# 非首屏时，保持当前窗口中的可视消息位置
			return

		# 历史消息滚动到最顶部
		scrollToTop: (duration = 1500) ->
			@$refs.chatWindow.velocity scrollTop: 0, {duration: duration}

		# 历史消息滚动到最底部
		scrollToBottom: (duration = 0) ->
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
			console.log event.keyCode

			# 转义（防xss）
			text = @inputText.encodeHTML()

			# 清空输入框
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
		eventShowUpperUnRead: ->
			# 触发加载数据事件
			@fetchHistory()
			# 滚动到顶部
			@$refs.chatWindow.velocity scrollTop: 0


			# 清空 未读消息 element 引用列表
			# @unreadElList.length = 0

		# Event: 显示下面的未读消息点击事件
		eventShowLowerUnRead: ->
			# 清空 新推送的未读消息 element 引用列表
			@newUnReadElList.length = 0
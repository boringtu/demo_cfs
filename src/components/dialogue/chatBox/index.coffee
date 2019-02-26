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
		msgInitCount: 20
		# 非首屏消息条数
		msgAppendCount: 20
		# 未读消息 element 引用列表（新消息在前）
		unreadElList: []
		# 新推送的未读消息 element 引用列表（顺序无所谓）
		newUnreadElList: []
		# 历史消息列表中第一条数据的timeStamp
		referTimeStamp: 0

	computed:
		isChatting: ->
			info = @dialogInfo
			info?.isChatting
		title: ->
			switch @isChatting
				when 1
					'当前对话'
				when 0
					'历史对话'
				else
					''
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo
		# 未读消息条数
		unreadCount: -> @unreadElList.length
		# 新推送的未读消息条数
		newUnreadCount: -> @newUnreadElList.length
		# 历史消息数据列表（新数据在后）
		chatHistoryList: -> @$store.state.chatHistoryList
		isFromIE: ->
			@dialogInfo?.conversation?.keyWord is 'isIE'

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
			s = date.getSeconds()
			s = if (s + '').length > 1 then s else '0' + s
			if today.getFullYear() isnt date.getFullYear()
				"#{ Y }-#{ M }-#{ d } #{ H }:#{ m }:#{ s }"
			else if today.getMonth() isnt date.getMonth() or today.getDate() isnt date.getDate()
				"#{ M }-#{ d } #{ H }:#{ m }:#{ s }"
			else
				"#{ H }:#{ m }:#{ s }"

	watch:
		# 切换用户
		dialogInfo: (newInfo, oldInfo) ->
			@inputText = ''
			unless newInfo
				## 理论上不会出现 newInfo 为 null 的情况，首次加载除外，所以应该不会进入这里
				# 清空数据
				@clearData()
			else if (oldInfo and newInfo.id isnt oldInfo.id) or !oldInfo
				# 清空数据
				@clearData()
				# 加载首屏历史消息数据
				@fetchHistory 1

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
					# 发送欢迎语
					@sendWelcome() if isReset
					return

				# 新请求来的消息条数
				newMsgCount = list.length

				# 追加数据（包含首屏数据的情况）
				@$store.state.chatHistoryList = list = [...list, ...@chatHistoryList]
				# 刷新 timeline 的数据
				@refreshTimeline()

				# 更改是否正在加载历史数据的状态
				@isLoadingHistory = 0
				# 添加未读标记
				count = @dialogInfo.unreadCount
				for i in [list.length - 1...0]
					break unless count--
					item = list[i]
					item.isUnread = 1
				if isReset
					## 首屏时，滚动到最底部
					@$nextTick =>
						# 处理未读消息
						@setUnreadList()
						# 滚动到最底部
						@scrollToBottom 0
						# 发送欢迎语
						@sendWelcome()
				else
					## 非首屏时，保持当前窗口中的可视消息位置
					els = [].slice.apply @$refs.chatWrapper.children
					h = 0
					for i in [0..newMsgCount]
						el = els[i]
						break unless el
						h += el.offsetHeight
					@$refs.chatWindow.scrollTop = h

		# 刷新 timeline 的数据
		refreshTimeline: ->
			list = @chatHistoryList
			return unless list.length
			# 刷新 referTimeStamp
			@referTimeStamp = list[0].timeStamp
			multiple = 0
			for item, i in list
				unless i
					item.hasTimeline = 1
					continue
				# 5 为 5分钟
				tempMultiple = ~~( (item.timeStamp - @referTimeStamp) / (5 * 60 * 1000) )
				if tempMultiple > multiple
					item.hasTimeline = 1
					multiple = tempMultiple
				else
					item.hasTimeline = 0

		# 发送欢迎语
		sendWelcome: ->
			return unless @$store.state.waitingWelcome
			@$store.state.waitingWelcome = 0
			config = ALPHA.config
			return unless config
			welcome = config.welcome_msg
			return unless welcome
			welText = welcome.msg_content
			welStatus = welcome.auto_send_on_start
			sendBody = messageType: 1, message: welcome.msg_content.encodeHTML()
			@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.MESSAGE, @dialogInfo.id, JSON.stringify sendBody if +welStatus and welText

		# 历史消息滚动到指定位置
		scrollTo: (targetY = 0, duration = 200) ->
			@$refs.chatWindow.velocity scrollTop: "#{ targetY }px", {duration: duration}

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
			win.velocity scrollTop: "#{ diff + 20 }px", {duration: duration}

		# 历史消息区当前位置是否位于最底部
		isLocateBottom: ->
			# window element
			win = @$refs.chatWindow
			# window height
			winH = win.offsetHeight
			# content height
			conH = @$refs.chatWrapper.offsetHeight
			# difference value
			diff = conH - winH
			# 如果内容没满一屏
			return 1 if diff < 0

			# all chat element list
			allEls = [].slice.apply @$refs.chatWrapper.children
			# the last chat element
			el = allEls.last()

			# 备注：
			# 9:	.msg-self/.msg-opposite padding-top/padding-bottom
			# 34/2	.msg-bubble half height

			# window scrollTop
			sT = win.scrollTop
			# total height
			tH = @$refs.chatWrapper.offsetHeight

			return sT + winH > tH - 9 - 34 / 2

		# Event: 消息发送事件
		eventSend: ->
			return unless @inputText.trim()
			# 转义（防xss）
			text = @inputText.encodeHTML()
			# 发送消息体（messageType 1: 文字 2: 图片）
			sendBody = messageType: 1, message: text
			# 发送消息
			@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.MESSAGE, @dialogInfo.id, JSON.stringify sendBody
			# 清空消息框
			@inputText = ''

		# 向输入框插入表情，并关闭表情选择面板
		insertEmoji: (emoji) ->
			# 向输入框追加表情
			@inputText += emoji
			# 关闭表情选择面板
			@$refs.emojiPicker.hide()
			# 使输入框获取焦点
			@$nextTick =>
				@$refs.input.focus()

		# Event: 历史消息列表滚动事件
		eventScrollHistory: ->
			return if @noMoreHistory

			# 频率控制器
			return if @winScrollState
			@winScrollState = 1
			setTimeout (=> @winScrollState = 0), 20

			## 处理 unreadElList
			list = @unreadElList
			# window element
			win = @$refs.chatWindow
			# 备注：
			# 14:	.time-line height
			# 9:	.msg-self/.msg-opposite padding-top
			# 34/2	.msg-bubble half height
			# 消息顶部距离文字中间的高度（不包含timeline）
			cH = 9 + 34 / 2
			# .time-line height
			tT = 14
			# window scrollTop
			sT = win.scrollTop
			loop
				el = list[0]
				break unless el
				# 是否带有timeline
				hasTL = ~~el.getAttribute 'data-timeline'
				# 当前 element 距离顶部的距离
				distance = el.offsetTop + cH
				distance += tT if hasTL
				break unless sT < distance
				el.setAttribute 'data-unread', 0
				list.shift()
				
			## 处理 newUnreadElList
			@newUnreadElList = [] if @isLocateBottom()

			## 获取更多历史消息数据
			@fetchHistory() if sT < cH + tT

		# Event: 显示上面的未读消息点击事件
		eventShowUpperUnread: ->
			# window element
			win = @$refs.chatWindow
			# all chat element list
			allEls = [].slice.apply @$refs.chatWrapper.children
			# readed count
			rCount = 0
			# 时间最久的未读消息 element
			lastUnreadEl = @unreadElList.last()
			return unless lastUnreadEl
			for item in allEls
				break if item is lastUnreadEl
				++rCount
			# 目标 Y 坐标
			targetY = 0
			targetY += allEls[i].offsetHeight for i in [0...rCount]
			@scrollTo targetY
			# 清空 未读消息
			@clearUnread()

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
			name = @dialogInfo.name
			promise = Utils.ajax ALPHA.API_PATH.dialogue.close,
				method: 'POST'
				data: userId: @dialogInfo.id
			promise.then (res) =>
				@$store.commit 'removeFromChattingList', @dialogInfo
				# 弹出提示
				vm.$notify
					type: 'success'
					title: '会话结束'
					message: "已结束与 #{ name } 的会话"

		# 服务器推送来的消息（包括己方发送的消息）
		addMessage: (msg) ->
			@$store.commit 'addToChatHistoryList', msg
			# 刷新 timeline 的数据
			@refreshTimeline()
			if msg.sendType is 1
				# 己方消息，滚动到底部
				@$nextTick => @scrollToBottom 80
			else
				if @isLocateBottom()
					@$nextTick => @scrollToBottom()
				else
					# 对方消息，追加到 newUnreadElList
					@newUnreadElList.push msg

		# 处理未读消息（只会在首屏时被执行
		setUnreadList: ->
			info = @dialogInfo
			return unless info
			return unless info.unreadCount
			# 通知服务器端清空未读消息
			setTimeout =>
				@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.READING, info.id
			, 100

			# chat elements
			els = @$refs.chatWrapper.children
			# unread element list
			list = []
			for i in [els.length - 1...0]
				el = els[i]
				isUnread = ~~el.getAttribute 'data-unread'
				list.push el if isUnread
			@unreadElList = list

		# Event: 发送图片
		eventSendPic: (event) ->
			target = event.target
			file = target.files[0]

			# 限制图片大小 小于 10Mb
			if file.size / 1024 / 1024 > 10
				# 清空 value，否则重复上传同一个文件不会触发 change 事件
				target.value = ''
				# 弹出提示
				vm.$notify
					type: 'warning'
					title: '图片发送失败'
					message: "图片大小不可超过10Mb"
				return

			###
			# 此段注释代码是不依赖网络，将图片直接显示在历史消息里，并方便加上 loading 状态的功能
			reader = new FileReader()
			reader.addEventListener 'load', (event) ->
				data = target.result
				image = new Image()
				# 加载图片获取图片的宽高
				image.addEventListener 'load', (event) ->
					w = image.width
					h = image.height
				image.src = data
			reader.readAsDataURL file
			###

			formData = new FormData()
			formData.append 'multipartFile', file
			# 发起请求
			@axios.post ALPHA.API_PATH.common.upload, formData, headers: 'Content-Type': 'multipart/form-data'
			.then (res) =>
				console.log res.data
				if res.msg is 'success'
					fileUrl = res.data.fileUrl

					# 发送消息体（messageType 1: 文字 2: 图片）
					sendBody = messageType: 2, message: fileUrl
					# 发送消息
					@view.wsSend ALPHA.API_PATH.WS.SEND_CODE.MESSAGE, @dialogInfo.id, JSON.stringify sendBody
			# 清空 value，否则重复上传同一个文件不会触发 change 事件
			target.value = ''
		# 渲染消息
		renderMessage: (msg) ->
			return '' unless msg and msg.message
			switch msg.messageType
				when 1
					# 文本消息
					text = msg.message
					text = text.replace /\n|\ /g, (char) ->
						switch char
							when '\n'
								'<br/>'
							when ' '
								'&nbsp;'
							else
								char
					text.encodeHTML()
				when 2
					# 图片
					"""
						<a href="/#{ msg.message.encodeHTML() }" target="_blank">
							<img src="/#{ msg.message.encodeHTML() }" />
						</a>
					"""

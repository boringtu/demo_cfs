'use strict'
import Utils from '@/assets/scripts/utils'
import ComponentVisitorList from '@/components/dialogue/visitorList'
import ComponentDialogList from '@/components/dialogue/dialogList'
import ComponentChatBox from '@/components/dialogue/chatBox'
import ComponentVisitorInfo from '@/components/dialogue/visitorInfo'

class SendWS
	constructor: (...data) ->
		unless @send data
			@handle = setInterval (=> @send data), 20
	send: (data) ->
		socket = vm.$store.state.socket
		ws = vm.$store.state.ws
		return 0 unless socket?.readyState is 1
		clearInterval @handle
		# 发送数据
		ws.send.apply ws, data
		ws = null
		socket = null
		return 1

export default
	data: ->
		# 是否主动关闭 WS
		closingActively: 0
		# 重连次数
		reconnectCount: -1

	components:
		'CPNT-visitorList': ComponentVisitorList
		'CPNT-dialogList': ComponentDialogList
		'CPNT-chatBox': ComponentChatBox
		'CPNT-visitorInfo': ComponentVisitorInfo

	beforeRouteUpdate: (to, from, next) ->
		# 刷新会话 ID（如果有
		@$store.state.dialogID = +to.params.id
		next()

	computed:
		# Stomp 连接（WebSocket
		ws: -> @$store.state.ws

		# 待接待访客列表
		visitorList: -> @$store.state.visitorList
		# 当前会话ID
		dialogID: -> @$store.state.dialogID

	created: ->
		window.p = @
		# 建立 WebSocket 连接
		@connectWSLink()

	beforeDestroy: ->
			# 清空数据
			@$store.commit 'clearData'

			# 断开 WebSocket 连接
			@closingActively = 1
			try
				@socket?.close()
				@ws?.disconnect()

	methods:
		# 建立 WebSocket 连接
		connectWSLink: ->
			@$store.state.socket?.close()
			@$store.state.ws?.disconnect()
			@$store.state.socket = socket = new SockJS ALPHA.API_PATH.WS.url
			@$store.state.ws = ws = Stomp.over socket
			# 断线重连机制
			socket.addEventListener 'close', =>
				if ++@reconnectCount > 10
					# 弹出提示
					vm.$notify
						type: 'error'
						title: '网络已断开'
						message: '网络连接失败，请刷新重试'
						duration: 0
						showClose: false
				else
					setTimeout =>
						@connectWSLink() unless @closingActively
					, 1000
			ws.connect {}, (frame) =>
				# 添加监听
				ws.subscribe ALPHA.API_PATH.WS.broadcast, @monitorBroadcast
				ws.subscribe ALPHA.API_PATH.WS.p2p, @monitorP2P


		###
		 # @params SEND_CODE <int> 发送消息类型。严禁直接传值，要用枚举：ALPHA.API_PATH.WS.SEND_CODE（备注：1: 发送消息，2: 客服接单，3: 消息已读
		 # @params message <JSON String> 消息体。只在 SEND_CODE 为 1 时存在
		###
		wsSend: (SEND_CODE, userId, message) ->
			new SendWS ALPHA.API_PATH.WS.send, {}, "#{ SEND_CODE }|#{ userId }|#{ message or '' }"

		# 监听 广播
		monitorBroadcast: (res) ->
			body = res.body
			console.log 'boardcast: ', body
			# 消息类型
			type = +body.match(/^(\d+)\|/)[1]
			body = body.replace /^\d+\|/, ''
			switch type
				when ALPHA.API_PATH.WS.RECEIVE_CODE.broadcast.PUSHING
					## 1: 新访客推送
					## 1|user Object|
					body = body.replace /\|$/, ''
					user = body.toJSON()
					# 添加 waitingTime 字段
					user.conversation.waitingTime = 0
					# 将该访客追加到待接待访客列表中
					@$store.commit 'addToVisitorList', user
				when ALPHA.API_PATH.WS.RECEIVE_CODE.broadcast.RECEIVED
					## 2: 指定访客已被接待
					## 2|userId|
					body = body.replace /\|$/, ''
					userId = +body.match(/^(\d+)/)[1]
					# 从待接待访客列表中移除该用户
					@$store.commit 'removeFromVisitorList', userId
				when ALPHA.API_PATH.WS.RECEIVE_CODE.broadcast.ALLOCATED
					## 3: 自动分配的新访客
					## 3|user Object|
					body = body.replace /\|$/, ''
					user = body.toJSON()
					# 通知服务器要接待此用户
					@wsSend ALPHA.API_PATH.WS.SEND_CODE.RECEIVING, user.id

		# 监听 点对点
		monitorP2P: (res) ->
			body = res.body
			console.log 'p2p: ', body
			# 消息类型
			type = +body.match(/^(\d+)\|/)[1]
			body = body.replace /^\d+\|/, ''
			# 用户ID
			userId = +body.match(/^(\d+)\|/)[1]
			body = body.replace /^\d+\|/, ''
			switch type
				when ALPHA.API_PATH.WS.RECEIVE_CODE.p2p.MESSAGE
					## 1: 消息推送
					## 1|userId|message Object
					msg = body.toJSON()
					# 刷新 chatting list
					@$store.commit 'refreshChattingList', msg
					# 当前会话为此用户时
					if userId is @dialogID
						# 追加消息
						@$refs.cpnt_chatBox.addMessage msg
						# 通知服务器端清空未读消息
						@wsSend ALPHA.API_PATH.WS.SEND_CODE.READING, userId
					else
						# 递增未读消息数
						@$store.commit 'increaseUnreadCount', userId
					# 播放新消息声音
					ALPHA.audios.newMsg.stop().play() unless msg.sendType is 1
				when ALPHA.API_PATH.WS.RECEIVE_CODE.p2p.RECEIVED
					## 2: 开始接待用户
					## 2|userId|user Object
					user = body.toJSON()
					user.isChatting = 1
					# 标记等待发送欢迎语的状态
					@$store.state.waitingWelcome = 1
					# 向正在对话的访客列表中推送访客
					@$store.commit 'addToChattingList', user
					# 递增今日访问量
					@$store.commit 'increaseTodayCount'
					# 播放接待新用户声音
					ALPHA.audios.newDialog.stop().play()
				when ALPHA.API_PATH.WS.RECEIVE_CODE.p2p.READED
					## 3: 消息已读处理成功
					## 3|userId|
					@$store.commit 'readed', userId

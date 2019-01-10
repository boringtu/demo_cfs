'use strict'
import ComponentVisitorList from '@/components/dialogue/visitorList'
import ComponentDialogList from '@/components/dialogue/dialogList'
import ComponentChatBox from '@/components/dialogue/chatBox'
import ComponentVisitorInfo from '@/components/dialogue/visitorInfo'

class SendWS
	constructor: (@ws, data) ->
		unless @send data
			@handle = setInterval (=> @send data), 20
	send: (data) ->
		socket = vm.$store.state.socket
		return 0 unless socket?.readyState is 1
		clearInterval @handle
		# 发送数据
		@ws.send.apply @ws, data
		@ws = null
		return 1

export default
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
		@$store.state.socket = socket = new SockJS ALPHA.API_PATH.WS.url
		@$store.state.ws = ws = Stomp.over socket
		ws.connect {}, (frame) =>
			# console.log 'Connected:' + frame
			# 添加监听
			ws.subscribe ALPHA.API_PATH.WS.broadcast, @monitorBroadcast
			ws.subscribe ALPHA.API_PATH.WS.p2p, @monitorP2P

		# 如页面被关闭，关闭 WebSocket 连接
		window.addEventListener 'unload', => @ws?.disconnect()

	methods:
		###
		 # @params SEND_CODE <int> 发送消息类型。严禁直接传值，要用枚举：ALPHA.API_PATH.WS.SEND_CODE（备注：1: 发送消息，2: 客服接单，3: 消息已读
		 # @params message <JSON String> 消息体。只在 SEND_CODE 为 1 时存在
		###
		wsSend: (SEND_CODE, userId, message) ->
			# @ws.send ALPHA.API_PATH.WS.send, {}, "#{ SEND_CODE }|#{ userId }|#{ message or '' }"
			console.log '应该就一次'
			new SendWS @ws, [ALPHA.API_PATH.WS.send, {}, "#{ SEND_CODE }|#{ userId }|#{ message or '' }"]

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
					## 1|user Object
					user = body.toJSON()
					# 将该访客追加到待接待访客列表中
					@$store.commit 'addToVisitorList', user
					# @$store.state.visitorList.push user
				when ALPHA.API_PATH.WS.RECEIVE_CODE.broadcast.RECEIVED
					## 2: 指定访客已被接待
					## 2|userId
					userId = +body.match(/^(\d+)/)[1]
					# 从待接待访客列表中移除该用户
					@$store.commit 'removeFromVisitorList', userId

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
				when ALPHA.API_PATH.WS.RECEIVE_CODE.p2p.RECEIVED
					## 2: 开始接待用户
					## 2|userId|user Object
					user = body.toJSON()
					# 向正在对话的访客列表中推送访客
					@$store.commit 'addToChattingList', user
				when ALPHA.API_PATH.WS.RECEIVE_CODE.p2p.READED
					## 3: 消息已读处理成功
					## 3|userId|
					@$store.commit 'readed', userId

'use strict'
import ComponentVisitorList from '@/components/dialogue/visitorList'
import ComponentDialogList from '@/components/dialogue/dialogList'
import ComponentChatBox from '@/components/dialogue/chatBox'
import ComponentVisitorInfo from '@/components/dialogue/visitorInfo'

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
		ws: -> @$store.state.ws

	created: ->
		window.p = @
		# 建立 WebSocket 连接
		socket = new SockJS ALPHA.API_PATH.WS.url
		@$store.state.ws = ws = Stomp.over socket
		ws.connect {}, (frame) =>
			# console.log 'Connected:' + frame
			# 添加监听
			ws.subscribe ALPHA.API_PATH.WS.broadcast, @monitorBroadcast
			ws.subscribe ALPHA.API_PATH.WS.p2p, @monitorP2P

		# 如页面被关闭，关闭 WebSocket 连接
		window.addEventListener 'unload', => @wsDisconnect()

	methods:
		wsDisconnect: ->
			@ws.disconnect() if @ws?

		###
		 # @params SEND_CODE <int> 发送消息类型。严禁直接传值，要用枚举：ALPHA.API_CODE.WS.SEND_CODE（备注：1: 发送消息，2: 客服接单，3: 消息已读
		 # @params message <JSON String> 消息体。只在 SEND_CODE 为 1 时存在
		###
		wsSend: (SEND_CODE, message) ->
			@ws.send ALPHA.API_PATH.WS.send, {}, "#{ SEND_CODE }|#{ ALPHA.admin.adminId }|#{ message or '' }"

		# 监听 广播
		monitorBroadcast: (res) ->
			# 指定用户已被接单
			ALPHA.API_CODE.WS.RECEIVE_CODE.broadcast.RECEIVING
			console.log 'boardcast: ', res
			console.log @

		# 监听 点对点
		monitorP2P: (res) ->
			# 通知当前客服已开始接待该用户
			ALPHA.API_CODE.WS.RECEIVE_CODE.p2p.RECEIVING
			console.log 'p2p: ', res
			console.log @
import Vue from 'vue'
import Vuex from 'vuex'
import Utils from '@/assets/scripts/utils'

Vue.use Vuex

export default new Vuex.Store
	state:
		# Socket 连接（WebSocket
		socket: null
		# Stomp 连接（WebSocket
		ws: null
		# 与服务器时间差值
		timeDiff: null
		# 待接待访客列表
		visitorList: []
		# 正在进行中的会话列表
		chattingList: []
		# 已关闭的会话列表
		closedList: []
		# 历史消息列表
		chatHistoryList: []
		# 当前会话ID
		dialogID: null
		# 当前会话数据
		dialogInfo: null

	mutations:
		# add visitor into visitor list
		addToVisitorList: (state, user) ->
			list = state.visitorList
			state.visitorList = [...list, user]

		# remove visitor from visitor list
		removeFromVisitorList: (state, userId) ->
			list = Utils.clone state.visitorList
			for user in list when user.id is userId
				list.remove user
				state.visitorList = list
				break

		# add visitor into chatting list
		addToChattingList: (state, user) ->
			list = state.chattingList
			state.chattingList = [user, ...list]
			# 切换到当前访客对话状态
			vm.$router.replace "/dialogue/#{ user.id }"

		# remove visitor from chatting list
		removeFromChattingList: (state, user) ->
			return unless user
			list = state.chattingList
			# 从 chatting list 中移除该用户
			i = list.indexOf user
			list = Utils.clone list
			list.splice i, 1
			state.chattingList = list
			# 默认开启 chatting list 中第一个用户的聊天状态（如果有
			path = '/dialogue'
			path += "/#{ list[0].id }" if list.length
			vm.$router.replace path
			# 将该用户添加到 closed list 中
			list = state.closedList
			state.closedList = [user, ...list]

		# 消息已读处理成功
		readed: (state, userId) ->
			list = state.chatHistoryList
			for user in list when user.id is userId
				user.unreadCount = 0
				break

		# 刷新 chatting list
		refreshChattingList: (state, msg) ->
			# 用户ID
			id = msg.userId
			# 从正在进行中的会话列表中匹配该用户对象
			# 注：不可能出现在 closedList 中
			list = Utils.clone state.chattingList
			for item in list when item.id is id
				info = item
				# 排序
				list.remove info
				state.chattingList = [info, ...list]
				break
			# 更新最新 message
			info.message = msg

	actions: {}

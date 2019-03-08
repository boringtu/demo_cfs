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
		# 今日访问量
		todayCount: 0
        # 默认的客服权限
		menuServeIdList: []
        # 默认的管理员权限
		menuManagerIdList: []
		logoUrl: ''
		# 在线状态
		lineStatus: 1
		isMute: 0

	mutations:
		# 清空数据
		clearData: (state) ->
			console.warn '清空数据'
			state.visitorList = []
			state.chattingList = []
			state.closedList = []
			state.chatHistoryList = []

		setLogoUrl: (state, url) ->
			localStorage.setItem 'logoUrl', url
			state.logoUrl = url

		# add visitor into visitor list
		addToVisitorList: (state, user) ->
			list = state.visitorList
			# 去重
			return if list.some (item) -> item.id is user.id
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
			# 在 正在对话中的用户列表中追加用户
			state.chattingList = [user, ...list]
			# 从 已结束对话的用户列表中移除该用户（如果有
			for item in state.closedList when item.id is user.id
				state.closedList.remove item
				break
			# 切换到当前访客对话状态
			vm.$router.replace "/dialogue/#{ user.id }"

		# remove visitor from chatting list
		removeFromChattingList: (state, user) ->
			return unless user
			user.isChatting = 0
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
			list = state.chattingList
			for user in list when user.id is userId
				user.unreadCount = 0
				break
			state.chattingList = Utils.clone list

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

		# add message into chat history list
		addToChatHistoryList: (state, msg) ->
			list = state.chatHistoryList
			state.chatHistoryList = [...list, msg]

		# 递增今日访问量
		increaseTodayCount: (state) ->
			++state.todayCount

		# 递增未读消息数
		increaseUnreadCount: (state, id) ->
			list = state.chattingList
			for item in list when item.id is id
				item.unreadCount++
				break

	actions: {}

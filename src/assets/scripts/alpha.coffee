###
 # 项目配置文件
###
export default do ->
	'use strict'

	### 私有函数 ###


	### ALPHA 命名空间 ###
	window.ALPHA =
		# 清空缓存的 token、客服 ID，和 权限数据
		clearPermission: ->
			arr = ['token', 'admin', 'permissions', 'topics']
			for key in arr
				localStorage.removeItem key
				vm.$store.state[key] = null

	Object.defineProperties window.ALPHA,
		# 枚举: 接口地址
		API_PATH:
			writable: off, value:
				## WebSocket ##
				WS: {}
				## 通用 ##
				common:
					# 登录
					login: '/api/common/login'
					# 登出
					logout: '/api/common/logout'
					# 服务器时间戳
					timestamp: '/api/common/timestamp'
					# 上传文件
					upload: '/api/common/upload'
				## 访客对话 ##
				dialogue:
					# 访客列表
					visitor: '/api/dialog/user/init'
					# 正在进行的对话列表
					chatting: '/api/dialog/user/chatting'
					# 已经关闭的对话列表
					closed: '/api/dialog/user/closed'
					# 用户信息
					user: '/api/dialog/user'
					# 今日访问量
					todayVisits: '/api/dialog/todayVisits'
					# 历史消息数据列表
					history: '/api/dialog/history'
					# 结束对话
					close: '/api/dialog/conversation/close'
					# 今日访问量
					todayCount: '/api/dialog/todayVisits'
				## 内部协同 ##
				synergy:
					# 客服列表
					all: '/api/teamwork/all'
					# 编辑分组
					edit: '/api/teamwork/group'
					# 添加客服
					addadmin: '/api/teamwork/admin'
					# 添加分组
					deleted : '/api/teamwork/group'
					# 删除分组
					group: '/api/teamwork/group'
					# 删除客服
					deletedServe: '/api/teamwork/admin'
					# 禁用客服
					disabledServe: '/api/teamwork/admin/ban'
					# 编辑客服
					editServe: '/api/teamwork/admin'
					# 所有权限
					permission: '/api/teamwork/permission'
					# 默认权限
					defaultpermission:	'/api/teamwork/role/permission'
					# 根据account查询单个客服
					check:	'/api/teamwork/admin/check'
				## 配置管理 ##
				configManagement:
					# 保存设置对话框主题
					saveSetTheme: '/api/conf/pcDialog'
					# 获取默认配置
					getDefaultSet: '/api/conf/pcDialog'
					# 恢复默认设置
					recoverDefaultSet: '/api/conf/default'

		# PERMISSIONS:
		# 	writable: off, value:
		# 		## 访客对话 ##
		# 		dialogue:
		# 			# 查看客户信息
		# 			# 修改客户信息
		# 		## 内部协同 ##
		# 		synergy:
		# 			# 查看客服列表
		# 			# 添加分组
		# 			# 添加客服
		# 		## 配置管理 ##
		# 		configManagement:
		# 			# 查看风格设置
		# 			# 修改风格设置


		# 签名私盐
		SALT:
			writable: off, value: 'chat@alpha'
		# 登录密码后缀
		SUFFIX:
			writable: off, value: 'chatting is awesome!'
		# 系统时间
		serverTime:
			get: ->
				timeDiff = vm.$store.state.timeDiff
				timeDiff = localStorage.getItem 'timeDiff' if timeDiff is 0
				now = new Date()
				unless timeDiff?
					console.error '无服务器时间数据'
					return now
				new Date +now - ~~timeDiff
		# 客服权限
		permissions:
			get: ->
				permissions = vm.$store.state.permissions
				# 如 vuex 中已有数据，直接返回
				return permissions if permissions
				# 如 vuex 中没有，则去 localStorage 中取
				permissions = localStorage.getItem 'permissions'
				# 如 localStorage 中也没有，返回 null
				return null unless permissions
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.permissions = permissions.toJSON()
		# token
		token:
			get: ->
				token = vm.$store.state.token
				# 如 vuex 中已有数据，直接返回
				return token if token
				# 如 vuex 中没有，则去 localStorage 中取
				token = localStorage.getItem 'token'
				# 如 localStorage 中也没有，返回 null
				return null unless token
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.token = token
		# 客服信息
		admin:
			get: ->
				admin = vm.$store.state.admin
				# 如 vuex 中已有数据，直接返回
				return admin if admin
				# 如 vuex 中没有，则去 localStorage 中取
				admin = localStorage.getItem 'admin'
				# 如 localStorage 中也没有，返回 null
				return null unless admin
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.admin = admin.toJSON()
		# 对话主题列表
		topics:
			get: ->
				topics = vm.$store.state.topics
				# 如 vuex 中已有数据，直接返回
				return topics if topics
				# 如 vuex 中没有，则去 localStorage 中取
				topics = localStorage.getItem 'topics'
				# 如 localStorage 中也没有，返回 null
				return null unless topics
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.topics = topics.toJSON()
		# 配置数据
		config:
			get: ->
				config = vm.$store.state.config
				# 如 vuex 中已有数据，直接返回
				return config if config
				# 如 vuex 中没有，则去 localStorage 中取
				config = localStorage.getItem 'config'
				# 如 localStorage 中也没有，返回 null
				return null unless config
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.config = config.toJSON()

		# 枚举: 接口响应 code（非 HTTP Status Code）
		RES_CODE:
			writable: off, value:
				# 缺少参数
				MISSING_PARAMETERS: 800
				# 登录超时
				TOKEN_OVERTIME: 801
				# 签名错误
				SIGN_ERROR: 802
				# 未登录
				LOGIN_ERROR: 803
				# 登录过期
				LOGIN_OVERTIME: 804
				# 接口拒绝 debug 模式
				REFUSE_DEBUG: 900
				# 请求参数的时间戳不在服务器系统时间 5 分钟范围内
				OVERTIME: 901
				# 无当前请求权限（一般都是跨过前端去请求指定接口才出现的情况
				NO_PERMISSION: 902
		# 菜单地址字典
		menuUrlMap:
			writable: off, value:
				# 访客对话
				1: icon: 'icon-dialogue', url: '/dialogue'
				# 内部协同
				2: icon: 'icon-synergy', url: '/synergy'
				# 配置管理
				3: icon: 'icon-configuration', url: '/configuration'
				# 配置管理 - 设置样式
				20: url: '/configuration/setStyle'

	Object.defineProperties window.ALPHA.API_PATH.WS,
		# 用于建立 WebSocket 连接
		url:
			writable: off, value: '/api/chat'
		# 枚举：发送 ws 数据的类型
		SEND_CODE:
			writable: off, value:
				# 发送消息
				MESSAGE: 1
				# 客服接单
				RECEIVING: 2
				# 消息已读
				READING: 3
		# 枚举：接收 ws 数据的类型
		RECEIVE_CODE:
			writable: off, value:
				broadcast:
					# 推送新用户至所有客服端的访客列表
					PUSHING: 1
					# 通知所有客服，指定用户已被接单
					RECEIVED: 2
				p2p:
					# 推送消息
					MESSAGE: 1
					# 通知当前客服已开始接待该用户
					RECEIVED: 2
					# 消息已读处理成功
					READED: 3
		## 以下用于用以建立的 ws 监听和发送
		# 点对点
		p2p:
			get: -> "/user/#{ ALPHA.admin?.adminId or '' }/cs/chatting"
		# 广播
		broadcast:
			writable: off, value: '/cs/waitingUser'
		# 发送
		send:
			writable: off, value: '/cs/chatting'
	
	window.ALPHA
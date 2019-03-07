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

		###
		 # 鉴权模块
		 # @params data 传进来的必须是枚举：ALPHA.PERMISSIONS 中的一项
		###
		checkPermission: (id) ->
			return 0 unless id
			ps = ALPHA.menus
			return 0 unless ps
			hasPermission = ps.some (item) -> item.id is id
			unless hasPermission
				# 弹出无权限操作提示
				vm.$notify
					type: 'error'
					title: '操作失败'
					message: '您无权限操作该模块'
			hasPermission

		# 保存 Audio 实例的 space
		audios: {}
		# 静音标识
		isMuted: 0

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
					# 在线状态
					lineStatus: '/api/teamwork/online'
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
					# 设置样式接口
					sysLogoSetting: '/api/conf/pcDialog'
					# 恢复默认设置
					recoverDefaultSet: '/api/conf/default'
					# 默认欢迎语
					defaultWelcomeSentence: '/api/conf/all'
					# 保存歡迎語
					saveWelcomeSentence: '/api/conf/welcomeMsg'
					# 保存自动分配
					saveAutoDistribute: '/api/conf/autoTake'
		# 枚举：具体权限（用于鉴权）
		PERMISSIONS:
			writable: off, value:
				## 访客对话 ##
				dialogue:
					# 修改客户信息
					infoModifiable: 13
				## 内部协同 ##
				synergy:
					# 添加分组
					groupAddable: 34
					# 编辑分组
					groupModifiable: 35
					# 删除分组
					groupDeletable: 36
					# 添加客服
					serverAddable: 38
					# 编辑客服
					serverModifiable: 39
					# 删除客服
					serverDeletable: 40
				## 配置管理 ##
				configManagement:
					# 设置样式的修改权限
					styleModifiable: 45
					# 对话设置的修改权限
					dialogueModifiable: 48


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
		# LOGO Url
		logoUrl:
			get: ->
				logoUrl = vm.$store.state.logoUrl
				# 如 vuex 中已有数据，直接返回
				return logoUrl if logoUrl
				# 如 vuex 中没有，则去 localStorage 中取
				logoUrl = localStorage.getItem 'logoUrl'
				# 如 localStorage 中也没有，返回 null
				return null unless logoUrl
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.logoUrl = logoUrl
		# 客服权限（一维数组）
		menus:
			get: ->
				menus = vm.$store.state.menus
				# 如 vuex 中已有数据，直接返回
				return menus if menus
				# 如 vuex 中没有，则去 localStorage 中取
				menus = localStorage.getItem 'menus'
				# 如 localStorage 中也没有，返回 null
				return null unless menus
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.menus = menus.toJSON()
		# 客服权限（树桩结构）
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
		# # 是否在线状态
		# lineStatus: 
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
				# 配置管理 - 对话设置
				46: url: '/configuration/setDialogue'

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
					# 自动分配的新用户
					ALLOCATED: 3
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
			# writable: off, value: '/cs/waitingUser'
			get: -> "/user/#{ ALPHA.admin?.adminId or '' }/cs/waitingUser"
		# 发送
		send:
			writable: off, value: '/cs/chatting'
	
	window.ALPHA
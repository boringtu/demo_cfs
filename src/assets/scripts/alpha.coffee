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
			arr = ['token', 'adminId', 'permission']
			for key in arr
				localStorage.removeItem key
				vm.$store.state[key] = null

	Object.defineProperties window.ALPHA,
		PROTOCOL:
			writable: off, value: location.protocol
		HOSTNAME:
			writable: off, value: location.hostname
		PORT:
			writable: off, value: location.port
		WS_PROTOCOL:
			writable: off, value: /^https/.test(location.protocol) ? 'wss' : 'ws'
		API_HOST:
			writable: off, value: '172.16.10.122:8090'
		# 签名私盐
		SALT:
			writable: off, value: 'chat@alpha'
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
		permission:
			get: ->
				permission = vm.$store.state.permission
				# 如 vuex 中已有数据，直接返回
				return permission if permission
				# 如 vuex 中没有，则去 localStorage 中取
				permission = localStorage.getItem 'permission'
				# 如 localStorage 中也没有，返回 null
				return null unless permission
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.permission = permission.toJSON()
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
		# 客服 ID
		adminId:
			get: ->
				id = vm.$store.state.adminId
				# 如 vuex 中已有数据，直接返回
				return id if id
				# 如 vuex 中没有，则去 localStorage 中取
				id = localStorage.getItem 'adminId'
				# 如 localStorage 中也没有，返回 null
				return null unless id
				# 如 localStorage 中存在，则缓存到 vuex 中，并返回
				vm.$store.state.adminId = +id

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
		# 枚举: 接口地址
		API_PATH:
			writable: off, value:
				## 通用 ##
				common:
					# 登录
					login: '/api/common/login'
					# 登出
					logout: '/api/common/logout'
					# 服务器时间戳
					timestamp: '/api/common/timestamp'
				## 访客对话 ##
				dialogue:
					# 访客列表
					visitor: '/api/dialog/user/init'
					# 正在进行的对话列表
					chatting: '/api/dialog/user/chatting'
					# 已经关闭的对话列表
					closed: '/api/dialog/user/closed'
				## 内部协同 ##
				## 配置管理 ##
	
	window.ALPHA
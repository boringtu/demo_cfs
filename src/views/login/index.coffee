'use strict'
import axios from 'axios'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		username: ''
		password: ''
		login_loading: false
		logoUrl: ''
	beforeRouteEnter: (to, from, next) ->
		# 验证如果当前已登录，则直接进入主页（即“访客对话”
		isLoggedIn = yes
		next()
		return
		if isLoggedIn
			target = name: 'dialogue'
			target = path: @$route.query.redirect if @$route.query.redirect
			next target
		else
			next()
	created: ->
		window.x = @
		# 获取服务器时间
		axios
			.get ALPHA.API_PATH.common.timestamp
			.then (res) =>
				# 保存服务器时间差值
				@$store.state.timeDiff = timeDiff = +new Date() - res.data
				localStorage.setItem 'timeDiff', timeDiff
				# 获取 logo
				@fetchSysLogo()
			.catch (err) ->
				console.error '服务器时间获取失败'

	mounted: ->
		elUsername = document.getElementById 'username'
		elPassword = document.getElementById 'password'
		elSubmitBtn = document.getElementById 'submitBtn'
		elUsername.addEventListener 'keyup', (event) =>
			return unless event.keyCode is 13
			elPassword.focus()
		elPassword.addEventListener 'keyup', (event) =>
			return unless event.keyCode is 13
			elSubmitBtn.click()

	methods:
		# 获取客服系统 Logo Url
		fetchSysLogo: ->
			data =
				type: 'manageLogo'
			Utils.ajax ALPHA.API_PATH.configManagement.sysLogoSetting, params: data
			.then (res) =>
				resData = res.data
				return unless resData
				@logoUrl = logoUrl = "/#{ resData.other }"
				@$store.commit 'setLogoUrl', logoUrl

		# Event: submit for login
		eventSubmit: (event) ->
			event.preventDefault()
			# 验证字段
			return if @validate data
			# 激活正在登录的状态
			@login_loading = true
			data =
				account: @username
				password: "#{ @password }#{ ALPHA.SUFFIX }".md5().toUpperCase()
			# 发起登录请求
			Utils.ajax ALPHA.API_PATH.common.login,
				method: 'POST'
				data: data
			.then (res) =>
				@login_loading = false
				data = res.data
				data.permissions = []

				## 去无效菜单
				globalFlag = 0
				protection = 0
				loop
					# 死循环保护机制
					break if ++protection > 100
					for m, i in data.menus when m.type is 1 and m.id isnt 1
						flag = 0
						for item in data.menus when item.pid is m.id
							flag = 1
							break
						unless flag
							globalFlag = 1
							data.menus[i] = {}
					if globalFlag
						globalFlag = 0
					else
						break
				# 移除无数据对象
				menus = []
				loop
					break unless data.menus.length
					temp = data.menus.shift()
					menus.push temp if temp.id
				data.menus = menus

				## 处理权限数据
				@processPermission data.permissions, Utils.clone menus
				console.log '权限数据: ', data.permissions
				## 缓存数据
				arr = ['token', 'admin', 'menus', 'permissions', 'topics', 'config']
				for key in arr
					if typeof data[key] is 'string'
						localStorage.setItem key, data[key]
					else
						localStorage.setItem key, JSON.stringify data[key]
					@$store.state[key] = data[key]

				# 提示登录成功
				vm.$notify
					type: 'success'
					title: '登录成功'
					message: '您已成功登录'

				# 登录成功跳转页面
				target = name: 'dialogue'
				target = path: @$route.query.redirect if @$route.query.redirect
				@$router.push target

			.catch (err) =>
				@login_loading = false
				console.log err
				# 提示登录失败
				@showErrorNotify err.data.msg

		# 显示登录失败的提示
		showErrorNotify: (msg) ->
			vm.$notify
				type: 'error'
				title: '登录失败'
				message: msg

		# 验证字段
		validate: ->
			username = @username.trim()
			password = @password.trim()
			switch true
				when not username
					msg = '请输入用户名'
				when not password
					msg = '请输入密码'

			if msg
				@showErrorNotify msg
				1
			else
				0

		# 处理权限数据
		processPermission: (target, data) ->
			return unless data.length
			id = 0
			id = target.id unless target instanceof Array
			i = 0
			while i < data.length
				item = data[i]
				if item.pid is 0
					target.push item
					data.remove item
					continue
				else if item.pid is id
					key = 'children'
					key = 'permissions' unless item.type
					target[key] ?= []
					target[key].push item
					data.remove item
					continue
				i++
			target = target.children if id
			@processPermission item, data for item in target if target
'use strict'
import axios from 'axios'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		username: ''
		password: ''
		login_loading: false
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
		# 获取服务器时间
		axios
			.get ALPHA.API_PATH.common.timestamp
			.then (res) =>
				# 保存服务器时间差值
				@$store.state.timeDiff = timeDiff = +new Date() - res.data
				localStorage.setItem 'timeDiff', timeDiff
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
		# Event: submit for login
		eventSubmit: (event) ->
			event.preventDefault()
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
				## 处理权限数据
				@processPermission data.permissions, data.menus
				console.log '权限数据: ', data.permissions
				## 缓存数据
				arr = ['token', 'admin', 'permissions', 'topics', 'config']
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
				vm.$notify
					type: 'error'
					title: '登录失败'
					message: err.msg

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
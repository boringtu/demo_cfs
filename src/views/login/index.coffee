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

	methods:
		# Event: submit for login
		eventSubmit: (event) ->
			event.preventDefault()
			@login_loading = true
			data =
				account: @username
				password: @password
			# 发起登录请求
			Utils.ajax ALPHA.API_PATH.common.login,
				method: 'POST'
				data: data
			.then (res) =>
				@login_loading = false
				data = res.data
				data.permission = data.menus
				## 缓存数据
				arr = ['token', 'adminId', 'permission']
				for key in arr
					localStorage.setItem key, data[key]
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
				console.log err
				# 提示登录失败
				vm.$notify
					type: 'error'
					title: '登录失败'
					message: err.msg
'use strict'
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
				## 缓存数据
				# token
				localStorage.setItem 'token', data.token
				# 客服 ID
				localStorage.setItem 'adminId', data.adminId
				# 客服权限
				localStorage.setItem 'permission', data.menus
				@$store.state.permission = data.menus

				# 提示登录成功
				vm.$notify
					type: 'success'
					title: '成功'
					message: '您已成功登录'

				# 登录成功跳转页面
				target = name: 'dialogue'
				target = path: @$route.query.redirect if @$route.query.redirect
				@$router.push target

			.catch (err) =>
				console.log err
import Vue from 'vue'
import Router from 'vue-router'

import ViewLogin from '@/views/login'
import ComponentFrame from '@/components/frame'

Vue.use Router

export default new Router
	mode: 'history'
	base: process.env.BASE_URL
	routes: [
		path: '/'
		redirect: '/login'
	,
		# 登录页
		path: '/login'
		name: 'login'
		component: ViewLogin
	,
		# 公共框架页
		path: '/base'
		name: 'base'
		redirect: '/dialogue'
		component: ComponentFrame
		children: [
			path: '/dialogue/:id?'
			name: 'dialogue'
			component: (resolve) => require ["./views/dialogue"], resolve
		]
	]

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
			component: (resolve) => require ["@/views/dialogue"], resolve
		,
			# 内部协同
			path: '/synergy'
			name: 'synergy'
			component: (resolve) => require ["@/views/synergy"], resolve
			children: [
				path: 'addService/:id?'
				name: 'addService'
				component: (resolve) => require ["@/views/synergy/addService"], resolve
			]
		,
			# 配置管理
			path: '/configuration'
			name: 'configuration'
			redirect: '/configuration/setStyle'
		,
			# 配置管理 - 设置样式
			path: '/configuration/setStyle'
			name: 'setStyle'
			component: (resolve) => require ["@/views/configuration/setStyle"], resolve
		,
			# 配置管理 - 对话设置
			path: '/configuration/setDialogue'
			name: 'setDialogue'
			component: (resolve) => require ["@/views/configuration/setDialogue"], resolve
		,
		# 配置管理 - 客户信息收集设置
		path: '/configuration/setUserMsg'
		name: 'setUserMsg'
		component: (resolve) => require ["@/views/configuration/setUserMsg"], resolve
		]
	]

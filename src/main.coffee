import '@babel/polyfill'
import Vue from 'vue'
import App from './App.vue'
import store from './store'
import router from './router'
import axios from 'axios'
import VueAxios from 'vue-axios'
import { EmojiPickerPlugin } from 'vue-emoji-picker'
import ALPHA from '@/assets/scripts/alpha'
import Utils from '@/assets/scripts/utils'
import Velocity from 'velocity-animate'
import 'velocity-animate/velocity.ui'
# import SockJS from '@/assets/scripts/sockjs.min'
# import Stomp from '@/assets/scripts/stomp'
# import ElementUI from 'element-ui'
import {
	Input
	Button
	Notification
} from 'element-ui'

import 'element-ui/lib/theme-chalk/index.css'

Vue.use EmojiPickerPlugin
Vue.use VueAxios, axios
# Vue.use ElementUI
Vue.use Input
Vue.use Button

Vue.prototype.$notify = Notification

Vue.config.productionTip = false

# window.SockJS = SockJS
# window.Stomp = Stomp

# 响应拦截器
axiosInterceptor = axios.interceptors.response.use (res) ->
	data = res.data
	if data.state
		# 如果响应 CODE 非 0 时，强制进入 reject
		axios.interceptors.response.handlers[axiosInterceptor].rejected res
	else
		data
, (err) ->
	data = err.data
	code = data.state
	gotoLogin = (msg) ->
		# vm.$store.state.needLogin 这个参数只在路由改变的时候 delete
		vm.$store.state.needLogin = 1
		vm.$notify
			type: 'warning'
			title: '警告'
			message: msg
		# 清空缓存的 token、客服 ID，和 权限数据
		ALPHA.clearPermission()
		# 跳转到登录页面
		vm.$router.push name: 'login', query: redirect: vm.$route.fullPath
	switch code
		when ALPHA.RES_CODE.MISSING_PARAMETERS
			console.error '缺少参数'
		when ALPHA.RES_CODE.SIGN_ERROR
			console.error '签名错误'
			unless ALPHA.token
				break if vm.$store.state.needLogin
				console.warn 'token 丢失'
				gotoLogin '请您登录'
		when ALPHA.RES_CODE.OVERTIME
			console.error '请求参数的时间戳不在服务器系统时间 5 分钟范围内'
		when ALPHA.RES_CODE.TOKEN_OVERTIME, ALPHA.RES_CODE.LOGIN_ERROR, ALPHA.RES_CODE.LOGIN_OVERTIME
			break if vm.$store.state.needLogin
			if code in [ALPHA.RES_CODE.TOKEN_OVERTIME, ALPHA.RES_CODE.LOGIN_OVERTIME]
				msg = '登录过期，请重新登录'
			else
				msg = '请您登录'
			gotoLogin msg
	Promise.reject err


router.beforeEach (to, from, next) ->
	delete vm.$store.state.needLogin if window.vm and not /^\/login/.test to.fullPath
	next()

router.afterEach (to, from) ->
	# 页面滚动到顶部
	document.documentElement.scrollTop = 0
	document.body.scrollTop = 0

window.vm = new Vue {
	store
	router
	beforeCreate: ->
		# 加载服务器时间差值
		@$store.state.timeDiff = ~~localStorage.getItem 'timeDiff'

		Utils.ajax = Utils.ajax.bind @
	render: (h) => h App
}
.$mount '#app'
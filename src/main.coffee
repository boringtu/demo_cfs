import Vue from 'vue'
import App from './App.vue'
import store from './store'
import router from './router'
import axios from 'axios'
import VueAxios from 'vue-axios'
import ALPHA from '@/assets/scripts/alpha'
import Utils from '@/assets/scripts/utils'
# import ElementUI from 'element-ui'
import {
	Input
	Button
	Notification
} from 'element-ui'

import 'element-ui/lib/theme-chalk/index.css'

Vue.use VueAxios, axios
# Vue.use ElementUI
Vue.use Input
Vue.use Button

Vue.prototype.$notify = Notification


Vue.config.productionTip = false

# 响应拦截器
axiosInterceptor = axios.interceptors.response.use (res) ->
	data = res.data
	if data.state
		# 如果响应 CODE 非 0 时，强制进入 reject
		axios.interceptors.response.handlers[axiosInterceptor].rejected res
	else
		data
, (err) ->
	console.error err
	data = err.data
	code = data.state
	switch code
		when ALPHA.RES_CODE.MISSING_PARAMETERS
			console.error '缺少参数'
		when ALPHA.RES_CODE.SIGN_ERROR
			console.error '签名错误'
		when ALPHA.RES_CODE.OVERTIME
			console.error '请求参数的时间戳不在服务器系统时间 5 分钟范围内'
		when ALPHA.RES_CODE.TOKEN_OVERTIME, ALPHA.RES_CODE.LOGIN_ERROR
			if code is ALPHA.RES_CODE.TOKEN_OVERTIME
				vm.$notify
					type: 'warning'
					title: '警告'
					message: '登录超时，请重新登录'
			# 清空缓存的 token、客服 ID，和 权限数据
			ALPHA.clearPermission()
			# 跳转到登录页面
			vm.$router.push name: 'login', query: redirect: vm.$route.fullPath
	Promise.reject err

# 获取服务器时间
axios
	.get ALPHA.API_PATH.common.timestamp
	.then (res) ->
		# 保存服务器时间差值
		vm.$store.state.timeDiff = +new Date() - res.data
	.catch (err) ->
		console.error '服务器时间获取失败'

router
	.afterEach (to, from) ->
		# 页面滚动到顶部
		document.documentElement.scrollTop = 0
		document.body.scrollTop = 0

window.vm = new Vue {
	store
	router
	beforeCreate: ->
		Utils.ajax = Utils.ajax.bind @
	render: (h) => h App
}
.$mount '#app'
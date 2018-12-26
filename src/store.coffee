import Vue from 'vue'
import Vuex from 'vuex'

Vue.use Vuex

export default new Vuex.Store {
	state: {
		# 与服务器时间差值
		timeDiff: null
		# 访客字典（key 为 id）
		visitorMap: []
	},
	mutations: {

	},
	actions: {

	}
}

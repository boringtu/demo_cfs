import Vue from 'vue'
import Vuex from 'vuex'

Vue.use Vuex

export default new Vuex.Store {
	state: {
		# WebSocket 实例
		ws: null
		# 与服务器时间差值
		timeDiff: null
		# 正在进行中的会话列表
		chattingList: []
		# 已关闭的会话列表
		closedList: []
		# 当前会话ID
		dialogID: null
		# 当前会话数据
		dialogInfo: null


		# 访客字典（key 为 id）
		visitorMap: []
	},
	mutations: {

	},
	actions: {

	}
}

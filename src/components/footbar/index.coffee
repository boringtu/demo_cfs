'use strict'
import Utils from '@/assets/scripts/utils'

export default

	computed:
		# 当前访问量（正在进行中的会话人数
		chattingCount: -> @$store.state.chattingList.length
		# 今日访问量
		todayCount: -> @$store.state.todayCount
		# 客服信息
		admin: -> ALPHA.admin or {}

	mounted: ->
		Utils.ajax ALPHA.API_PATH.dialogue.todayCount
		.then (res) =>
			@$store.state.todayCount = +res.data
'use strict'

export default

	computed:
		# 当前访问量（正在进行中的会话人数
		chattingCount: -> @$store.state.chattingList.length
		# 今日访问量
		todayCount: -> 0
		# 客服信息
		admin: -> ALPHA.admin or {}

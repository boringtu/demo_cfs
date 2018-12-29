'use strict'

export default

	computed:
		# 正在进行中的会话人数
		chattingCount: -> @$store.state.chattingList.length
		# 客服 ID
		adminId: -> ALPHA.adminId

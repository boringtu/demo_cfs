'use strict'
# import chatHistory from '@/components/chatHistory/chatHistory'
# import chatFooter from '@/components/chatFooter/chatFooter'
import Utils from '@/assets/scripts/utils'
export default

	components: {
		# chatFooter
		# chatHistory
	}
	computed: ->
		admin: -> ALPHA.admin or {}

	methods:
		# Event: 退出按钮点击事件
		eventExit: (isForcible) ->
			type = 'success'
			title = '退出登录'
			if +isForcible
				type = 'warning'
				title = '登录失效，请重新登录'
			data =
				adminId: ALPHA.admin.adminId
			Utils.ajax ALPHA.API_PATH.common.logout,
				method: 'post'
				data: data
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: type
						title: title
					@$router.push path: '/login'
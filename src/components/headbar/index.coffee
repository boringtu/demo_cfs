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
	created: ->

	mounted: ->
		console.log ALPHA.admin
	methods:
		# Event: 设置按钮点击事件
		eventSetting: (event) ->

		# Event: 退出按钮点击事件
		eventExit: (event) ->
			console.log ALPHA.admin
			data =
				adminId: ALPHA.admin.adminId
			Utils.ajax ALPHA.API_PATH.common.logout,
				method: 'post'
				data: data
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '退出登录'
					@$router.push({path:'/login'})
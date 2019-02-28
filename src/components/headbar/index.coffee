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

	mounted: ->
		window.addEventListener 'load', => @eventWindowLoad()
		window.addEventListener 'unload', => @eventWindowUnload()

	methods:
		# Event: window load
		eventWindowLoad: ->
			leaveTime = localStorage.getItem 'leaveTime'
			localStorage.removeItem 'leaveTime'
			return unless leaveTime
			nowTime = +new Date()
			# 差值超过 5 秒则登出
			@eventExit 1 if nowTime - leaveTime > 5000

		# Event: window unload
		eventWindowUnload: ->
			localStorage.setItem 'leaveTime', +new Date()

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
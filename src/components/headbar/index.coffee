'use strict'
# import chatHistory from '@/components/chatHistory/chatHistory'
# import chatFooter from '@/components/chatFooter/chatFooter'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		isOnLine: localStorage.getItem 'lineStatus' || 1
		onLineStatus: '在线'
		offLineStatus: '离开'
		lineStatusList: [
			{icon: 'icon-online', text: '在线', class: "on_line" , id: 1}
			{icon: 'icon-afk', text: '离开', class: 'off_line', id: 0}
		]
		isShowSlideCont: false
	created: ->
		console.log "ss", localStorage.getItem 'lineStatus'
	mounted: ->
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
		chooseLineStatus: ->
			@isShowSlideCont = !@isShowSlideCont
		chooseCheckedStatus: (item) ->
			@isOnLine = item.id
			data =
				online: item.id
			Utils.ajax ALPHA.API_PATH.common.lineStatus, params: data
			.then (res) => 
				console.log res.data
			localStorage.setItem 'lineStatus', item.id
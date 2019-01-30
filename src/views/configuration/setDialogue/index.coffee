'use strict'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		isloading: false
		isDisabled: true
		welcomeCont: ''
	created: ->
		@fetchInitSetting()
	methods:
		contChange: ->
			@isDisabled = false
		# 保存
		saveSetDialogue: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.dialogueModifiable
			isloading = true
			params =
				msgContent: @welcomeCont
				autoSendOnStart: 1
			Utils.ajax ALPHA.API_PATH.configManagement.saveWelcomeSentence,
				method: 'put'
				data: params
			.then (res) =>
				isloading = false
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
					@isDisabled = true
		# 恢復默認設置
		recoverDefault: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.dialogueModifiable
			params =
				type: 'welcome_msg'
			Utils.ajax ALPHA.API_PATH.configManagement.recoverDefaultSet,
				method: 'put'
				data: params
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '已恢复默认设置'
					@fetchInitSetting()
		# 默认欢迎语
		fetchInitSetting: ->
			data =
				adminId: ALPHA.admin.adminId
				type: 'welcome_msg'
			Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence, params: data
			.then (res) => 	
				if res.msg is 'success' && res.data.sys_conf
					@welcomeCont = item.value for item in res.data.sys_conf when item.key is 'msg_content'

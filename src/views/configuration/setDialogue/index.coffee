'use strict'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		isloading: false
		isDisabled: true
		welcomeCont: ''
		menuList: [
			{id: 0, text: '欢迎语设置'}
			{id: 1, text: '自动分配'}
		]
		activeMenu: 0
		autoDistributeVal: true
		activedRadio: true
		activedCheckbox: true
		autoIsloading: false
		atuoIsDisabled: true
		isShowPop: false
		isOpen: true
	created: ->
		@fetchInitSetting()
	methods:
		contChange: ->
			@isDisabled = false
		# 保存
		saveSetDialogue: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.dialogueModifiable
			@isloading = true
			params =
				msgContent: @welcomeCont
				autoSendOnStart: 1
			Utils.ajax ALPHA.API_PATH.configManagement.saveWelcomeSentence,
				method: 'put'
				data: params
			.then (res) =>
				@isloading = false
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
					@isDisabled = true
		# 恢復默認設置
		recoverDefault: ->
			# docScrollTop = document.documentElement.scrollTop || document.body.scrollTop
			# console.log docScrollTop
			# return document.body.scrollTop = document.documentElement.scrollTop = 0
			# console.log(document.documentElement.scrollTop)
			if @activeMenu is 0 # 欢迎语
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
						@isShowPop = false
						@fetchInitSetting()
			if @activeMenu is 1 #自动分配
				console.log '自动分配'
				@isShowPop = false
		# 默认欢迎语
		fetchInitSetting: ->
			data =
				adminId: ALPHA.admin.adminId
				type: 'welcome_msg'
			Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence, params: data
			.then (res) => 	
				if res.msg is 'success' && res.data.sys_conf
					@welcomeCont = item.value for item in res.data.sys_conf when item.key is 'msg_content'
		# 自动分配
		radioCheck: ->
			@atuoIsDisabled = false
			@activedRadio = !@activedRadio
		switchDistribute: ->
			@isOpen = !@isOpen
			@atuoIsDisabled = false
		# 优先分配
		boxIsChecked: ->
			@atuoIsDisabled = false
		# 选择优先分配
		boxIsChecked: ->
			@activedCheckbox = !@activedCheckbox
		# 自动分配保存
		saveAutoDistribute: ->



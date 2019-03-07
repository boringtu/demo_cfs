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
		isOpen: false
		showWarn: false
	created: ->
		@fetchInitSetting()
	methods:
		contChange: ->
			@isDisabled = false
			if @showWarn
				@showWarn = false
		# 保存
		saveSetDialogue: ->
			if !@welcomeCont
				this.$refs.focusTextarea.focus()
				return @showWarn = true
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
		openConfirmPop: ->
			if @activeMenu is 0 # 欢迎语
				# 鉴权
				return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.dialogueModifiable
			else
				# 鉴权
				return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.distributable
			@isShowPop = true
		# 恢復默認設置
		recoverDefault: ->
			# docScrollTop = document.documentElement.scrollTop || document.body.scrollTop
			# console.log docScrollTop
			# return document.body.scrollTop = document.documentElement.scrollTop = 0
			# console.log(document.documentElement.scrollTop)
			if @activeMenu is 0 # 欢迎语
				params =
					type: 'welcome_msg'
				@commonRecoverDefault(params)
				
			if @activeMenu is 1 #自动分配
				params =
					type: 'auto_take'
				@commonRecoverDefault(params)
				
		commonRecoverDefault: (params)->
			Utils.ajax ALPHA.API_PATH.configManagement.recoverDefaultSet,
				method: 'put'
				data: params
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '已恢复默认设置'
					@isShowPop = false
					if @activeMenu is 0
						@fetchInitSetting()
					else
						@fetchAutoSetting()
				else
					vm.$notify
						type: 'warn'
						title: res.msg
		changeMenu: (item)->
			@activeMenu = item.id
			if @activeMenu is 1
				@fetchAutoSetting()
		# 默认欢迎语
		fetchInitSetting: ->
			data =
				adminId: ALPHA.admin.adminId
				type: 'welcome_msg'
			Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence, params: data
			.then (res) => 	
				if res.msg is 'success' && res.data.sys_conf
					@welcomeCont = item.value for item in res.data.sys_conf when item.key is 'msg_content'
		fetchAutoSetting: ->
			data =
				adminId: ALPHA.admin.adminId
				type: 'auto_take' 
			Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence, params: data
			.then (res) => 
				if res.msg is 'success' && res.data.sys_conf
					for item in res.data.sys_conf
						switch item.key
							when 'auto_take_open'
								@isOpen = +item.value is 1
							when 'is_order'
								@activedRadio = +item.value is 1
							when 'is_admin_first'
								@activedCheckbox = +item.value is 1
		# 自动分配开关
		switchChange: ->
			@atuoIsDisabled = false
		# 选择优先分配
		boxIsChecked: ->
			@atuoIsDisabled = false
			@activedCheckbox = !@activedCheckbox
		# 自动分配保存
		saveAutoDistribute: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.distributable
			autoIsloading = true
			if @isOpen
				switchNum = 1
			else
				switchNum = 0
			if @activedCheckbox
				@activedCheckbox = 1
			else
				@activedCheckbox = 0
			params =
				autoTakeOpen: switchNum
				isAdminFirst: @activedCheckbox
			Utils.ajax ALPHA.API_PATH.configManagement.saveAutoDistribute,
				method: 'put'
				data: params
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
					@atuoIsDisabled = true
				else
					vm.$notify
						type: 'warn'
						title: res.msg




'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		sumPersonNum: 10
		popTitle: '添加分组'
		confirmTitle: '确定禁用该客服？'
		addGroupName: ''
		saveBlock: false
		isShowAddNewPop: false
		isShowConfirmPop: false
		allGroupList: ''
		serveListDetail: ''
		groupItemId: ''
		confirmPopStatus: 0
		serverItemId: ''
	mounted: ->
		@getInitData()

	methods:
		# 添加分组
		addNewGroup: ->
			@isShowAddNewPop = true
			@saveBlock = false
			@addGroupName = ''

		#编辑分组 
		editGroup: (item) ->
			@isShowAddNewPop = true
			@popTitle = '修改分组名称'
			@addGroupName = item.name

		# 删除分组
		deleteGroup: (item) ->
			@isShowConfirmPop = true
			@groupItemId = item.id
			@confirmTitle = '确定删除该分组？'
			@confirmPopStatus = 0
		# 添加客服
		addNewServer: ->
			@$router.push({path:'/synergy/addService'})
		#编辑客服 
		editServer: (item) ->
		# 启用或者禁用客服
		userServer: (item) ->
			@serverItemId = item.id
			@isShowConfirmPop = true
			if item.status is 1
				@confirmPopStatus = 2
				@confirmTitle = '确定启用该客服？'
			else
				@confirmPopStatus = 1
				@confirmTitle = '确定禁用该客服？'
		# 删除客服
		deleteServer: (item) ->
			@serverItemId = item.id
			@confirmPopStatus = 3
			@isShowConfirmPop = true
			@confirmTitle = '确定删除该客服？'
		# 保存添加或修改新的分组
		saveAddNew: ->
			return @saveBlock = true if @addGroupName is ''
			for item in @allGroupList when item.name is @addGroupName
				vm.$notify
					type: 'error'
					title: '提示'
					message: '列表已存在该分组名称，请勿重复添加'
				return

			Utils.ajax ALPHA.API_PATH.synergy.group,
				method: 'POST'
				data: 
					name: @addGroupName
			.then (res) =>
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '提示'
						message: '添加成功'
					@isShowAddNewPop = false
					@getInitData()

		# 添加分组弹窗中的取消
		cancelAddNew: ->
			@isShowAddNewPop = false
		#取消 
		cancelConfirmPop: ->
			@isShowConfirmPop = false
		# 确定
		sureConfirmPop: ->
			if @confirmPopStatus is 0
				Utils.ajax ALPHA.API_PATH.synergy.deleted,
					method: 'delete'
					params: 
						id: @groupItemId
				.then (res) =>
					if res.msg is 'success'
						vm.$notify
							type: 'success'
							title: '提示'
							message: '删除成功'
						@isShowConfirmPop = false
						@getInitData()
			else if @confirmPopStatus is 1 or @confirmPopStatus is 2
				Utils.ajax ALPHA.API_PATH.synergy.disabledServe,
					method: 'put'
					data:
						id: @serverItemId
						status: @confirmPopStatus
				.then (res) =>
					if res.msg is 'success'
						vm.$notify
							type: 'success'
							title: '提示'
							message: '操作成功'
						@isShowConfirmPop = false
						@getInitData()
			else if @confirmPopStatus is 3
				Utils.ajax ALPHA.API_PATH.synergy.deletedServe,
					method: 'delete'
					params: 
						id: @serverItemId
				.then (res) =>
					if res.msg is 'success'
						vm.$notify
							type: 'success'
							title: '提示'
							message: '删除成功'
						@isShowConfirmPop = false
						@getInitData()


		# 获取初始化数据
		getInitData: ->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				@allGroupList = res.data.groups
				@serveListDetail = res.data.admins
'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
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
		managerNum: 0 
		serverNum: 0
		disabledNum: 0
		# 当前选中的分组 ID
		activeGroupId: 0
		
	watch:
		$route: (to) ->
			@getInitData() if to.name is 'synergy'
	mounted: ->
		@getInitData()
	methods:
		# 添加分组
		addNewGroup: ->
			@isShowAddNewPop = true
			@saveBlock = false
			@addGroupName = ''
			@saveStatus = 1

		#编辑分组 
		editGroup: (item) ->
			@isShowAddNewPop = true
			@popTitle = '修改分组名称'
			@addGroupName = item.name
			@editId = item.id
			@saveStatus = 2

		# 删除分组
		deleteGroup: (item) ->
			@isShowConfirmPop = true
			@groupItemId = item.id
			@confirmTitle = '确定删除该分组？'
			@confirmPopStatus = 0
		# 添加客服
		addNewServer: ->
			@$router.push({name: 'addService'})
			@$store.state.menuServeIdList = []
			@$store.state.menuManagerIdList = []
			Utils.ajax ALPHA.API_PATH.synergy.defaultpermission
			.then (res) =>
				for item in res.data
					if item.id is 2
						for item1 in item.menus
							@$store.state.menuServeIdList.push(item1.id)
					else if item.id is 1
						for item1 in item.menus
							@$store.state.menuManagerIdList.push(item1.id)
		#编辑客服 
		editServer: (item) ->
			@$router.push({name: 'addService', params: { id: item.id }}) if item.id
			@$store.state.serverListItem = item
		# 启用或者禁用客服
		userServer: (item) ->
			@serverItemId = item.id
			@isShowConfirmPop = true
			if item.status is 2
				@confirmPopStatus = 1
				@confirmTitle = '确定启用该客服？'
			else
				@confirmPopStatus = 2
				@confirmTitle = '确定禁用该客服？'
		# 删除客服
		deleteServer: (item) ->
			@serverItemId = item.id
			@confirmPopStatus = 3
			@isShowConfirmPop = true
			@confirmTitle = '确定删除该客服？'
		# 筛选分组
		clickGroupItem: (groupItem) ->
			@activeGroupId = groupItem.id
		# 保存添加或修改新的分组
		saveAddNew: ->
			return @saveBlock = true if @addGroupName is ''
			for item in @allGroupList when item.name is @addGroupName
				vm.$notify
					type: 'error'
					title: '提示'
					message: '列表已存在该分组名称，请勿重复添加'
				return
			if @saveStatus is 1
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
			else if @saveStatus is 2
				Utils.ajax ALPHA.API_PATH.synergy.group,
					method: 'put'
					data: 
						name: @addGroupName
						id: @editId
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
			# 删除分组 
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
			# 禁用或者启用客服
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
			# 删除客服
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
				@$store.state.allGroupList = res.data.groups;
				@serveListDetail = res.data.admins
				@serveListDetail = @serveListDetail.concat @serveListDetail
				serverRoleList = @serveListDetail.filter (item) ->
					item.roleId is 2
				managerRoleList = @serveListDetail.filter (item) ->
					item.roleId is 1
				disabledRoleist = @serveListDetail.filter (item) ->
					item.status is 1
				@serverNum = serverRoleList.length
				@managerNum = managerRoleList.length
				@disabledNum = disabledRoleist.length
'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		serverId: ''
		serverName: ''
		serverNickName: ''
		roleId: 2
		groupId: 0
		password: ''
		confirmPassword: ''
		defaultInfo: ''
		IdIsDisabled: false
		allGroupList: []
		allPermissionList: []
		allPermissionTreeList: []
		checkAll: false
		checkItems: []
		menuIDs: []
		serverIdIsRepeat: false
		userId: ''
		saveIsDisabled: true
		defaultPwd: ''
		defaultShowPwd: '!13&6fa^'
	watch:
		$route: (to) ->
			# @initData() if to.name is 'addService'
	
	created: ->
		
	# filters: 
	# 	isHasPermission: (id, menuIDs) ->
	# 		menuIDs.some (item) -> item is id
	mounted: ->
		RouterId = @$route.params.id
		if !@$store.state.allGroupList
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				if RouterId
					@$store.state.allGroupList = res.data.groups
					tempList = res.data.admins
					for item in tempList
						if +item.id is +RouterId
							@getGefaultInfo = item
					# 每次编辑带过来默认显示的数据
					@$store.state.serverListItem = @getGefaultInfo
			# 如果没有store的时候，获取客服和管理员默认的权限
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
			setTimeout (=> 
				@initData()
				@allGroupList = @$store.state.allGroupList
				@getAllpermission()
			), 500
		else
			@initData()
			@allGroupList = @$store.state.allGroupList
			@getAllpermission()

	methods:
		# 如果没有store的时候，获取客服和管理员默认的权限
		getDefaultPermission: ->
			Utils.ajax ALPHA.API_PATH.synergy.defaultpermission
			.then (res) =>
				for item in res.data
					if item.id is 2
						for item1 in item.menus
							@$store.state.menuServeIdList.push(item1.id)
					else if item.id is 1
						for item1 in item.menus
							@$store.state.menuManagerIdList.push(item1.id)
		#取消 
		cancelSaveAccountInfo: ->
			@$router.push({name: 'synergy'})
		inputChange: ->
			@saveIsDisabled = false
		# 保存
		saveAccountInfo: ->
			console.log "del",@defaultPwd
			regPwd = /^(?!\d+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$/
			regId = /^\w+$/g
			# regName = /^[\u4E00-\u9FA5\w*!@#$%^&~]+$/
			if !@serverId
				return @warnPop('请输入ID')
			if !regId.test(@serverId)
				return @warnPop('客服ID只能输入数字字母或者下划线')
			if @serverIdIsRepeat
				return @warnPop('客服ID已经存在')
			if !@serverName
				return @warnPop('请输入姓名')
			if !@serverNickName
				return @warnPop('请输入昵称')
			if !@password
				return @warnPo p('请输入密码')
			if !@confirmPassword
				return @warnPop('请输入确认密码')
			if @defaultPwd and @password is @defaultShowPwd and @confirmPassword is @defaultShowPwd
				@password = @confirmPassword = @defaultPwd
			
			if @password isnt @defaultPwd
				if @password.length < 8
					return @warnPop('密码长度为8-20个字符')
				if !regPwd.test(@password)
					return @warnPop('密码必须包含数字和字母')
				if @confirmPassword isnt @password
					return @warnPop('密码输入不一致，请重新输入')
			menuIdslist = []
			for item in @allPermissionTreeList
				if item.children
					for item1 in item.children
						for item2 in item1.permissions
							if item2.checkStatus
								menuIdslist.push item2.id
				else
					for item3 in item.permissions
						if item3.checkStatus
							menuIdslist.push item3.id
			if @password is @defaultPwd
				savePwd =  @defaultPwd
			else
				savePwd = "#{ @password }#{ ALPHA.SUFFIX }".md5().toUpperCase()
			if @$route.params.id
				Utils.ajax ALPHA.API_PATH.synergy.addadmin,
					method: 'put'
					data:
						menuIds: menuIdslist.join(',') or ''
						# account: @serverId
						id: @userId
						name: @serverName
						nickname: @serverNickName
						roleId: @roleId
						groupId: @groupId
						password: savePwd
				.then (res) =>
					if res.msg is 'success'
						vm.$notify
							type: 'success'
							title: '提示'
							message: '保存成功'
						@$router.push({name: 'synergy'})
			else
				Utils.ajax ALPHA.API_PATH.synergy.addadmin,
					method: 'post'
					data:
						menuIds: menuIdslist.join(',') or ''
						account: @serverId
						name: @serverName
						nickname: @serverNickName
						roleId: @roleId
						groupId: @groupId
						password: "#{ @password }#{ ALPHA.SUFFIX }".md5().toUpperCase()
				.then (res) =>
					if res.msg is 'success'
						vm.$notify
							type: 'success'
							title: '提示'
							message: '保存成功'
						@$router.push({name: 'synergy'})

		# 提示框
		warnPop:(msg)->
			vm.$notify
				type: 'error'
				title: '提示'
				message: msg
		# 初始化复选框的类别
		getAllpermission: ->
			Utils.ajax ALPHA.API_PATH.synergy.permission
			.then (res) =>
				# 全部权限 - 一维数组
				@allPermissionList = Utils.clone res.data
				## 处理权限数据
				res.permissions = []
				@processPermission res.permissions, res.data
				# 全部权限 - 树状结构
				@allPermissionTreeList = res.permissions
				if @$route.params.id
					@menuIDs = @$store.state.serverListItem.menuIds.split(',').map (id) -> +id
				else
					@menuIDs = @$store.state.menuServeIdList
				@checkSameId(@allPermissionTreeList, @menuIDs)
				
		checkSameId: (permissionList, menuIds) ->
			for item in permissionList
				if item.children
					for item1 in item.children
						for item2 in item1.permissions
							item2.checkStatus = false
							for id in menuIds
								if item2.id is id
									item2.checkStatus = true
				else
					for item3 in item.permissions
						item3.checkStatus = false
						for id in menuIds
							if item3.id is id
								item3.checkStatus = true
		# 选择角色和管理员 
		roleChange: (val)->
			if val is 1
				@menuIDs = @$store.state.menuManagerIdList
			if val is 2
				@menuIDs = @$store.state.menuServeIdList
			# console.log @allPermissionTreeList, @menuIDs
			@checkSameId(@allPermissionTreeList, @menuIDs)
		# 检查客服ID是否重复
		checkIdIsRepeat: -> 
			Utils.ajax ALPHA.API_PATH.synergy.check,
				params: account: @serverId
			.then (res) =>
				if res.data
					@serverIdIsRepeat = true
					return @warnPop("客服ID已被使用")
				else
					@serverIdIsRepeat = false
		# 复选框选中与不选中状态
		boxIsChecked: (item, index, parentIndex, grandFatherIndex)->
			@saveIsDisabled = false
			@$forceUpdate();
			item.checkStatus = !item.checkStatus
			return if item.checkStatus
			if grandFatherIndex and  index is 0
				@allPermissionTreeList[grandFatherIndex].children[parentIndex].permissions.forEach (item) =>
					item.checkStatus = false
			if index is 0
				@allPermissionTreeList[parentIndex].permissions.forEach (item) =>
					item.checkStatus = false
		initData: ->
			routerId = @$route.params.id
			# 编辑时带过来的数据
			if routerId
				@IdIsDisabled = true
				@allGroupList = @$store.state.allGroupList
				@defaultInfo = list = @$store.state.serverListItem
				@menuIDs = @$store.state.serverListItem.menuIds.split(',').map (id) -> +id
				@serverId = list.account
				@serverName = list.name
				@serverNickName = list.nickname
				@roleId = list.roleId
				@groupId = list.groupId
				@userId = list.id
				@defaultPwd = @password = @confirmPassword = list.password
				@password = @confirmPassword = @defaultShowPwd
			# 新增客服时
			else
				@menuIDs = @$store.state.menuServeIdList
				@IdIsDisabled = false
				@serverId = ''
				@serverName = ''
				@serverNickName = ''
				@password = @confirmPassword = ''
		# 处理权限数据
		processPermission: (target, data) ->
			return unless data.length
			id = 0
			id = target.id unless target instanceof Array
			i = 0
			while i < data.length
				item = data[i]
				if item.pid is 0
					target.push item
					data.remove item
					continue
				else if item.pid is id
					key = 'children'
					key = 'permissions' unless item.type
					target[key] ?= []
					target[key].push item
					data.remove item
					continue
				i++
			target = target.children if id
			@processPermission item, data for item in target if target
		

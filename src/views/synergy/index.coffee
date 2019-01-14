'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# 窗口是否显示
		dsialogFormVisible: false
		# 样式切换
		indexThis: -1
		# 窗口标题
		alertTitle: ''
		# 窗口input值
		initModel: ''
		# 窗口类型？修改or新增
		alertType: ''
		# 初始化数据赋值
		resdata: []
		groupsList: []
		adminsList: ''
		# 被禁用人数值
		peopleCount: '--'
		# 加载完成
		loadedData: false
		disbaledFont: '禁用'
		inputmsg: '请输入分组名称'
		titleinfo: '确定禁用该客服？'
		initIndex: 0
		servenumber: 0
		kefnumber: 0
		disablednumber: 0
		errorTipbox: false
		# 防止多次点击
		isxhr: false
		isclick: false
		# 是否含有input框的窗口
		hasInput: true
		# 点击对应的ID值
		operatingId: ''
		# 启动或禁用 1 => 禁用 2 => 启动
		status_init: ''
		# 分组输入框正则
		gobaleeg: /^[\u4e00-\u9fa5_a-zA-Z0-9`~!@#$%^&*()_\-+=?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]{1,20}$/
		# 当前用户是否有点击按钮的权限
		haspermissions: []
		oldval: ''
		# 分组有子客服
		hasChildrenSer: ''
	created:->
		@loadAll()
	watch:
		$route:(to)->
			@loadAll() if to.name is 'synergy'
	mounted:->
		for item in vm.$store.state.permissions
			if item.name is '内部协同'
				@haspermissions = item.permissions
	methods:
		# 判断是否有权限点击
		buttonClick:(permissionsId)->
			arr = []
			res = true
			for items,i in @haspermissions
				arr.push items.id
			if arr.indexOf(permissionsId) is -1
				vm.$notify
					type: 'error'
					title: '提示'
					message: '暂无权限点击'
				res = false
			else
				res = true
			return res
		# 点击隐藏错误提示
		hiddentip:()->
			@errorTipbox = false
			@$refs.inputBox.focus()
			@inputmsg = '请输入分组名称'
		# 删除客服
		deletedServe:(id)->
			resulte_ = @buttonClick(40)
			return no if resulte_ is no
			@hasInput = false
			@dsialogFormVisible = true
			@titleinfo = "确定删除该客服？"
			@operatingId = id
		# 禁用or启用客服
		disabeldServe:(event,index,id)->
			resulte_ = @buttonClick(39)
			return no if resulte_ is no
			@hasInput = false
			htmldom =  event.target.innerHTML
			@operatingId = id
			if htmldom is '禁用'
				@titleinfo = "确定禁用该客服？"
				@status_init = 1
				@dsialogFormVisible = true
			else if htmldom is '启用'
				@status_init = 2
				@titleinfo = "确定启用该客服？"
				@dsialogFormVisible = true
			
		# 初始化数据
		loadAll:->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				@resdata = res.data
				@groupsList = @resdata.groups
				@adminsList = res.data.admins
				@peopleCount = @adminsList.length
				@groundList(@adminsList,@resdata.groups)
		# 跳转到添加客服
		aHerf:(id)->
			resulte_ = @buttonClick(38)
			return no if resulte_ is no
			@$router.push({path:'/synergy/addService',query:{account:id}}) if id 
			@$router.push({path:'/synergy/addService'}) unless id 
		groundList:(adminsList,groupsList)->
			for grounpItems,grounpI in groupsList
				groupsList[grounpI].newVal = []
				for adminsItem,adminsI in adminsList
					if grounpItems.id is 0
						groupsList[0].newVal.push(adminsItem)
					else
						if adminsItem.groupId is grounpItems.id
							groupsList[grounpI].newVal.push(adminsItem)
			@loadRightData(@initIndex)
			@loadedData = true
		# 添加分组
		addGrouping: ->
			resulte_ = @buttonClick(34)
			return no if resulte_ is no
			@initModel = ''
			@alertType = 1
			@alertTitle = "添加分组"
			@dsialogFormVisible = true
		# 关闭窗口
		canleAlert:->
			@isxhr = false
			@isclick = false
			@hasInput = true
			@errorTipbox = false
			@inputmsg = '请输入分组名称'
			@dsialogFormVisible = false
		# 删除分组
		deleteGround:(id,number)->
			resulte_ = @buttonClick(36)
			return no if resulte_ is no
			# 删除分组时，里面有客服
			@hasChildrenSer = true  if number.length >=1
			@hasInput = false
			@dsialogFormVisible = true
			@titleinfo = "确定删除该分组？"
			@operatingId = id
		# 确定操作
		determine:(msg)->
			return no if @isclick is on
			@isclick = true
			if msg.indexOf('删除该分组') >= 1
				Utils.ajax ALPHA.API_PATH.synergy.deleted,
					method: 'delete'
					params: id:@operatingId
				.then (res) =>
					@isclick = false
					location.reload() if @hasChildrenSer is true
					vm.$notify
						type: 'success'
						title: '提示'
						message: '删除成功'
					@loadAll()
			else if msg.indexOf('删除该客服') >= 1
				Utils.ajax ALPHA.API_PATH.synergy.deletedServe,
					method: 'delete'
					params: id:@operatingId
				.then (res) =>
					@isclick = false
					@loadAll()
					vm.$notify
						type: 'success'
						title: '提示'
						message: '删除成功'
			else if msg.indexOf("启用") >= 1 or msg.indexOf("禁用") >= 1
				Utils.ajax ALPHA.API_PATH.synergy.disabledServe,
					method: 'put'
					data:
						id:@operatingId
						status:@status_init
				.then (res) =>
					@isclick = false
					@loadAll()
					vm.$notify
						type: 'success'
						title: '提示'
						message: '操作成功'
			@canleAlert()
		# 弹窗数据保存
		saveGround:->
			unless @initModel
				@errorTipbox=true
				@inputmsg = ''
				return no
			@isxhr = true
			# 添加分组
			if @alertType is 1
				for item in @resdata.groups
					if @initModel is item['name']
						vm.$notify
							type: 'error'
							title: '提示'
							message: '列表已存在该分组名称，请勿重复添加'
						@isxhr = false
						return no
				Utils.ajax ALPHA.API_PATH.synergy.group,
					method: 'POST'
					data: name:@initModel
				.then (res) =>
					@canleAlert()
					@loadAll()
					@isxhr = false
					vm.$notify
						type: 'success'
						title: '提示'
						message: '添加成功'
			# 编辑分组
			else if @alertType is 2
				if @oldval is @initModel
					@canleAlert()
					return no
				Utils.ajax ALPHA.API_PATH.synergy.edit,
					method: 'PUT'
					data:
						name:@initModel
						id:  @initId
				.then (res) =>
					@canleAlert()
					@loadAll()
					@isxhr = false
					vm.$notify
						type: 'success'
						title: '提示'
						message: '编辑成功'
		# css样式切换
		bMouseEnterFun:(index)->
			@indexThis = index
		# css样式切换
		bMouseLeaveFun:->
			@indexThis = -1
		# 右侧分组内容切换
		loadRightData:(index)->
			@servenumber = 0
			@kefnumber = 0
			@disablednumber = 0
			@initIndex = index
			for item in  @groupsList[index].newVal 
				# item.roleId == 1 ？ 管理员 ：客服
				if item.roleId is 1
					@servenumber += 1
				if item.roleId is 2
					@kefnumber += 1
				# 被禁用的人数
				if item.status is 1
					@disablednumber += 1
		# 修改分组名称
		editGround:(itemsName,id)->
			resulte_ = @buttonClick(35)
			return no if resulte_ is no
			@oldval = itemsName
			@initModel = itemsName
			@initId = id
			@alertType = 2
			@alertTitle = "修改分组名称"
			@dsialogFormVisible = true

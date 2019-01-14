'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# 表单数据
		account: ''
		name: ''
		nickname: ''
		roleId: ''
		groupId: 0
		password: ''
		grouplist: ''
		confirmpassword: ''
		uesrid: ''
		# 管理员权限列表
		Customerservice: []
		# 初始化类型 => 1 ? 管理员 : 客服
		inittype: ''
		# 切换checkbox数组对比
		adminslist: ''
		# 所有checkbox
		allCheckBox: []
		# 是否编辑页面
		isedit: false
		hasparams: false
		# 编辑页面默认权限
		initMenIds: []
		checkedData: {}
		# 表单字段正则
		acountIdReg: /^[0-9a-zA-Z_]+$/
		nameReg: /^[\u4e00-\u9fa5_a-zA-Z0-9`~!@#$%^&*()_\-+=?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]{1,20}$/
		# 默认选中 客服 和 管理员
		initkfarr: []
		initAdmin: []
		# 数组重新组成 => 默认选中的客服
		checkedKf:[]
		checkArrlist:[]
		overdata: false
		# 数组重新组成 => 默认选中的管理员
		checkedAdmin: []
		checkArrlist_admin:[]
		overdata_admin:false
	created:->
		await @getgrounds()
		await @permissionF()
		@checkedDataFun()
	watch:
		$route:(to)->
			@getgrounds() if to.name is 'addService'
			@checkedData = {}
	methods:
		# 初始化分组数据
		getgrounds:->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				@adminslist =  res.data.admins
				@grouplist = res.data.groups
				@getParams()
		# 判断是否编辑页面 or 新添加页面
		getParams:->
			if @$route.query.account
				@getAcountData(@$route.query.account) 
				@changselect(@roleId)
				@hasparams = true
			else
				# 清空表单数据
				@account = ''
				@name = ''
				@nickname = ''
				@roleId = ''
				@groupId = 0
				@password = ''
				@confirmpassword = ''
				@uesrid = ''
				@roleId = "2"
				@inittype =  2
				@hasparams = false
				@isedit = false
		# 编辑按钮 对应的客服id信息
		getAcountData:(account)->
			for item in @adminslist
				if item.id is Number(account)
					@isedit = true
					@uesrid = item.id
					@account = item.account
					@name = item.name
					@roleId = String(item.roleId)
					@nickname = item.nickname
					@password = item.password
					@confirmpassword = item.password
					@groupId = item.groupId
					# 默认的权限
					initMenIds = item.menuIds.split ','
					@initMenIds = initMenIds.map(Number)
		# checkedbox点击事件
		checkboxFs:(event,val,index)->
			# val == 14 (查看客服列表) , val == 44 (查看风格设置)
			# index == 2 (客服checkbox列表) index == 1 (管理员checkbox列表)
			# 如果没有选中 val == 14 或者 44 则所包含的子集 不可点击
			if @inittype is 2 and index is 2
				if val is 14
					if event.target.checked is no
						# 内部协同所包含的子Id数组
						for item,i in @allCheckBox
							if item['name'] is '内部协同'
								for perId,i in item.permissions
									unless perId.id is 14 
										@checkArrlist.remove perId.id
										@initMenIds.remove perId.id
				if val is 44
					if event.target.checked is no
						# 配置管理所包含的子Id数组 
						for item,i in @allCheckBox
							if item['name'] is '配置管理'
								for chilId in item.children[0].permissions
									unless chilId.id is 44 
										@checkArrlist.remove chilId.id
										@initMenIds.remove chilId.id
			else if @inittype is 1 and index is 1
				if val is 14
					if event.target.checked is no
						# 内部协同所包含的子Id数组
						for item,i in @allCheckBox
							if item['name'] is '内部协同'
								for perId,i in item.permissions
									unless perId.id is 14 
										@checkArrlist_admin.remove perId.id
										@initMenIds.remove perId.id
				if val is 44
					if event.target.checked is no
						# 配置管理所包含的子Id数组 
						for item,i in @allCheckBox
							if item['name'] is '配置管理'
								for chilId in item.children[0].permissions
									unless chilId.id is 44 
										@initMenIds.remove chilId.id
										@checkArrlist_admin.remove chilId.id
		# 检测客服id是否存在
		blurcheck:->
			Utils.ajax ALPHA.API_PATH.synergy.check,
				params: account:@account
			.then (res) =>
				if res.data
					@alertTip("客服ID已存在")
					return !1
				else
					@postForm()
		# 角色选择
		changselect:(val)->
			# inittype=1 ? 管理员 : 客服
			@inittype = 1  if Number(val) is 1
			@inittype = 2 if Number(val) is 2
		# 取消按钮返回上一层
		cancleBtn:->
			@$router.push path:'/synergy'
		# 初始化复选框的类别
		permissionF:->
			Utils.ajax ALPHA.API_PATH.synergy.permission
			.then (res) =>
				allpermission = []
				@formaData(allpermission,res.data,3)
		# 初始化 客服 与 管理员 分别默认选中的checkbox		
		checkedDataFun:()->
			Utils.ajax ALPHA.API_PATH.synergy.onlypermission
			.then (res) =>
				# 默认选中客服 => 2
				for item,index in res.data
					# 管理员权限
					if item.name is '管理员'
						newarr_first = []
						@initAdmin =  res.data[index].menus
						@formaRes(newarr_first,@initAdmin,1)
					# 客服权限
					else if item.name is '客服'
						@initkfarr = res.data[index].menus
						newarr_second = []
						@formaRes(newarr_second,@initkfarr,2)
		formaRes:(newarr,data,type)->
			@formaData(newarr,data,type)
		# 格式化数据
		formaData:(newarr,permissionList,type)->
		# type 1 (管理员) ,2(客服) 3(默认所有的复选框)
			id = 0
			i = 0
			id = newarr.id unless newarr instanceof Array
			while i < permissionList.length
				item = permissionList[i]
				if item.pid is 0
					newarr.push item
					permissionList.remove item
					continue
				else if item.pid is id
					key = 'children'
					key = 'permissions' unless item.type 
					# and item.pid is 0
					newarr[key] ?= []
					newarr[key].push item
					permissionList.remove item
					continue
				i++
			newarr = newarr.children if id
			@formaData item, permissionList for item in newarr if newarr
			if type is 1
				@checkedAdmin = newarr
				for item,i in @checkedAdmin
					if item.permissions
						for items,i in item.permissions
							@checkArrlist_admin.push items.id
				@overdata_admin = true
			else if type is 2
				@checkedKf = newarr
				for item,i in @checkedKf
					if item.permissions
						for items,i in item.permissions
							@checkArrlist.push items.id
				@overdata = true
			else if type is 3
				@allCheckBox = newarr
		# 提示框
		alertTip:(msg,msgtype)->
			vm.$notify
				type: 'error'
				title: '提示'
				message: msg
		# 保存按钮提交数据
		saveF:->
			unless @account
				@alertTip("客服ID不能为空")
				return !1
			else if(!@acountIdReg.test(@account))
				@alertTip("客服ID格式为数字、字母或下划线")
				return !1
			unless @name 
				@alertTip("姓名不能为空")
				return !1
			else if(!@nameReg.test(@name))
				@alertTip("姓名包含中文、字母、数字、特殊符号")
				return !1
			unless @nickname 
				@alertTip("昵称不能为空")
				return !1
			else if(!@nameReg.test(@name))
				@alertTip("昵称包含中文、字母、数字、特殊符号")
				return !1
			# unless @groupId 
			# 	@alertTip("请选择分组")
			# 	return !1
			unless @password 
				@alertTip("密码格式错误")
				return !1
			if !/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$/.test(@password)
				@alertTip("密码长度为8-20个字符，且至少包含数字和字母")
				return !1
			if @password isnt @confirmpassword
				@alertTip("确认密码不一样")
				return !1
			# 编辑 or 新增
			@blurcheck() if @isedit is no
			@formEdit() if @isedit is yes
		# 编辑提交
		formEdit:->
			menuIdslist = @initMenIds.join(',')
			Utils.ajax ALPHA.API_PATH.synergy.addadmin,
				method: 'put'
				data:
					# 提交代码前需要把 account 字段 去掉
					account:@account
					id:@uesrid
					menuIds:menuIdslist or ''
					name:@name
					nickname:@nickname
					roleId:@roleId
					groupId:@groupId
					password:@password
			.then (res) =>
				vm.$notify
					type: 'success'
					title: '提示'
					message: '修改成功'
				@$router.push({path:'/synergy'})
		# 新增提交
		postForm:->
			# 客服
			if @inittype is 2 
				menuIdslist = @checkArrlist.join(',')
			# 管理员
			else if @inittype is 1
				menuIdslist = @checkArrlist_admin.join(',')
			Utils.ajax ALPHA.API_PATH.synergy.addadmin,
				method: 'post'
				data:
					menuIds:menuIdslist or ''
					account:@account
					name:@name
					nickname:@nickname
					roleId:@roleId
					groupId:@groupId
					password:@password
			.then (res) =>
				vm.$notify
					type: 'success'
					title: '提示'
					message: '添加成功'
				this.$router.push({path:'/synergy'})
				
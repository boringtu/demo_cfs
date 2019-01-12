'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		# 表单数据
		account: ''
		name: ''
		nickname: ''
		roleId: ''
		groupId: ''
		password: ''
		grouplist: ''
		confirmpassword: ''
		uesrid: ''
		# 客服权限列表
		servicedata: []
		# 管理员权限列表
		Customerservice: []
		administratortype: ''
		# 初始化类型 => 1 ? 管理员 : 客服
		inittype: ''
		# 切换checkbox数组对比
		initArray_first: []
		initArray_second: []
		initArray_first_post: []
		initArray_second_post: []
		adminslist: ''
		# 是否编辑页面
		isedit: false
		hasparams: false
		# 编辑页面默认权限
		initMenIds: []
		checkedData: {}
		# 表单字段正则
		acountIdReg: /^[0-9a-zA-Z_]+$/
		nameReg: /^[\u4e00-\u9fa5_a-zA-Z0-9`~!@#$%^&*()_\-+=?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]{1,20}$/
	created:->
		await @getgrounds()
		await @getParams()
	mounted:->
		@permissionF()
	watch:
		$route:(to)->
			@getgrounds() if to.name is 'addService'
	methods:
		# 初始化分组数据
		getgrounds:->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				@adminslist =  res.data.admins
				@grouplist = res.data.groups
		# 判断是否编辑页面 or 新添加页面
		getParams:->
			if @$route.query.account
				@getAcountData(@$route.query.account) 
				@changselect(@roleId)
				@hasparams = true
			else
				@roleId = "2"
				@inittype =  2
		# 需要编辑的客服ID对应信息
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
					initMenIds = item.menuIds.split ','
					initMenIds[i] = +item for item, i in initMenIds
					@initMenIds = initMenIds
					for item in  @initMenIds
						@checkedData[item] = true
		checkboxFs:(val)->
			@$forceUpdate()
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
		# select切换
		changselect:(val)->
			# inittype=1 ? 管理员 : 客服
			@inittype = 1  if Number(val) is 1
			@inittype = 2 if Number(val) is 2
		# 取消按钮返回上一层
		cancleBtn:->
			@$router.push path:'/synergy'
		# 初始化数据
		permissionF:->
			Utils.ajax ALPHA.API_PATH.synergy.onlypermission
			.then (res) =>
				# 默认选中客服 => 2
				for item,index in res.data
					# 管理员权限
					if item.name is '管理员'
						newarr = []
						@administratortype = 0
						@formaData(newarr,res.data[index].menus)
					# 客服权限
					else if item.name is '客服'
						newarr_second = []
						@administratortype = 1
						@formaData(newarr_second,res.data[index].menus)
		# 格式化数据
		formaData:(newarr,permissionList)->
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
					if @administratortype is 0 
						# 管理员 => initArray_first
						@initArray_first.push(item.name+"-"+item.id)
						@initArray_first_post.push(item.id)
					else if @administratortype is 1
						# 客服 => initArray_second
						@initArray_second.push(item.name+"-"+item.id)
						@initArray_second_post.push(item.id)
					permissionList.remove item
					continue
				i++
			newarr = newarr.children if id
			@formaData item, permissionList for item in newarr if newarr
			if @administratortype is 0 
				@servicedata = newarr
			else if @administratortype is 1
				@Customerservice = newarr
		# 重新组合数组
		restArr:(data,postarr,type,event)->
			if type is 'add'
				for item,index in data
					if item.indexOf(event) >= 0
						selectval = data[index].split('-')[1]
						if Number(selectval) in postarr
							return !1
						else
							postarr.push(Number(selectval))
			else if type is 'less'
				for item,index in data
					if item.indexOf(event) >= 0
						onselectv = data[index].split('-')[1]
						postarr.remove(Number(onselectv))
		ckeckval:(val)->
			# inittype=1 ? 管理员 : 客服
			if /^\d+$/.test(val)
				if @inittype is 1
					@restArr(@initArray_first,@initArray_first_post,'add',val)
				else if @inittype is 2
					@restArr(@initArray_second,@initArray_second_post,'add',val)
			else
				if @inittype is 1
					@restArr(@initArray_first,@initArray_first_post,'less',val)
				else if @inittype is 2
					@restArr(@initArray_second,@initArray_second_post,'less',val)
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
			unless @groupId 
				@alertTip("请选择分组")
				return !1
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
			arrlist= []
			for i in Object.keys(@checkedData)
				if @checkedData[i] is true
					arrlist.push(i)
			menuIdslist = arrlist.join(',')
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
			if @inittype is 2 
				menuIdslist = @initArray_second_post.join(',')
			else if @inittype is 1
				menuIdslist = @initArray_first_post.join(',')
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
				
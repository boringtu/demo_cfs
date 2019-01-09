'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		account:''
		name:''
		nickname:''
		roleId:'2'
		groupId:''
		password:''
		grouplist:''
		permissionList:''
		servicedata:''
		confirmpassword:''
		administratortype:''
		Customerservice:''
		inittype:2,
		initArray_first:[]
		initArray_second:[]
		initArray_first_post:[]
		initArray_second_post:[]
		checkpas:false
	mounted:->
		this.permissionF()
		Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				this.grouplist = res.data.groups
	methods:
		# 检测客服id是否存在
		blurcheck:->
			Utils.ajax ALPHA.API_PATH.synergy.check,
				params: account:this.account
			.then (res) =>
				if res.data
					@alertTip("客服ID已存在")
					return !1
				else
					this.postForm()
		# select切换
		changselect:(val)->
			# inittype=1 ? 管理员 : 客服
			if Number(val) is 1
				this.inittype = 1 
			if Number(val) is 2
				this.inittype = 2
				
		# 取消按钮返回上一层
		cancleBtn:->
			this.$router.push({path:'/synergy'})
		permissionF:->
			Utils.ajax ALPHA.API_PATH.synergy.onlypermission
			.then (res) =>
				# 默认选中客服 => 2
				for item,index in res.data
					# 管理员权限
					if item.name is '管理员'
						permissionList = res.data[index].menus
						newarr = []
						this.administratortype = 0
						this.formaData(newarr,permissionList)
					# 客服权限
					else if item.name is '客服'
						newarr_second = []
						this.administratortype = 1
						this.formaData(newarr_second,res.data[index].menus)
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
					newarr[key] ?= []
					newarr[key].push item
					if this.administratortype is 0 
						# 管理员 => initArray_first
						this.initArray_first.push(item.name+"-"+item.id)
						this.initArray_first_post.push(item.id)
					else if this.administratortype is 1
						# 客服 => initArray_second
						this.initArray_second.push(item.name+"-"+item.id)
						this.initArray_second_post.push(item.id)
					permissionList.remove item
					continue
				i++
			newarr = newarr.children if id
			@formaData item, permissionList for item in newarr if newarr
			if this.administratortype is 0 
				this.servicedata = newarr
			else if this.administratortype is 1
				this.Customerservice = newarr
		# 重新组合数组
		restArr:(data,postarr,type,event)->
			if type is 'add'
				for item,index in data
					if item.indexOf(event) >= 0
						selectval = data[index].split('-')[1]
						postarr.push(Number(selectval))
			else if type is 'less'
				for item,index in data
					if item.indexOf(event) >= 0
						onselectv = data[index].split('-')[1]
						postarr.remove(Number(onselectv))
		# 复选框选中事件
		ckeckval:(event)->
			# inittype=1 ? 管理员 : 客服
			if /^\d+$/.test(event)
				if this.inittype is 1
					this.restArr(this.initArray_first,this.initArray_first_post,'add',event)
				else if this.inittype is 2
					this.restArr(this.initArray_second,this.initArray_second_post,'add',event)
			else
				if this.inittype is 1
					this.restArr(this.initArray_first,this.initArray_first_post,'less',event)
				else if this.inittype is 2
					this.restArr(this.initArray_second,this.initArray_second_post,'less',event)
		# 提示框
		alertTip:(msg)->
			vm.$notify
				type: 'error'
				title: '提示'
				message: msg
		# 保存按钮提交数据
		saveF:->
			unless this.account
				@alertTip("客服ID不能为空")
				return !1
			unless this.name 
				@alertTip("姓名不能为空")
				return !1
			unless this.nickname 
				@alertTip("昵称不能为空")
				return !1
			unless this.groupId 
				@alertTip("请选择分组")
				return !1
			unless this.password 
				@alertTip("密码格式错误")
				return !1
			if !/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$/.test(this.password)
				@alertTip("长度为8-20个字符，且至少包含数字和字母")
				return !1
			if this.password isnt this.confirmpassword
				@alertTip("确认密码不一样")
				return !1
			this.blurcheck()
		postForm:->
			if this.inittype is 2
				menuIdslist = this.initArray_first_post.join(',')
			else if this.inittype is 1
				menuIdslist =  this.initArray_second_post.join(',')
			Utils.ajax ALPHA.API_PATH.synergy.addadmin,
				method: 'post'
				data:
					menuIds:menuIdslist
					account:this.account
					name:this.name
					nickname:this.nickname
					roleId:this.roleId
					groupId:this.groupId
					password:this.password
			.then (res) =>
				@alertTip("添加成功")
				this.$router.push({path:'/synergy'})
				
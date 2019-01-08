'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		dialogue_radio:''
		synergy_radio:''
		Configuration_radio:''
		account:''
		name:''
		nickname:''
		roleId:'2'
		groupId:''
		password:''
		grouplist:''
		account:''
		newarrList:''
		permissionList:''
		selectchek:[]
		ndatalist:[]
		noInput:true
		confirmpassword:''
	mounted:->
		this.permissionF()
		Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				this.grouplist = res.data.groups
	methods:
		# 取消按钮返回上一层
		cancleBtn:->
			this.$router.push({path:'/synergy'})
		permissionF:->
			Utils.ajax ALPHA.API_PATH.synergy.permission
			.then (res) =>
				permissionList = res.data
				newarr = []
				this.formaData(newarr,permissionList)
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
					permissionList.remove item
					continue
				i++
			newarr = newarr.children if id
			@formaData item, permissionList for item in newarr if newarr
			this.newarrList = newarr
		# 复选框选中事件
		ckeckval:(id)->
			if !id is no
				this.selectchek.push(id)
				this.ndatalist.push(id)
			else
				console.log "deleted"
				arrlastIndex = this.ndatalist[this.ndatalist.length-1]
				this.selectchek.pop()
			console.log this.selectchek.join(",")
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
			unless this.password 
				@alertTip("密码格式错误")
				return !1
			if !/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$/.test(this.password)
				@alertTip("长度为8-20个字符，且至少包含数字和字母")
				return !1
			if this.password isnt this.confirmpassword
				@alertTip("确认密码不一样")
				return !1
			Utils.ajax ALPHA.API_PATH.synergy.addadmin,
				method: 'post'
				data:
					menuIds:this.selectchek.join(",")
					account:this.account
					name:this.name
					nickname:this.nickname
					roleId:this.roleId
					groupId:this.groupId
					password:this.password
			.then (res) =>
				console.log res
				
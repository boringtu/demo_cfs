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
		gobaleReg: /^[\u4e00-\u9fa5_a-zA-Z0-9`~!@#$%^&*()_\-+=?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]{1,20}$/
	created:->
		this.loadAll()
	watch:
		$route:(to)->
			this.loadAll() if to.name is 'synergy'
	methods:
		# 点击隐藏错误提示
		hiddentip:()->
			this.errorTipbox=false
			this.$refs.inputBox.focus()
			this.inputmsg = '请输入分组名称'
		# 删除客服
		deletedServe:(id)->
			this.hasInput = false
			this.dsialogFormVisible = true
			this.titleinfo = "确定删除该客服？"
			this.operatingId = id
		# 禁用or启用客服
		disabeldServe:(event,index,id)->
			this.hasInput = false
			htmldom =  event.target.innerHTML
			this.operatingId = id
			if htmldom is '禁用'
				this.titleinfo = "确定禁用该客服？"
				this.status_init = 1
				this.dsialogFormVisible = true
			else if htmldom is '启用'
				this.status_init = 2
				this.titleinfo = "确定启用该客服？"
				this.dsialogFormVisible = true
			
		# 初始化数据
		loadAll:->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				this.resdata = res.data
				this.groupsList = this.resdata.groups
				this.adminsList = res.data.admins
				this.peopleCount = this.adminsList.length
				this.groundList(this.adminsList,this.resdata.groups)
		# 跳转到添加客服
		aHerf:(id)->
			this.$router.push({path:'/synergy/addService',query:{account:id}}) if id 
			this.$router.push({path:'/synergy/addService'}) unless id 
		groundList:(adminsList,groupsList)->
			for grounpItems,grounpI in groupsList
				groupsList[grounpI].newVal = []
				for adminsItem,adminsI in adminsList
					if grounpItems.id is 0
						groupsList[0].newVal.push(adminsItem)
					else
						if adminsItem.groupId is grounpItems.id
							groupsList[grounpI].newVal.push(adminsItem)
			this.loadRightData(this.initIndex)
			this.loadedData = true
		# 添加分组
		addGrouping: ->
			this.initModel = ''
			this.alertType = 1
			this.alertTitle = "添加分组"
			this.dsialogFormVisible = true
		# 关闭窗口
		canleAlert:->
			this.isxhr = false
			this.isclick = false
			this.hasInput = true
			this.errorTipbox = false
			this.inputmsg = '请输入分组名称'
			this.dsialogFormVisible = false
		# 删除分组
		deleteGround:(id)->
			this.hasInput = false
			this.dsialogFormVisible = true
			this.titleinfo = "确定删除该分组？"
			this.operatingId = id
		# 确定操作
		determine:(msg)->
			return no if this.isclick is on
			this.isclick = true
			if msg.indexOf('删除该分组') >= 1
				Utils.ajax ALPHA.API_PATH.synergy.deleted,
					method: 'delete'
					params: id:this.operatingId
				.then (res) =>
					this.isclick = false
					this.loadAll()
					vm.$notify
						type: 'success'
						title: '提示'
						message: '删除成功'
			else if msg.indexOf('删除该客服') >= 1
				Utils.ajax ALPHA.API_PATH.synergy.deletedServe,
					method: 'delete'
					params: id:this.operatingId
				.then (res) =>
					this.isclick = false
					this.loadAll()
					vm.$notify
						type: 'success'
						title: '提示'
						message: '删除成功'
			else if msg.indexOf("启用") >= 1 or msg.indexOf("禁用") >= 1
				Utils.ajax ALPHA.API_PATH.synergy.disabledServe,
					method: 'put'
					data:
						id:this.operatingId
						status:this.status_init
				.then (res) =>
					this.isclick = false
					this.loadAll()
					vm.$notify
						type: 'success'
						title: '提示'
						message: '操作成功'
			this.canleAlert()
		# 弹窗数据保存
		saveGround:->
			unless this.initModel
				this.errorTipbox=true
				this.inputmsg = ''
				return no
			this.isxhr = true
			# 添加分组
			if this.alertType is 1
				Utils.ajax ALPHA.API_PATH.synergy.group,
					method: 'POST'
					data: name:this.initModel
				.then (res) =>
					this.canleAlert()
					this.loadAll()
					this.isxhr = false
					vm.$notify
						type: 'success'
						title: '提示'
						message: '添加成功'
			# 编辑分组
			else if this.alertType is 2
				Utils.ajax ALPHA.API_PATH.synergy.edit,
					method: 'PUT'
					data:
						name:this.initModel
						id:  this.initId
				.then (res) =>
					this.canleAlert()
					this.loadAll()
					this.isxhr = false
					vm.$notify
						type: 'success'
						title: '提示'
						message: '编辑成功'
		# css样式切换
		bMouseEnterFun:(index)->
			this.indexThis = index
		# css样式切换
		bMouseLeaveFun:->
			this.indexThis = -1
		# 右侧分组内容切换
		loadRightData:(index)->
			this.servenumber = 0
			this.kefnumber = 0
			this.disablednumber = 0
			this.initIndex = index
			for item in  this.groupsList[index].newVal 
				# item.roleId == 1 ？ 管理员 ：客服
				if item.roleId is 1
					this.servenumber += 1
				if item.roleId is 2
					this.kefnumber += 1
				# 被禁用的人数
				if item.status is 1
					this.disablednumber += 1
		# 修改分组名称
		editGround:(itemsName,id)->
			this.initModel = itemsName
			this.initId = id
			this.alertType = 2
			this.alertTitle = "修改分组名称"
			this.dsialogFormVisible = true

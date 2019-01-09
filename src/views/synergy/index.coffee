'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		dsialogFormVisible:false
		indexThis:-1
		alertTitle:''
		initModel:''
		alertType:''
		resdata:[]
		adminsList:''
		peopleCount:'--'
		groupsList:[]
		loadedData:false
		disbaledFont:'禁用'
		initIndex:0
		servenumber:0
		kefnumber:0
		disablednumber:0
	created:->
		this.loadAll()
	methods:
		# 删除客服
		deletedServe:(id)->
			Utils.ajax ALPHA.API_PATH.synergy.deletedServe,
				method: 'delete'
				params: id:id
			.then (res) =>
				this.loadAll()
		# 禁用or启用客服
		disabeldServe:(event,index,id)->
			status_init = ''
			htmldom =  event.target.innerHTML
			if htmldom is '禁用'
				event.target.innerHTML = '启用'
				status_init = 1
			else if htmldom is '启用'
				status_init = 2
				event.target.innerHTML = '禁用'
			Utils.ajax ALPHA.API_PATH.synergy.disabledServe,
				method: 'put'
				data:
					id:id
					status:status_init
			.then (res) =>
				this.loadAll()
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
		aHerf:->
			this.$router.push({path:'/synergy/addService'})
		groundList:(adminsList,groupsList)->
			for grounpItems,grounpI in groupsList
				groupsList[grounpI].newVal = []
				for adminsItem,adminsI in adminsList
					if grounpItems.id is 0
						groupsList[0].newVal.push(adminsItem)
					else
						if adminsItem.groupId is grounpItems.id
							groupsList[grounpI].newVal.push(adminsItem)
			this.loadRightData(0)
			this.loadedData = true
		# 添加分组
		addGrouping: ->
			this.initModel = ''
			this.alertType = 1
			this.alertTitle = "添加分组"
			this.dsialogFormVisible = true
		# 关闭窗口
		canleAlert:->
			this.dsialogFormVisible = false
		# 删除分组
		deleteGround:(id)->
			Utils.ajax ALPHA.API_PATH.synergy.deleted,
					method: 'delete'
					params: id:id
				.then (res) =>
					this.loadAll()
		# 弹窗数据保存
		saveGround:->
			if this.alertType is 1 
				Utils.ajax ALPHA.API_PATH.synergy.group,
					method: 'POST'
					data: name:this.initModel
				.then (res) =>
					this.canleAlert()
					this.loadAll()
			else if this.alertType is 2
				Utils.ajax ALPHA.API_PATH.synergy.edit,
					method: 'PUT'
					data:
						name:this.initModel
						id:  this.initId
				.then (res) =>
					this.canleAlert()
					this.loadAll()
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
				console.log item.roleId
				# item.roleId == 1 ？ 管理员 ：客服
				if item.roleId is 1
					this.servenumber += 1
				if item.roleId is 2
					this.kefnumber += 1
				# 被禁用的人数
				if item.status is 1
					this.disablednumber += 1
			console.log("点击加载数据")
		# 修改分组名称
		editGround:(itemsName,id)->
			this.initModel = itemsName
			this.initId = id
			this.alertType = 2
			this.alertTitle = "修改分组名称"
			this.dsialogFormVisible = true

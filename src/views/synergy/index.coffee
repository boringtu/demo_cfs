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
		itemlist:''
		peopleCount:'--'
		forindex: 0
		groupsList:[]
		loadedData:false
		arrylist:[]
		itmesarr:[]
	created:->
		this.loadAll()
	mounted: ->
		
	methods:
		deletedServe:(id)->
			Utils.ajax ALPHA.API_PATH.synergy.deletedServe,
				method: 'delete'
				data: id:id
			.then (res) =>
				this.loadAll()

		disabeldServe:(id)->
			Utils.ajax ALPHA.API_PATH.synergy.disabledServe,
				method: 'put'
				data: id:id
			.then (res) =>
				this.loadAll()

		loadAll:->
			Utils.ajax ALPHA.API_PATH.synergy.all
			.then (res) =>
				this.resdata = res.data
				this.groupsList = this.resdata.groups
				this.adminsList = res.data.admins
				this.peopleCount = this.adminsList.length
				this.groundList(this.adminsList,this.resdata.groups)
		aHerf:->
			this.$router.push({path:'/synergy/addService'})
		groundList:(adminsList,groupsList)->
			for grounpItems,grounpI in groupsList
				groupsList[grounpI].newVal = []
				for adminsItem,adminsI in adminsList
					if adminsItem.groupId is grounpItems.id
						groupsList[grounpI].newVal.push(adminsItem)
			this.loadedData = true

		addGrouping: ->
			this.initModel = ''
			this.alertType = 1
			this.alertTitle = "添加分组"
			this.dsialogFormVisible = true
		canleAlert:->
			this.dsialogFormVisible = false
		deleteGround:(id)->
			Utils.ajax ALPHA.API_PATH.synergy.deleted,
					method: 'delete'
					params: id:id
				.then (res) =>
					this.loadAll()
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
				
		
		bMouseEnterFun:(index)->
			this.indexThis = index
		
		bMouseLeaveFun:->
			this.indexThis = -1

		loadRightData:->
			console.log("点击加载数据")
		
		editGround:(itemsName,id)->
			this.initModel = itemsName
			this.initId = id
			this.alertType = 2
			this.alertTitle = "修改分组名称"
			this.dsialogFormVisible = true

'use strict'
import Utils from '@/assets/scripts/utils'

export default
	data: ->
		levelOptions: [
			value: 0
			label: '待定'
		,
			value: 1
			label: '无价值'
		,
			value: 2
			label: '有价值'
		,
			value: 3
			label: '很有价值'
		]
		genderOptions: [
			value: '', label: '未知'
		,
			value: '男', label: '男'
		,
			value: '女', label: '女'
		]
		# 默认对话信息对象
		defInfo:
			# 姓名
			name: ''
			# 性别
			gender: ''
			# 手机
			phone: ''
			# conversation
			# 地区（地址）
			address: ''
			# 对话主题
			topicId: ''
			# 对话级别
			level: 0
			# 备注
			remark: ''
			# 来源
			origin: ''
			# 操作系统
			os: ''
			# 浏览器
			browser: ''
			# IP地址
			ip: ''
		# 对话信息 默认数据
		info: null
		# 数据待保存
		dataChanged: 0

	computed:
		# 是否无数据
		nodata: -> not @info.id
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo
		# 对话主题列表
		topicOptions: -> @$store.state.topics

	created: ->
		ALPHA.topics
		@info = Utils.clone @defInfo
	
	watch:
		dialogInfo: (info) ->
			@dataChanged = 0
			unless info
				@info = Utils.clone @defInfo
				return
			@info =
				# ID
				id: info.id
				# 姓名
				name: info.name
				# 性别
				gender: info.gender
				# 手机
				phone: info.phone
				# conversation
				# 地区（地址）
				address: info.conversation.address
				# 对话主题
				topicId: info.conversation.topicId
				# 对话级别
				level: info.conversation.level
				# 备注
				remark: info.conversation.remark
				# 来源
				origin: info.conversation.origin
				# 操作系统
				os: info.conversation.os
				# 浏览器
				browser: info.conversation.browser
				# IP地址
				ip: info.conversation.ip

	methods:
		saveInfo: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.dialogue.infoModifiable
			Utils.ajax ALPHA.API_PATH.dialogue.user,
				method: 'PUT'
				data: @info
			.then (res) =>
				@dataChanged = 0
				info = @info
				# 更新列表中的数据
				# 姓名
				@$store.state.dialogInfo.name = info.name
				# 性别
				@$store.state.dialogInfo.gender = info.gender
				# 手机
				@$store.state.dialogInfo.phone = info.phone
				# conversation
				# 地区（地址）
				@$store.state.dialogInfo.conversation.address = info.address
				# 对话主题
				@$store.state.dialogInfo.conversation.topicId = info.topicId
				# 对话级别
				@$store.state.dialogInfo.conversation.level = info.level
				# 备注
				@$store.state.dialogInfo.conversation.remark = info.remark
				# 来源
				@$store.state.dialogInfo.conversation.origin = info.origin
				# 操作系统
				@$store.state.dialogInfo.conversation.os = info.os
				# 浏览器
				@$store.state.dialogInfo.conversation.browser = info.browser
				# IP地址
				@$store.state.dialogInfo.conversation.ip = info.ip

				# 弹出提示
				vm.$notify
					type: 'success'
					title: '保存成功'
					message: '客户信息保存成功'

		eventInputChanged: ->
			@dataChanged = 1
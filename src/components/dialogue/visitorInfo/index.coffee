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
			value: '男', label: '男'
		,
			value: '女', label: '女'
		]
		info:
			# 姓名
			name: ''
			# 性别
			gender: ''
			# 手机
			phone: ''
			conversation:
				# 地区（地址）
				address: ''
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
	computed:
		nodata: -> not @info.id
		dialogInfo: -> @$store.state.dialogInfo
	
	watch:
		dialogInfo: (info) -> @info = info

	methods:
		saveInfo: ->
			console.log @info
			return
			@axios ALPHA.API_PATH.xxx

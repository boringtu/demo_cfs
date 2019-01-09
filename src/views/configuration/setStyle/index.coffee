'use strict'
import Utils from '@/assets/scripts/utils'
import axios from 'axios'
export default
	data: ->
		logoImgUrl: ''
		isShowLogoImg: false
		isShowAdImg: false
		adImgUrl: ''
		logoImgId: ''
		adImgId: ''
		logoUrlText: ''
		adUrlText: ''
	computed:
		admin: -> ALPHA.admin or {}
	mounted: ->
		@getDefaultSet()
	methods: 
		# logo图片点击上传
		getLogoImg: ->
			img1 = event.target.files[0]
			formData = new FormData()
			formData.append('multipartFile', img1)
			# 发起请求
			axios.post('/api/common/upload',formData,headers:{'Content-Type':'multipart/form-data'})
			.then (response) =>
				console.log(response.data)
				if response.msg == 'success'
					@isShowLogoImg = true
					@logoImgUrl = "http://172.16.10.122/" + response.data.fileUrl 
					@logoImgId = response.data.id
		# 广告图片点击上传
		getAdImg: ->
			adImg = event.target.files[0]
			formData = new FormData()
			formData.append('multipartFile', adImg)
			axios.post('/api/common/upload',formData,headers:{'Content-Type':'multipart/form-data'})
			.then (res) =>
				console.log res.data
				if res.msg == 'success'
					console.log "aa"
					@isShowAdImg = true
					@adImgUrl = "http://172.16.10.122/" + res.data.fileUrl 
					@adImgId = res.data.id
		# 获取默认配置
		getDefaultSet: ->
			console.log @admin
			data =
				adminId: @admin.adminId
				type: 'pc_dialog'
			Utils.ajax ALPHA.API_PATH.configManagement.getDefaultSet,
				params: data
			.then (res) =>
				console.log res.data.sys_conf
				resData = res.data.sys_conf
				# @adImgUrl = resData
				if resData
					@logoUrlText = item.defaul for item in resData when item.key == 'logo_href'
					@adUrlText = item.defaul for item in resData when item.key == 'right_ad_href'
					logoUrl = item.other for item in resData when item.key == 'logo_media_id'
					adUrl = item.other for item in resData when item.key == 'right_ad_media_id'
					if logoUrl
						@isShowLogoImg = true
					else
						@isShowLogoImg = false
					if adUrl
						@isShowAdImg = true
					else
						@isShowAdImg = false
					@logoImgUrl = "http://172.16.10.122/" + item.other for item in resData when item.key == 'logo_media_id'
					@adImgUrl = "http://172.16.10.122/" + item.other for item in resData when item.key == 'right_ad_media_id'
		# 保存设置对话框主题
		saveSetTheme: ->
			params =
				logoHref: @logoUrlText
				logoMediaId: @logoImgId
				rightAdHref: @adUrlText
				rightAdMediaId: @adImgId
			Utils.ajax ALPHA.API_PATH.configManagement.saveSetTheme,
				method: 'put'
				data: params
			.then (res) =>
				if res.msg == 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
		# 恢复默认设置
		recoverDefaultSet: ->
			params =
				type: 'pc_dialog'
			Utils.ajax ALPHA.API_PATH.configManagement.recoverDefaultSet,
				method: 'put'
				data: params
			.then (res) =>
				if res.msg == 'success'
					vm.$notify
						type: 'success'
						title: '已恢复默认设置'

			

			

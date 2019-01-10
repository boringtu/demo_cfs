'use strict'
import Utils from '@/assets/scripts/utils'
import axios from 'axios'
export default
	data: ->
		logoImgUrl: ''
		adImgUrl: ''
		logoImgId: ''
		defaultLogoImgId: ''
		adImgId: ''
		defaultAdImgId: ''
		logoUrlText: ''
		defaultLogoUrlText: ''
		adUrlText: ''
		defaultAdUrlText: ''
		isloading: false
		isDisabled: true
	watch: -> 
		logoUrlText () =>
			console.log logoUrlText
	computed:
		admin: -> ALPHA.admin or {}
	created: ->
		@getDefaultSet()
	mounted: ->
		
	methods: 
		logoUrlChange: ->
			if @logoUrlText != @defaultLogoUrlText
				@isDisabled = false
			else
				@isDisabled = true
		adUrlChange: ->
			if @adUrlText != @defaultAdUrlText
				@isDisabled = false
			else
				@isDisabled = true
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
					@logoImgUrl = "http://172.16.10.122/" + response.data.fileUrl 
					@logoImgId = response.data.id
					if @logoImgId != @defaultLogoImgId
						@isDisabled = false
					else
						@isDisabled = true
		# 广告图片点击上传
		getAdImg: ->
			adImg = event.target.files[0]
			formData = new FormData()
			formData.append('multipartFile', adImg)
			axios.post('/api/common/upload',formData,headers:{'Content-Type':'multipart/form-data'})
			.then (res) =>
				console.log res.data
				if res.msg == 'success'
					@adImgUrl = "http://172.16.10.122/" + res.data.fileUrl 
					@adImgId = res.data.id
					if @adImgId != @defaultAdImgId
						@isDisabled = false
					else
						@isDisabled = true
		# 获取默认配置
		getDefaultSet: ->
			console.log @admin
			data =
				adminId: @admin.adminId
				type: 'pc_dialog'
			Utils.ajax ALPHA.API_PATH.configManagement.getDefaultSet,
				params: data
			.then (res) =>
				resData = res.data.sys_conf
				if resData
					@logoUrlText = item.value for item in resData when item.key == 'logo_href'
					@defaultLogoUrlText = @logoUrlText
					@adUrlText = item.value for item in resData when item.key == 'right_ad_href'
					@defaultAdUrlText = @adUrlText
					logoUrl = item.other for item in resData when item.key == 'logo_media_id'
					adUrl = item.other for item in resData when item.key == 'right_ad_media_id'
					@logoImgId = item.value for item in resData when item.key == 'logo_media_id'
					@defaultLogoImgId = @logoImgId
					@adImgId = item.value for item in resData when item.key == 'right_ad_media_id'
					@defaultAdImgId = @adImgId
					if logoUrl
						@logoImgUrl = "http://172.16.10.122/" + logoUrl
					if adUrl
						@adImgUrl = "http://172.16.10.122/" + adUrl
			
		# 保存设置对话框主题
		saveSetTheme: ->
			console.log @logoImgId
			console.log @dafaultLogoImgId 
			isloading = true
			params =
				logoHref: @logoUrlText
				logoMediaId: @logoImgId
				rightAdHref: @adUrlText
				rightAdMediaId: @adImgId
			Utils.ajax ALPHA.API_PATH.configManagement.saveSetTheme,
				method: 'put'
				data: params
			.then (res) =>
				isloading = false
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
					@getDefaultSet()

			

			

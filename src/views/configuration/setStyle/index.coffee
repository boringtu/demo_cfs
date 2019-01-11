'use strict'
import Utils from '@/assets/scripts/utils'
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
	computed:
		admin: -> ALPHA.admin or {}
	created: ->
		@getDefaultSet()
	methods: 
		logoUrlChange: ->
			@isDisabled = @logoUrlText is @defaultLogoUrlText
		adUrlChange: ->
			@isDisabled = @adUrlText is @defaultAdUrlText
		# logo图片点击上传
		getLogoImg: ->
			img1 = event.target.files[0]

			# 限制图片大小 小于 10Mb
			if img1.size / 1024 / 1024 > 10
				# 弹出提示
				vm.$notify
					type: 'warning'
					title: '图片上传失败'
					message: "图片大小不可超过10Mb"
				return

			formData = new FormData()
			formData.append 'multipartFile', img1
			# 发起请求
			@axios.post ALPHA.API_PATH.common.upload, formData, headers: 'Content-Type': 'multipart/form-data'
			.then (res) =>
				console.log(res.data)
				if res.msg is 'success'
					@logoImgUrl = "/#{ res.data.fileUrl }"
					@logoImgId = res.data.id
					@isDisabled = @logoImgId is @defaultLogoImgId
		# 广告图片点击上传
		getAdImg: ->
			adImg = event.target.files[0]

			# 限制图片大小 小于 10Mb
			if adImg.size / 1024 / 1024 > 10
				# 弹出提示
				vm.$notify
					type: 'warning'
					title: '图片上传失败'
					message: "图片大小不可超过10Mb"
				return

			formData = new FormData()
			formData.append 'multipartFile', adImg
			@axios.post ALPHA.API_PATH.common.upload, formData, headers: 'Content-Type': 'multipart/form-data'
			.then (res) =>
				console.log res.data
				if res.msg is 'success'
					@adImgUrl = "/#{ res.data.fileUrl }"
					@adImgId = res.data.id
					@isDisabled = @adImgId is @defaultAdImgId
		# 获取默认配置
		getDefaultSet: ->
			console.log @admin
			data =
				adminId: @admin.adminId
				type: 'pc_dialog'
			Utils.ajax ALPHA.API_PATH.configManagement.getDefaultSet, params: data
			.then (res) =>
				resData = res.data.sys_conf
				if resData
					for item in resData
						switch item.key
							when 'logo_href'
								@defaultLogoUrlText = @logoUrlText = item.value
							when 'right_ad_href'
								@defaultAdUrlText = @adUrlText = item.value
							when 'logo_media_id'
								logoUrl = item.other
								@defaultLogoImgId = @logoImgId = item.value
							when 'right_ad_media_id'
								adUrl = item.other
								@defaultAdImgId = @adImgId = item.value

					if logoUrl
						@logoImgUrl = "/#{ logoUrl }"
					if adUrl
						@adImgUrl = "/#{ adUrl }"
			
		# 保存设置对话框主题
		saveSetTheme: ->
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
				if res.msg is 'success'
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
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '已恢复默认设置'
					@getDefaultSet()

			

			

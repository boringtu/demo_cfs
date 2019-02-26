'use strict'
import Utils from '@/assets/scripts/utils'
export default
	data: ->
		sysLogoImgUrl: ''
		sysLogoImgId: ''
		defaultSysLogoImgId: ''
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
		isloadingForPC: false
		isloadingForSysLogo: false
		isDisabledForPC: true
		isDisabledForSysLogo: true
		menuList: [
			id: 0, text: '桌面对话窗口'
		,
			id: 1, text: '客服系统样式'
		]
		activeMenu: 0

	computed:
		admin: -> ALPHA.admin or {}

	created: ->
		@fetchImgSetting()
		@fetchSysLogoSetting()

	methods: 
		logoUrlChange: ->
			@isDisabledForPC = @logoUrlText is @defaultLogoUrlText
		adUrlChange: ->
			@isDisabledForPC = @adUrlText is @defaultAdUrlText
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
				if res.msg is 'success'
					@logoImgUrl = "/#{ res.data.fileUrl }"
					@logoImgId = res.data.id
					@isDisabledForPC = @logoImgId is @defaultLogoImgId
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
				if res.msg is 'success'
					@adImgUrl = "/#{ res.data.fileUrl }"
					@adImgId = res.data.id
					@isDisabledForPC = @adImgId is @defaultAdImgId

		# 客服系统logo图片点击上传
		getSysLogoImg: ->
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
				if res.msg is 'success'
					@sysLogoImgUrl = "/#{ res.data.fileUrl }"
					@sysLogoImgId = res.data.id
					@isDisabledForSysLogo = @sysLogoImgId is @defaultSysLogoImgId

		# 获取桌面对话窗口数据
		fetchImgSetting: ->
			data =
				adminId: ALPHA.admin.adminId
				type: 'pc_dialog'
			Utils.ajax ALPHA.API_PATH.configManagement.sysLogoSetting, params: data
			.then (res) =>
				resData = res.data.sys_conf
				if resData
					for item in resData
						switch item.key
							when 'logo_href'
								@defaultLogoUrlText = @logoUrlText = decodeURI item.value
							when 'right_ad_href'
								@defaultAdUrlText = @adUrlText = decodeURI item.value
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

		# 获取客服系统样式数据
		fetchSysLogoSetting: ->
			data =
				type: 'manageLogo'
			Utils.ajax ALPHA.API_PATH.configManagement.sysLogoSetting, params: data
			.then (res) =>
				resData = res.data
				return unless resData
				@sysLogoImgUrl = "/#{ resData.other }"
				@defaultSysLogoImgId = @sysLogoImgId = +resData.value
			
		# 保存设置对话框主题
		saveSetTheme: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.styleModifiable
			@isloadingForPC = true
			params =
				logoHref: encodeURI @logoUrlText
				logoMediaId: @logoImgId
				rightAdHref: encodeURI @adUrlText
				rightAdMediaId: @adImgId
			Utils.ajax ALPHA.API_PATH.configManagement.sysLogoSetting,
				method: 'put'
				data: params
			.then (res) =>
				@isloadingForPC = false
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
					@isDisabledForPC = true

		# 恢复默认设置
		recoverDefaultSet: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.styleModifiable
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
					@fetchImgSetting()

		# 恢复默认系统 LOGO
		recoverDefaultSysLogo: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.styleModifiable
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
					@fetchSysLogoSetting()
		
		# 保存系统 LOGO 设置
		saveSysLogo: ->
			# 鉴权
			return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.styleModifiable
			@isloadingForSysLogo = true
			params =
				mediaId: @sysLogoImgId
			Utils.ajax ALPHA.API_PATH.configManagement.sysLogoSetting,
				method: 'put'
				data: params
			.then (res) =>
				@isloadingForSysLogo = false
				if res.msg is 'success'
					vm.$notify
						type: 'success'
						title: '保存成功'
					@isDisabledForSysLogo = true	

			

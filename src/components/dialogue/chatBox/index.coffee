'use strict'
import Utils from '@/assets/scripts/utils'
import scrollBox from '@/components/scroll/scroll'

export default
	data: ->
		# 输入的文本
		inputText: ''
		# 是否准备输入（输入框是否获取焦点）
		isReadyToType: 0
		# 历史消息区目前消息条数
		msgCount: 0
		# 新消息条数
		newMsgCount: 0
		# 历史消息记录列表（新数据在后）
		list: []
		hasChosenFace: 1

	components: {
		scrollBox
	}

	computed:
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo

	filters:
		# 历史消息区 消息 class 类名（区分己方/对方）
		sideClass: (side) ->
			switch side
				when 2
					'msg-self'
				when 1
					'msg-opposite'

	watch:
		dialogInfo: (info) ->
			# TODO

	created: ->
		# 获取列表数据
		@fetchHistory()

	mounted: ->
		window.x = @
		window.u = Utils

	methods:
		# 获取数据
		fetchHistory: ->
			return

		# Event: 消息发送事件
		eventSend: ->
			console.log event.keyCode




			return
			input = @$refs.input
			btn = @$refs.btnSend
			val = input.value

			console.log '发送内容: ', val

			# 清空输入框
			input.value = ''

			# 推到历史消息区
			@$emit 'addMsg',
				sendType: 2
				messageType: 1
				message: val

			# 发起请求
			url = Utils.getApiName '/api/cs/message'
			promise = Utils.ajax url,
				method: 'post'
				data:
					message: val
					token: @token
			promise.then (data) =>
				console.log 'footer: ', data
				# @$emit 'sendSuccessful', data

		# Event: 显示/隐藏 表情选择面板
		# TODO 疑似废弃
		eventToggleFacePanel: (event) ->

		# Event: 选择并发送图片
		eventChoosePicture: (event) ->
			# 弹出提示
			vm.$notify
				type: 'info'
				title: '开发中'
				message: '正在开发中，敬请期待'

		# 向输入框插入表情，并关闭表情选择面板
		insertEmoji: (emoji) ->
			# 向输入框追加表情
			@inputText += emoji
			# 关闭表情选择面板
			@$refs.emojiPicker.hide()
			# 使输入框获取焦点
			@$nextTick =>
				@$refs.input.focus()

		# 初始化/重置 历史消息列表的位置（到最底部）
		resetHistoryPosition: ->
			wrap = @$refs.historyWrap
			box = wrap.children[0]
			# window height
			wh = wrap.offsetHeight
			# content height
			ch = box.offsetHeight
			return if wh > ch
			wrap.scrollTop = ch - wh

		# Event: 历史消息列表滚动事件
		eventScrollHistory: ->
			console.log @$refs.historyWrap
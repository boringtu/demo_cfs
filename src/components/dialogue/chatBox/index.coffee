'use strict'
import Utils from '@/assets/scripts/utils'
import scrollBox from '@/components/scroll/scroll'

export default
	data: ->
		# 是否准备输入（输入框是否获取焦点）
		isReadyToType: 0
		# 历史消息区目前消息条数
		msgCount: 0
		# 新消息条数
		newMsgCount: 0
		# 历史消息记录列表（新数据在后）
		list: []

	components: {
		scrollBox
	}

	computed:
		# 对话信息
		dialogInfo: -> @$store.state.dialogInfo

	watch:
		dialogInfo: (info) ->
			# TODO

	created: ->
		# 获取列表数据
		@fetchHistory()

	mounted: ->

	methods:
		# 获取数据
		fetchHistory: ->
			return

		# Event: input 消息输入框
		# TODO 未完成
		eventInputSendBox: (event) ->
			input = @$refs.input
			btn = @$refs.btnSend
			val = input.value
			# 禁用/启用 发送按钮
			if val.replace /^\s*|\s*$/g, ''
				btn.removeAttribute 'disabled'
			else
				btn.setAttribute 'disabled', 'disabled'
			return
			e = event.target
			t = @$refs.inputCopy
			a = 48
			t.value = e.value
			console.log 't.scrollHeight: ', t.scrollHeight
			console.log 'inputNormalHeight: ', @inputNormalHeight
			console.log 'maxHeight: ', @maxHeight
			if t.scrollHeight > @inputNormalHeight and t.scrollHeight < @maxHeight
				e.scrollTop = 0
				a = t.scrollHeight
			else if t.scrollHeight >= @maxHeight
				a = @maxHeight
				e.scrollTop = t.scrollHeight
			else
				a = @inputNormalHeight
				e.style.height = a + 'px'
			# setTimeout ->
				# globalChatHandle.scrollHistoryToBottom(!0)
			# , 250

		# Event: 消息发送点击事件
		eventSend: (event) ->
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
		eventToggleFacePanel: (event) ->

		# Event: 选择并发送图片
		eventChoosePicture: (event) ->
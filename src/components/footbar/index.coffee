'use strict'
# import chatHistory from '@/components/chatHistory/chatHistory'
# import chatFooter from '@/components/chatFooter/chatFooter'

export default

	components: {
		# chatFooter
		# chatHistory
	}

	created: ->

	mounted: ->

	methods:
		# 向历史消息区推消息（单条）
		addMsg: (data) -> @$refs.chatHistory.addMsg data
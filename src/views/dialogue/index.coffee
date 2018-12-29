'use strict'
import ComponentVisitorList from '@/components/dialogue/visitorList'
import ComponentDialogList from '@/components/dialogue/dialogList'
import ComponentChatBox from '@/components/dialogue/chatBox'
import ComponentVisitorInfo from '@/components/dialogue/visitorInfo'

export default
	components:
		'CPNT-visitorList': ComponentVisitorList
		'CPNT-dialogList': ComponentDialogList
		'CPNT-chatBox': ComponentChatBox
		'CPNT-visitorInfo': ComponentVisitorInfo

	beforeRouteUpdate: (to, from, next) ->
		# 刷新会话 ID（如果有
		@$store.state.dialogID = +to.params.id
		next()
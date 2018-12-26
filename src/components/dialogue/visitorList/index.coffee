'use strict'
import Utils from '@/assets/scripts/utils'

export default
	created: ->
		@fetchData()

	mounted: ->

	methods:
		fetchData: ->
			Utils.ajax ALPHA.API_PATH.dialogue.visitor,
				params:
					adminId: ALPHA.adminId
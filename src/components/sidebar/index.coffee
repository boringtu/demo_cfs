'use strict'

export default
	computed:
		permissions: -> ALPHA.permissions
	
	filters:
		getUrl: (id) -> ALPHA.menuUrlMap[id].url or ''
		getIcon: (id) -> ALPHA.menuUrlMap[id].icon
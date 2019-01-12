'use strict'

export default
	computed:
		permissions: -> ALPHA.permissions
		hasMenu: -> (menu) -> menu.children?.length or menu.permissions?.length
	
	filters:
		getUrl: (id) -> ALPHA.menuUrlMap[id].url or ''
		getIcon: (id) -> ALPHA.menuUrlMap[id].icon
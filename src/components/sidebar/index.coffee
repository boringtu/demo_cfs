'use strict'

export default
	created: ->
		window.xx = @
	computed:
		permissions: -> ALPHA.permissions
		hasMenu: -> (menu) -> menu.id is 1 or menu.children?.length or menu.permissions?.length
		logoUrl: -> @$store.state.logoUrl
	
	filters:
		getUrl: (id) -> ALPHA.menuUrlMap[id].url or ''
		getIcon: (id) -> ALPHA.menuUrlMap[id].icon
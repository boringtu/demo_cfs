'use strict'

export default
	created: ->
		window.xx = @
	computed:
		permissions: -> ALPHA.permissions
		hasMenu: -> (menu) -> menu.id is 1 or menu.children?.length or menu.permissions?.length
		logoUrl: -> @$store.state.logoUrl
	
	filters:
		getUrl: (id) ->
			try
				ALPHA.menuUrlMap[id].url or ''
			catch
				console.error "Cannot find id of #{ id } in ALPHA.menuUrlMap, please define it." unless ALPHA.menuUrlMap[id]

		getIcon: (id) ->
			try
				ALPHA.menuUrlMap[id].icon
			catch
				console.error "Cannot find id of #{ id } in ALPHA.menuUrlMap, please define it." unless ALPHA.menuUrlMap[id]
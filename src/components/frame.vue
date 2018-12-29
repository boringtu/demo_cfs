<template lang="pug">
div
	sidebar
	.container
		headbar
		keep-alive
			router-view.main
		footbar
</template>

<script lang="coffee">
import ComponentHeadbar from '@/components/headbar'
import ComponentSidebar from '@/components/sidebar'
import ComponentFootbar from '@/components/footbar'
export default
	components:
		headbar: ComponentHeadbar
		sidebar: ComponentSidebar
		footbar: ComponentFootbar
</script>

<style lang="sass">
.container
	padding-left: 240px
	padding-bottom: 40px
	min-height: 800px
.main
	padding: 30px
</style>
<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.sidebar
	.logo
		i.icon.icon-logo
	ul.level_1
		router-link(tag="li" exact-active-class="active" to="/dialogue")
			a
				i.item-icon.icon.icon-dialogue
				span 访客对话
		router-link(tag="li" exact-active-class="active" to="/synergy")
			a
				i.item-icon.icon.icon-synergy
				span 内部协同
		router-link(tag="li" exact-active-class="active" to="/configuration")
			a
				i.item-icon.icon.icon-configuration
				span 配置管理
			ul.level_2
				router-link(tag="li" exact-active-class="active" to="/configuration/setStyle")
					a
						span 设置样式
				router-link(tag="li" exact-active-class="active" to="/configuration/setStyle")
					a
						span 设置样式
				router-link(tag="li" exact-active-class="active" to="/configuration/setStyle")
					a
						span 设置样式

</template>
<script lang="coffee" src="./index.coffee"></script>
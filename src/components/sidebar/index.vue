<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.sidebar
	.logo
		i.icon.icon-logo
	ul.level_1
		router-link(
			tag="li"
			active-class="active"
			v-for="m1 in permissions"
			v-if="hasMenu(m1)"
			:key="m1.id"
			:to="m1.id | getUrl"
		)
			a
				i.item-icon.icon(:class="m1.id | getIcon")
				span {{ m1.name }}
				span.expand-icon.icon.icon-plus(v-if="m1.children")
				span.expand-icon.icon.icon-minus(v-if="m1.children")
			ul.level_2(v-if="m1.children")
				router-link(
					tag="li"
					exact-active-class="active"
					v-for="m2 in m1.children"
					v-if="hasMenu(m2)"
					:key="m2.id"
					:to="m2.id | getUrl"
				)
					a
						span {{ m2.name }}

</template>
<script lang="coffee" src="./index.coffee"></script>
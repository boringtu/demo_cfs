<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.row
		CPNT-visitorList(ref="cpnt_visitorList")
	.row
		CPNT-dialogList(ref="cpnt_dialogList")
		CPNT-chatBox(ref="cpnt_chatBox")
		CPNT-visitorInfo(ref="cpnt_visitorInfo")
</template>
<script lang="coffee" src="./index.coffee"></script>
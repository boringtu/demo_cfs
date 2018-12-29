<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.footbar
	div
		label 当前访问量：
		span {{ chattingCount }}
	div
		label 今日访问量：
		span 不知道
	div
		label 客服ID：
		span {{ adminId }}
	div
		label 角色：
		span 谁知道呢
</template>
<script lang="coffee" src="./index.coffee"></script>
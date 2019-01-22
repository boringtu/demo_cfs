<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.footbar
	div
		label 当前访问量：
		span {{ chattingCount || '--' }}
	div
		label 今日访问量：
		span {{ todayCount || '--' }}
	div
		label 客服ID：
		span {{ admin.account }}
	div
		label 角色：
		span {{ admin.roleName }}
</template>
<script lang="coffee" src="./index.coffee"></script>
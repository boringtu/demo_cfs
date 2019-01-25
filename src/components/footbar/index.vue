<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.footbar
	div
		label 当前访客量：
		span {{ visitingCount }}
	div
		label 今日接待量：
		span {{ todayCount }}
	div
		label 客服ID：
		span {{ admin.account }}
	div
		label 角色：
		span {{ admin.roleName }}
</template>
<script lang="coffee" src="./index.coffee"></script>
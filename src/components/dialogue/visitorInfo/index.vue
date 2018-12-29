<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.tab-box
		h2 客户信息
	.content-box
		form
			el-row
				el-col(:span="12")
					label 姓名
					el-input
				el-col(:span="12")
					label 地区
					el-input
			el-row
				el-col(:span="12")
					label 性别
					el-input
				el-col(:span="12")
					label 手机
					el-input
			el-row
				el-col(:span="12")
					label 对话主题
					el-input
				el-col(:span="12")
					label 对话级别
					el-input
			el-row
				el-col(:span="24")
					label 备注
					el-input(type="textarea")
</template>
<script lang="coffee" src="./index.coffee"></script>
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
					el-input(type="textarea" placeholder="请输入备注")
			el-row
				el-col(:span="24" class="btn-col")
					el-button(type="primary") 保存
		.more-box
			h3 更多信息
			ul
				li
					label 来源
					a(href="https://profile.live800.com/profile/simchat.jsp") https://profile.live800.com/profile/simchat.jsp
				li
					label 操作系统
					p https://profile.live800.com/profile/simchat.jsp
				li
					label 浏览器
					p https://profile.live800.com/profile/simchat.jsp
				li
					label IP地址
					p https://profile.live800.com/profile/simchat.jsp
</template>
<script lang="coffee" src="./index.coffee"></script>
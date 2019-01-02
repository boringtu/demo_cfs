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
					el-input(:disabled="nodata" v-model="info.name")
				el-col(:span="12")
					label 地区
					el-input(:disabled="nodata" v-model="info.conversation.address")
			el-row
				el-col(:span="12")
					label 性别
					el-select(:disabled="nodata" v-model="info.gender")
						el-option(v-for="item in genderOptions" :key="item.value" :value="item.value" :label="item.label")
				el-col(:span="12")
					label 手机
					el-input(:disabled="nodata" v-model="info.phone")
			el-row
				el-col(:span="12")
					label 对话主题
					el-input(:disabled="nodata" v-model="xxx")
				el-col(:span="12")
					label 对话级别
					el-select(:disabled="nodata" v-model="info.conversation.level")
						el-option(v-for="item in levelOptions" :key="item.value" :value="item.value" :label="item.label")
			el-row
				el-col(:span="24")
					label 备注
					el-input(:disabled="nodata" type="textarea" placeholder="请输入备注" v-model="info.conversation.remark")
			el-row
				el-col(:span="24" class="btn-col")
					el-button(type="primary" @click="saveInfo") 保存
		.more-box
			h3 更多信息
			ul
				li
					label 来源
					a(:href="info.conversation.origin") {{ info.conversation.origin }}
				li
					label 操作系统
					p {{ info.conversation.os }}
				li
					label 浏览器
					p {{ info.conversation.browser }}
				li
					label IP地址
					p {{ info.conversation.ip }}
</template>
<script lang="coffee" src="./index.coffee"></script>
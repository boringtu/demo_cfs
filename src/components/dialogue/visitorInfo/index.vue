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
					el-input(:disabled="nodata" @input="eventInputChanged" v-model="info.name")
				el-col(:span="12")
					label 地区
					el-input(:disabled="nodata" @input="eventInputChanged" v-model="info.address")
			el-row
				el-col(:span="12")
					label 性别
					el-select(:disabled="nodata" @input="eventInputChanged" v-model="info.gender")
						el-option(v-for="item in genderOptions" :key="item.value" :value="item.value" :label="item.label")
				el-col(:span="12")
					label 手机
					el-input(:disabled="nodata" @input="eventInputChanged" v-model="info.phone")
			el-row
				el-col(:span="12")
					label 对话主题
					el-select(:disabled="nodata" @input="eventInputChanged" v-model="info.topicId")
						el-option(v-for="item in topicOptions" :key="item.id" :value="item.id" :label="item.name")
				el-col(:span="12")
					label 对话级别
					el-select(:disabled="nodata" @input="eventInputChanged" v-model="info.level")
						el-option(v-for="item in levelOptions" :key="item.value" :value="item.value" :label="item.label")
			el-row
				el-col(:span="24")
					label 备注
					el-input(:disabled="nodata" @input="eventInputChanged" type="textarea" placeholder="请输入备注" v-model="info.remark")
			el-row
				el-col(:span="24" class="btn-col")
					el-button(type="primary" @click="saveInfo" :disabled="!dataChanged") 保存
		.more-box
			h3 更多信息
			ul
				li
					label 来源
					p {{ info.origin }}
				li
					label 操作系统
					p {{ info.os }}
				li
					label 浏览器
					p {{ info.browser }}
				li
					label IP地址
					p {{ info.ip }}
</template>
<script lang="coffee" src="./index.coffee"></script>
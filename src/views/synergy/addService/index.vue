<style lang="sass" src="./index.sass" scoped></style>

<template lang="pug">
.childRoot
	h1.title 客服管理
	.cont_wrap
		.com_box.left_cont_box
			.com_top_tlt 账户信息
			form(ref="fromline" class="form_wrap")
				.form_item
					label
						i *
						span 客服ID
					input(type="text" class="input_item" v-model="serverId" :disabled="IdIsDisabled" maxlength="20" @blur="checkIdIsRepeat" @input="inputChange")
				.form_item
					label
						i *
						span 姓名
					input(type="text" class="input_item" v-model="serverName" maxlength="20" @input="inputChange")
				.form_item
					label
						i *
						span 昵称
					input(type="text" class="input_item" v-model="serverNickName" maxlength="20" @input="inputChange")
				.form_item
					label   
						i
						span 角色
					el-select(v-model="roleId" size="small" @change="roleChange" @input="inputChange")
						el-option(label="客服" :value=2 :key=2)
						el-option(label="管理员" :value=1 :key=2)
				.form_item
					label
						i
						span 所属分组
					el-select(v-model="groupId" size="small" @input="inputChange")
						el-option(v-for="item in allGroupList" :key="item.id" :value="item.id" :label="item.name")
				.form_item.pwd_item
					label
						i *
						span 初始密码
					input(type="password" class="input_item" v-model="password" minlength="8" maxlength="20" @input="inputChange")
					.pwd_info
						p 修改密码后需重新登录，请谨慎操作。
						p 长度为8-20个字符，至少包含数字和字母的组合。
				.form_item
					label
						i *
						span 确认密码
					input(type="password" class="input_item" v-model="confirmPassword" minlength="8" maxlength="20" @input="inputChange")
				.submit_line
					div(class="cancel_btn" @click="cancelSaveAccountInfo") 取消
					el-button(type="primary" class="save_btn" @click="saveAccountInfo" :disabled="saveIsDisabled") 保存
		.com_box.right_cont_box
			.com_top_tlt 权限设置
			.permission_cont
				.dialog_manage(v-for="item,index1 in allPermissionTreeList")
					.title {{item.name}}
					.subCont(v-for="subItem,index2 in item.children")
						.subTitle {{subItem.name}}
						.check_group
							div(class="checkbox_item" v-for="perItem,index3 in subItem.permissions")
								span(class="checked_box" :class="{'isChecked': perItem.checkStatus}" @click="boxIsChecked(perItem,index3,index2,index1)")
								span(class="checked_text") {{perItem.name}}
					.check_group
						div(class="checkbox_item" v-if="index1 === 0")
							span(class="checked_box fixed_checkbox")
							span(class="checked_text") 查看客户信息
						div(class="checkbox_item" v-for="perItem,index3 in item.permissions")
							span(class="checked_box" :class="{'isChecked': perItem.checkStatus}" @click="boxIsChecked(perItem,index3,index1)")
							span(class="checked_text") {{perItem.name}}
						


</template>
<script lang="coffee" src="./index.coffee"></script>
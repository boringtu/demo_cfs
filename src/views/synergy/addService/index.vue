<style lang="sass" src="./index.sass" scoped></style>

<template lang="pug">
	.center
		el-row
			el-col.tl.f18.marb18 客服管理
		.center_box
			.left_box 
				.title_details.f18 账户信息
				form(ref="fromline")
					.lable_box
						label
							i *
							span 客服ID
						el-input(v-model="account",:disabled="isedit",maxlength="20")
					.lable_box
						label
							i *
							span 姓名
						el-input(v-model="name",maxlength="20")

					.lable_box
						label
							i *
							span 昵称
						el-input(placeholder="显示给访客",v-model="nickname",maxlength="20")
					
					.lable_box
						label
							i *
							span 角色
						el-select(v-model="roleId",@change="changselect")
							el-option(label="客服",value=2)
							el-option(label="管理员",value=1)

					.lable_box
						label
							i *
							span 所属分组
						el-select(v-model="groupId")
							el-option(v-for="items,index in grouplist",:label="items.name",v-if="index>=1",:value="items.id")

					.lable_box
						label
							i *
							span 密码
						el-input(type="password",v-model="password",maxlength="20",minlength="8")
						.citeBox
							P 修改密码后需重新登录，请谨慎操作。
							p 长度为8-20个字符，至少包含数字和字母的组合。

					.lable_box
						label
							i *
							span 确认密码
						el-input(type="password",v-model="confirmpassword",maxlength="20",minlength="8")
					
					.cite-button
						el-button.cancleBtn(@click="cancleBtn") 取消
						el-button.saveBtn(@click="saveF") 保存
			.right_box
				.title_details.tl.f18.marb18 权限设置
				//- 编辑客服 initMenIds => 原始权限
				template(v-if="hasparams  && initMenIds && overData")
					template(v-if="inittype == 2")
						.citeBox(v-for="items,index in Customerservice")
							.title {{items.name}}
							template(v-for="permissionsitem,i in items.permissions")
								label.rel.label_check(v-if="permissionsitem.id" )
									i.icon(:class="checkedData[permissionsitem.id] ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(type="checkbox"  @click="checkboxFs(permissionsitem.id)"  v-model="checkedData[permissionsitem.id]" )
										span.checkboxInfo {{permissionsitem.name}}
					template(v-if="inittype == 1")
						.citeBox(v-for="items,index in servicedata")
							.title {{items.name}}
							template(v-for="permissionsitem,i in items.permissions")
								label.rel.label_check(v-if="permissionsitem.id" )
									i.icon(:class="checkedData[permissionsitem.id] ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(type="checkbox"  @click="checkboxFs(permissionsitem.id)" v-model="checkedData[permissionsitem.id]" )
										span.checkboxInfo {{permissionsitem.name}}
				//- 新添加客服
				template(v-if="!hasparams")
					.citeBox(v-show="inittype == 1 ")
						.div(v-for="items,index in servicedata")
							.title {{items.name}}
							el-checkbox(
								@change="ckeckval"
								v-for="permissionsitem in items.permissions"
								:key="'1_'+permissionsitem.id"
								:false-label ="permissionsitem.name"
								:true-label="permissionsitem.id"
								:checked="true")  {{permissionsitem.name}}
					.citeBox(v-show="inittype == 2")
						.div(v-for="items,index in Customerservice")
							.title {{items.name}}
							el-checkbox(
								@change="ckeckval"
								v-for="permissionsitem in items.permissions"
								:key="'1_'+permissionsitem.id"
								:false-label ="permissionsitem.name"
								:true-label="permissionsitem.id"
								:checked="true")  {{permissionsitem.name}}
</template>
<script lang="coffee" src="./index.coffee"></script>
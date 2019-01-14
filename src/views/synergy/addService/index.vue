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
				//- 编辑客服 [ @initMenIds => 原始权限 ]
				template(v-if="hasparams")
					//- 客服
					template(v-if="inittype == 2")
						.citeBox(v-for="items,index in allCheckBox")
							.title {{items.name}} 
							template(v-for="permissionsitem,i in items.permissions" )
								//- 查看客户信息 默认选中状态
								label.rel.label_check.noallowed(v-if="index == 0") 
									i.icon.icon-checkbox-1
										span.checkboxInfo 查看客户信息 
								//- 对话管理
								label.rel.label_check(v-if="permissionsitem.id && index == 0" )
									i.icon(:class="initMenIds.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(
											type = "checkbox"
											:value = "permissionsitem.id"
											v-model = "initMenIds"
											)
										span.checkboxInfo {{permissionsitem.name}}
								//- 内部协同
								label.rel.label_check(v-if="permissionsitem.id && index == 1" )
									.cursorBox(:class="permissionsitem.id !== 14 && initMenIds.indexOf(14) <= 0 ? 'noallowed' : 'pointer'")
										i.icon(:class="initMenIds.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
											input.inputCheck(
												type = "checkbox"
												:value = "permissionsitem.id"
												v-model = "initMenIds"
												:disabled="initMenIds.indexOf(14) <= 0 && permissionsitem.id != 14" 
												@click="checkboxFs($event,permissionsitem.id,2)"
												)
											pan.checkboxInfo {{permissionsitem.name}} 
							//- 配置管理 (包含子集)
							template(v-for="perChildren,i in items.children")
								label.rel.label_check(v-if="index == 2")
									.childrenName {{perChildren.name}} 
									template(v-for="item in perChildren.permissions")
										label.label_chidren(:class="item.id != 44  && initMenIds.indexOf(44) <= 0 ? 'noallowed':'pointer'")
											i.icon(:class="initMenIds.indexOf(item.id) >= 0 ?'icon-checkbox-1':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model = "initMenIds"
												:value = "item.id"
												:disabled = "item.id != 44  && initMenIds.indexOf(44) <= 0"
												@click = "checkboxFs($event,item.id,2)"
												)
											span.checkboxInfo {{item.name}} 
					//- 管理员
					template(v-if="inittype == 1")
						.citeBox(v-for="items,index in allCheckBox")
							.title {{items.name}} 
							template(v-for="permissionsitem,i in items.permissions")
								//- 查看客户信息 默认必须选 （无法点击）
								label.rel.label_check.noallowed(v-if="index == 0 " ) 
									i.icon.icon-checkbox-1
										span.checkboxInfo 查看客户信息
								//- 对话管理
								label.rel.label_check(v-if="permissionsitem.id && index == 0" )
									i.icon(:class="initMenIds.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(
											type = "checkbox"
											:value = "permissionsitem.id"
											v-model = "initMenIds"
											)
										span.checkboxInfo {{permissionsitem.name}}
								//- 内部协同
								label.rel.label_check(v-if="permissionsitem.id && index == 1" )
									.cursorBox(:class="permissionsitem.id !== 14 && initMenIds.indexOf(14) <= 0 ? 'noallowed' : 'pointer'")
										i.icon(:class="initMenIds.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
											input.inputCheck(
												type = "checkbox"
												:value = "permissionsitem.id"
												v-model = "initMenIds"
												:disabled="initMenIds.indexOf(14) <= 0 && permissionsitem.id != 14" 
												@click="checkboxFs($event,permissionsitem.id,1)"
												)
											span.checkboxInfo {{permissionsitem.name}} 
							//- 配置管理 (包含子集)
							template(v-for="perChildren,i in items.children")
								label.rel.label_check(v-if="index == 2")
									.childrenName {{perChildren.name}} 
									template(v-for="item in perChildren.permissions")
										label.label_chidren(:class="item.id != 44  && initMenIds.indexOf(44) <= 0 ? 'noallowed':'pointer'")
											i.icon(:class="initMenIds.indexOf(item.id) >= 0 ?'icon-checkbox-1':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model ="initMenIds"
												:value ="item.id"
												:disabled = "item.id != 44  && initMenIds.indexOf(44) <= 0"
												@click = "checkboxFs($event,item.id,1)"
												)
											span.checkboxInfo {{item.name}} 
				//- 新添加客服 
				template(v-if="!hasparams")
					//- 角色 => 客服
					template(v-if="inittype == 2 && overdata")
						.citeBox(v-for="items,index in allCheckBox")
							.title(@click="") {{items.name}}
							template(v-for="permissionsitem,i in items.permissions")
								//- 查看客户信息 默认选中状态
								label.rel.label_check.noallowed(v-if="index == 0 " ) 
									i.icon.icon-checkbox-1
										span.checkboxInfo 查看客户信息
								//- 对话管理
								label.rel.label_check(v-if="permissionsitem.id && index == 0" )
									i.icon(:class="checkArrlist.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(
											type = "checkbox"
											v-model = "checkArrlist"
											:value = "permissionsitem.id"
											)
										span.checkboxInfo {{permissionsitem.name}} 
								//- 内部协同
								label.rel.label_check(v-if="permissionsitem.id && index == 1" )
									.cursorBox(:class="permissionsitem.id !== 14 && checkArrlist.indexOf(14) <= 0 ? 'noallowed' : 'pointer'")
										i.icon(:class="checkArrlist.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model = "checkArrlist"
												:value = "permissionsitem.id"
												:disabled = "checkArrlist.indexOf(14) <= 0 && permissionsitem.id != 14" 
												@click = "checkboxFs($event,permissionsitem.id,2)")
											span.checkboxInfo {{permissionsitem.name}}
							//- 配置管理 (包含子集)
							template(v-for="perChildren,i in items.children")
								label.rel.label_check(v-if="index == 2")
									.childrenName {{perChildren.name}} 
									template(v-for="item in perChildren.permissions")
										label.label_chidren(:class="item.id != 44  && checkArrlist.indexOf(44) <= 0 ? 'noallowed':'pointer'")
											i.icon(:class="checkArrlist.indexOf(item.id) >= 0 ?'icon-checkbox-1':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model = "checkArrlist"
												:value = "item.id"
												:disabled = "item.id != 44  && checkArrlist.indexOf(44) <= 0"
												@click = "checkboxFs($event,item.id,2)"
												)
											span.checkboxInfo {{item.name}} 
					//- 角色 => 管理员
					template(v-if="inittype == 1 && overdata_admin")
						.citeBox(v-for="items,index in allCheckBox")
							.title {{items.name}} 
							template(v-for="permissionsitem,i in items.permissions")
								//- 查看客户信息 默认选中
								label.rel.label_check.noallowed(v-if="index == 0 ") 
									i.icon.icon-checkbox-1
										span.checkboxInfo 查看客户信息
								//- 对话管理
								label.rel.label_check(v-if="permissionsitem.id && index == 0" )
									i.icon(:class="checkArrlist_admin.indexOf(checkedAdmin[index].permissions[i].id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
										input.inputCheck(
											type = "checkbox"
											v-model = "checkArrlist_admin"
											:value = "permissionsitem.id"
											)
										span.checkboxInfo {{permissionsitem.name}} 
								//- 内部协同
								label.rel.label_check(v-if="permissionsitem.id && index == 1" )
									.cursorBox(:class="permissionsitem.id !== 14 && checkArrlist_admin.indexOf(14) <= 0 ? 'noallowed' : 'pointer'")
										i.icon(:class="checkArrlist_admin.indexOf(permissionsitem.id) >= 0  ? 'icon-checkbox-1 ':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model = "checkArrlist_admin"
												:value = "permissionsitem.id"
												:disabled = "checkArrlist_admin.indexOf(14) <= 0 && permissionsitem.id != 14 " 
												@click = "checkboxFs($event,permissionsitem.id,1)")
											span.checkboxInfo {{permissionsitem.name}}
							//- 配置管理 (包含子集)
							template(v-for="perChildren,i in items.children")
								label.rel.label_check(v-if="index == 2")
									.childrenName {{perChildren.name}} 
									template(v-for="item in perChildren.permissions")
										label.label_chidren(:class="item.id != 44  && checkArrlist_admin.indexOf(44) <= 0 ? 'noallowed':'pointer'")
											i.icon(:class="checkArrlist_admin.indexOf(item.id) >= 0 ?'icon-checkbox-1':'icon-checkbox-0'")
											input.inputCheck.addorlessInput(
												type = "checkbox" 
												v-model = "checkArrlist_admin"
												:value = "item.id"
												:disabled = "item.id != 44  && checkArrlist_admin.indexOf(44) <= 0"
												@click = "checkboxFs($event,item.id,1)"
												)
											span.checkboxInfo {{item.name}}
</template>
<script lang="coffee" src="./index.coffee"></script>
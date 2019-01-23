<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	h1.title 客服管理
	.cont_wrap
		.left_cont_box
			.title_line.add_group_line
				div(class="add_group_btn" @click="addNewGroup") + 添加分组
			ul.group_list
				//- li(class="list_item") 全部（1）
				li(class="list_item" v-for="item, index in allGroupList" @click="clickGroupItem(item)" :class="{active: activeGroupId == item.id}")
					.left_txt_name {{item.name}}（{{item.num}}）
					div(class="right_btns" v-if="index > 0")
						el-button(type="primary" plain class="btn edit_btn" @click="editGroup(item)") 编辑
						el-button(type="danger" plain class="btn delete_btn" @click="deleteGroup(item)") 删除
		.right_cont_box
			.title_line.list_cont_tlt
				.left
					span.item 总人数：{{serveListDetail.length}}																																																																																																					
					span.item 管理员：{{managerNum}}																																																																																																																																														
					span.item 客服：{{serverNum}}
					span.item 被禁用人数：{{disabledNum}}
				.right
					div(class="add_serve_btn" @click="addNewServer") + 添加客服
			.table_cont
				table(class="serve_list_cont" width="100%" border="0" cellspacing="0" cellpadding="0")
					thead
						tr(class="line_tlt")
							th 客服ID
							th 姓名
							th 昵称
							th 角色
							th(colspan="2") 操作
					tbody.cont_detail_wrap
						tr(class="cont_detail" v-for ="item, index in serveListDetail" v-if="activeGroupId === 0 || activeGroupId === item.groupId" :key="index")
							td {{item.account}} 
							td {{item.name}} 
							td {{item.nickname}} 
							td {{item.roleId === 1 ?'管理员':'客服'}}
							td(colspan="2")
								el-button(type="primary" plain class="btn edit_btn" @click="editServer(item)") 编辑
								el-button(type="warning" plain class="btn not_allowed_btn" @click="userServer(item)") {{item.status === 2 ? '启用' : '禁用'}}
								el-button(type="danger" plain class="btn delete_btn" @click="deleteServer(item)") 删除
		
	//- //- 添加及修改分组弹框
	div(class="popup" v-if="isShowAddNewPop")
		.pop_cont
			h2.title {{popTitle}}
			.center_cont 
				input(type="text" v-model="addGroupName" maxlength="20" @focus="saveBlock = false" class="add_group_input" :class="{'save_block': saveBlock}")
				p(class="block_warn_msg" v-if="saveBlock") 分组名称不能为空
				i(class="el-icon-warning warn_icon" v-if="saveBlock")
			.btn_line
				el-botton(class="popBtn cancel_btn" @click="cancelAddNew") 取消
				el-botton(class="popBtn save_btn" @click="saveAddNew") 保存
	div(class="confirmPop" v-if="isShowConfirmPop")
		.pop_cont
			h2.title {{confirmTitle}}
			.btn_line
				div(class="popBtn cancel_btn" @click="cancelConfirmPop") 取消
				div(class="popBtn save_btn" @click="sureConfirmPop") 确定
	router-view

</template>
<script lang="coffee" src="./index.coffee"></script>
    

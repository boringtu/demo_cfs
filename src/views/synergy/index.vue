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
                    li(class="list_item" v-for="item,index in allGroupList") 
                        .left_txt_name  {{item.name}}
                        div(class="right_btns" v-if="index > 0")
                            el-button(type="primary" plain class="btn edit_btn" @click="editGroup(item)") 编辑
                            el-button(type="danger" plain class="btn delete_btn" @click="deleteGroup(item)") 删除
            .right_cont_box
                .title_line.list_cont_tlt
                    .left
                        span.item 总人数：{{sumPersonNum}}																																																																																																					
                        span.item 管理员：1																																																																																																																																														
                        span.item 客服：1
                        span.item 被禁用人数：0
                    .right
                        div(class="add_serve_btn" @click="addNewServer") + 添加客服
                .serve_list_cont
                    ul.line_tlt
                        li 客服ID
                        li 姓名
                        li 昵称
                        li 角色
                        li 操作
                    ul(class="cont_detail" v-for ="item,index in serveListDetail")
                        li {{item.account}}
                        li {{item.name}}
                        li {{item.nickname}}
                        li {{item.roleId === 1 ?'管理员':'客服'}}
                        li 
                            el-button(type="primary" plain class="btn edit_btn" @click="editServer(item)") 编辑
                            el-button(type="warning" plain class="btn not_allowed_btn" @click="userServer(item)") {{item.status === 1 ? '启用' : '禁用'}}
                            el-button(type="danger" plain class="btn delete_btn" @click="deleteServer(item)") 删除
        //- 添加及修改分组弹框
        div(class="popup" v-if="isShowAddNewPop")
            .pop_cont
                h2.title {{popTitle}}
                .center_cont                 
                    input(v-model="addGroupName" @focus="saveBlock = false" class="add_group_input" :class="{'save_block': saveBlock}")
                    p(class="block_warn_msg" v-if="saveBlock") 分组名称不能为空
                    i(class="el-icon-warning warn_icon" v-if="saveBlock")
                .btn_line
                    div(class="popBtn cancel_btn" @click="cancelAddNew") 取消
                    div(class="popBtn save_btn" @click="saveAddNew") 保存
        div(class="confirmPop" v-if="isShowConfirmPop")
            .pop_cont
                h2.title {{confirmTitle}}
                .btn_line
                    div(class="popBtn cancel_btn" @click="cancelConfirmPop") 取消
                    div(class="popBtn save_btn" @click="sureConfirmPop") 确定
                           																																																																																																																																																																																																																							

</template>
<script lang="coffee" src="./index.coffee"></script>
    

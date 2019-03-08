<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
    .mainCont
        h2.title 访客信息收集
        .contBtn 访客信息收集
            el-switch(class="switchBtn" v-model="switchOpen" active-color="#2297F1" inactive-color="#EEEEEE" @change="saveBtnUnable")
            // div(class="ele-switch switchBtn" :class="{'is_open': switchOpen, 'is_close': !switchOpen}" @click="switchDistribute")
        .contBox
            .boxLeft
                .leftTop
                    .title 引导语
                    textarea(placeholder="请输入引导语" v-model="visitorMsg" :onchange="getNumber()" maxlength="200" @input="saveBtnUnable")
                    span(class="number" v-model="msgNumber") {{msgNumber}}
                .leftBottom
                    .title 选择需要收集的访客信息
                    .table_cont
                        table(class="serve_list_cont" width="450px" border="0" cellspacing="0" cellpadding="0")
                            thead
                                tr(class="line_tlt")
                                    th 显示名称
                                    th 必填
                                    th 类型
                                    th 操作
                            tbody.cont_detail_wrap
                                tr(class="cont_detail" v-for="item, index in tableData")
                                    td {{item.name}}
                                    td
                                        span(class="checked_box" :class="{'isChecked': item.require}" @click="boxIsChecked(index)")
                                    td {{item.type}}
                                    td
                                        i(class="icon icon-item" :class="{'icon-enabled': item.ban === 0, 'icon-forbidden': item.ban === 1}" @click="forbiddenOrEnabeld(index)")
                                        // el-button(type="text" class="btn edit_btn" @click="forbiddenOrEnabeld(index)")
                                        span(@click="forbiddenOrEnabeld(index)") {{item.ban === 0 ? "启用": "禁用"}}

            .boxRight
                .preview
                    .title 预览
                    .previewMain
                        .introducerLine
                        .introducer(v-if="visitorMsg.length>0")
                            p(v-model="visitorMsg") {{ visitorMsg }}
                        .preview_cont
                            .divInput( v-for="item, index in showData")
                                label {{item.name}}
                                    span {{item.require === 0 ? "": "*"}}
                                .info
                            .footer
                                el-button(type="primary" class="footerBtn") 立即咨询
    .default_btn_line
        div(class="recover_default_btn" @click="isShowPop = true") 恢复默认设置
        el-button(type="primary" class="save_btn" @click="saveVisitorInfo" :disabled="atuoIsDisabled") 保存
    div(class="popup" v-if="isShowPop === true")
        .pop_cont
            .tlt 恢复默认设置
            .cont 确认恢复默认设置？
            .btns
                el-button(class="popBtn cancel_btn" @click="isShowPop = false") 取消
                el-button(class="popBtn save_btn" @click="recoverDefault") 确定
</template>
<script lang="coffee" src="./index.coffee"></script>

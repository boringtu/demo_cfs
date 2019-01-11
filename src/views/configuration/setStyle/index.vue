<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
    .cont_wrap
        h1 桌面对话窗口
        .cont_box
            .left_set_logo
                h2.top_tlt 设置logo图片
                .common_line
                    .left_text logo图片
                    .right_cont 
                        .upload_img_box
                            form(enctype="multipart/form-data" id="file")
                                input(type="file" accept="image/gif, image/jpeg, image/png" @change="getLogoImg")
                            div(class="balckBg") 点击上传
                            img(:src="logoImgUrl")
                        p 企业标志图片尺寸为180*50，图片格式为jpg，png    
                .common_line.set_line2
                    .left_text 图片跳转链接
                    .right_cont
                        .url_input
                            span https://
                            input(type="text" v-model="logoUrlText" @input="logoUrlChange")
                h2.set_adline 设置右侧广告栏
                .common_line.ad_img_line
                    .left_text 广告图
                    .right_cont 
                        .upload_img_box
                            form(enctype="multipart/form-data")
                                input(type="file" accept="image/gif, image/jpeg, image/png" @change="getAdImg")
                            div(class="balckBg") 点击上传
                            img(:src="adImgUrl")
                        p 企业标志图片尺寸为270px，图片格式为jpg，png
                .common_line.set_line2
                    .left_text 图片跳转链接
                    .right_cont
                        .url_input
                            span https://
                            input(type="text" v-model="adUrlText" @input="adUrlChange")
                .set_bths
                    div(class="recover_default_btn" @click="recoverDefaultSet") 恢复默认设置
                    <el-button type="primary" class="save_btn" @click="saveSetTheme" :loading="isloading" :disabled="isDisabled">保存</el-button>
            .right_view_box
                h2.top_tlt 预览
                .view_cont_wrap
                    .view_tlt
                        img(:src="logoImgUrl")
                        <i class="el-icon-close"></i>
                    .view_cont
                        .view_dialog_win
                        img(:src="adImgUrl" class="ad_img")
                    
                

</template>
<script lang="coffee" src="./index.coffee"></script>
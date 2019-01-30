<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.cont_wrap
		.left_menus
			ul
				li(
					v-for="item in menuList"
					:key="item.id"
					:class="{active: item.id === activeMenu}"
					@click="activeMenu = item.id"
				).
					{{ item.text }}
		.right_cont
			.cont_box(v-if="activeMenu === 0" :data-type="0")
				.left_set_logo
					h2.top_tlt 设置 LOGO 图片
					.common_line
						.left_text LOGO图片
						.right_cont 
							.upload_img_box
								form(enctype="multipart/form-data" id="file")
									input(type="file" accept="image/gif, image/jpeg, image/png" @change="getLogoImg")
								div(class="balckBg") 点击上传
								img(:src="logoImgUrl")
							p 企业标志图片尺寸为180 * 50，图片格式为jpg，png
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
						el-button(type="primary" class="save_btn" @click="saveSetTheme" :loading="isloadingForPC" :disabled="isDisabledForPC") 保存
				.right_view_box
					h2.top_tlt 预览
					.view_cont_wrap
						.view_tlt
							img(:src="logoImgUrl")
							<i class="el-icon-close"></i>
						.view_cont
							.view_dialog_win
							img(:src="adImgUrl" class="ad_img")
			.cont_box(v-if="activeMenu === 1" :data-type="1")
				h2.top_tlt 设置客服系统 LOGO
				.common_line
					.left_text LOGO图片
					.right_cont 
						.upload_img_box
							form(enctype="multipart/form-data" id="file")
								input(type="file" accept="image/gif, image/jpeg, image/png" @change="getSysLogoImg")
							div(class="balckBg") 点击上传
							img(:src="sysLogoImgUrl")
						p 企业标志图片尺寸为400 * 80，图片格式为jpg，png
				.set_bths
					el-button(type="primary" class="save_btn" @click="saveSysLogo" :loading="isloadingForSysLogo" :disabled="isDisabledForSysLogo") 保存

</template>
<script lang="coffee" src="./index.coffee"></script>
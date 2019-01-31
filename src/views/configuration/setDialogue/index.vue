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
			div(v-if="activeMenu === 0" :data-type="0")
				h2.top_tlt 欢迎语设置
				.cont_box
					.left 欢迎语：
					.right
						textarea(@input="contChange" v-model="welcomeCont")
			.btn_line
				div(class="recover_default_btn" @click="recoverDefault") 恢复默认设置
				el-button(type="primary" class="save_btn" @click="saveSetDialogue" :loading="isloading" :disabled="isDisabled") 保存
</template>
<script lang="coffee" src="./index.coffee"></script>

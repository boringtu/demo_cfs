<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.cont_wrap
		.left_menus
			ul
				li 欢迎语设置
		.right_cont
			h1 欢迎语设置
			.cont_box
				.left 欢迎语：
				.right
					textarea(@input="contChange" v-model="welcomeCont")
			.btn_line
				div(class="recover_default_btn" @click="recoverDefault") 恢复默认设置
				el-button(type="primary" class="save_btn" @click="saveSetDialogue" :loading="isloading" :disabled="isDisabled") 保存
</template>
<script lang="coffee" src="./index.coffee"></script>

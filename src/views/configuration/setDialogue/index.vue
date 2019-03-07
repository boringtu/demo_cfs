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
					@click="changeMenu(item)"
				).
					{{ item.text }}
		.right_cont
			div(v-if="activeMenu === 0" :data-type="0")
				h2.top_tlt 欢迎语设置
				.cont_box
					.left 欢迎语：
					.right
						textarea(@input="contChange" v-model="welcomeCont" ref="focusTextarea")
						i(class="icon icon-attention" v-if="showWarn")
				.btn_line
					div(class="recover_default_btn" @click="isShowPop = true") 恢复默认设置
					el-button(type="primary" class="save_btn" @click="saveSetDialogue" :loading="isloading" :disabled="isDisabled") 保存
			div(v-if="activeMenu === 1" :data-type="1")
				h2.top_tlt 自动分配
				.cont_box
					.left 自动分配
					.right
						//- el-switch(v-model="autoDistributeVal" @change="switchChange")
						div(class="ele-switch" :class="{'is_open': isOpen, 'is_close': !isOpen}" @click="switchDistribute")
						.districtOne
							span(class="radio" :class="{'actived_radio': activedRadio}")
							span(class="radio_word") 依次分配
						.districtTwo
							span(class="checked_box" :class="{'isChecked': activedCheckbox}" @click="boxIsChecked")
							span(class="check_word") 优先分配给上次对过话的客服
				.btn_line
					div(class="recover_default_btn" @click="isShowPop = true") 恢复默认设置
					el-button(type="primary" class="save_btn" @click="saveAutoDistribute" :loading="autoIsloading" :disabled="atuoIsDisabled") 保存
	div(class="popup" v-if="isShowPop === true")
		.pop_cont
			.tlt 恢复默认设置
			.cont 确定恢复默认设置？
			.btns
				el-button(class="popBtn cancel_btn" @click="isShowPop = false") 取消
				el-button(class="popBtn save_btn" @click="recoverDefault") 确定


</template>	
<script lang="coffee" src="./index.coffee"></script>

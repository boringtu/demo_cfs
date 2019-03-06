<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.headbar
	//- button(@click="eventSetting" class="icon icon-setting")
	div(class="line_status" :class="{'onlineStatus': isOnLine === 1, 'offLineStatus': isOnLine === 0}" @click="chooseLineStatus")
		i(class="icon icon-item" :class="{'icon-online': isOnLine === 1, 'icon-afk': isOnLine === 0}") 
		span(class="checked_line_status") {{isOnLine === 1 ? onLineStatus : offLineStatus}}
		i(class="icon icon-arrow-down")
		div(class="slideCont" v-show="isShowSlideCont")
			div(class="line" v-for="item in lineStatusList" @click="chooseCheckedStatus(item)")
				i(class="icon" :class="item.icon")
				span(:class="item.class") {{item.text}}
	el-tooltip(content="退出")
		button(@click="eventExit" class="icon icon-exit")
</template>
<script lang="coffee" src="./index.coffee"></script>

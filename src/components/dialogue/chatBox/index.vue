<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.tab-box
		h2 当前对话
		span.dialogCount(v-if="dialogInfo") 对话次数：{{ dialogInfo.num }}
		button.close(v-if="dialogInfo")
			i.icon.icon-close
	.content-box(:class="{active: isReadyToType}")
		.chat-history
			scrollBox(
				ref="scrollBox"
				mouseWheel=true
				:pullDownRefresh=false
				@pullingDown="onPullingDown"
			)
				.chat-content(
					v-for="(item, i) in list"
					:key="item.id"
				)
					.clear(:class="getSideClass(item.sendType)")
						.msg-bubble
							.msg-content {{ item.message || '&nbsp;' }}
						.msg-arrow
		.chat-toolbar
			button(@click="eventToggleFacePanel")
				i.icon.icon-face
			button(@click="eventChoosePicture")
				i.icon.icon-picture
		.chat-sendbox
			textarea(
				ref="input"
				placeholder="请输入消息..."
				@input="eventInputSendBox"
				@click.enter="eventSend"
				@focus="isReadyToType = 1"
				@blur="isReadyToType = 0"
			)
			textarea.input-copy(readonly ref="inputCopy")
			el-button.send(type="primary" ref="btnSend" :disabled="0" @click="eventSend") 发送
</template>
<script lang="coffee" src="./index.coffee"></script>
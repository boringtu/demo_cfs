<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.tab-box
		h2 当前对话
		span.dialogCount(v-if="dialogInfo") 对话次数：{{ dialogInfo.num }}
		button.close(v-if="dialogInfo")
			i.icon.icon-close
	.content-box(:class="{active: isReadyToType}")
		.chat-history(
			ref="historyWrap"
			@scroll="eventScrollHistory"
		)
			div
				.chat-content(
					v-for="(item, i) in list"
					:key="item.id"
				)
					.time-line 19:02:43
					.clear(:class="item.sendType | sideClass")
						.msg-bubble
							.msg-content {{ item.message || '&nbsp;' }}
						.msg-arrow
							i





				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-opposite")
						.msg-bubble
							.msg-content 额额额
						.msg-arrow
							i
				.chat-content
					.time-line 19:02:43
					.clear(class="msg-self")
						.msg-bubble
							.msg-content 啊啊啊
						.msg-arrow
							i





		.chat-toolbar
			emoji-picker(@emoji="insert" class="emoji-picker" ref="emojiPicker")
				button(slot="emoji-invoker" slot-scope="{ events }" v-on="events")
					i.icon.icon-face
				div(class="face-wrapper" slot="emoji-picker" slot-scope="{ emojis, insert }")
					span.box-arrow
						i
					div.face-box
						div
							span(class="face" v-for="(emoji, emojiName) in emojis.People" :key="emojiName" @click="insertEmoji(emoji)") {{ emoji }}
			button(@click="eventChoosePicture")
				i.icon.icon-picture

		.chat-sendbox
			textarea(
				ref="input"
				placeholder="请输入消息..."
				@keyup.enter.exact="eventSend"
				@focus="isReadyToType = 1"
				@blur="isReadyToType = 0"
				v-model="inputText"
				spellcheck="false"
			)
			el-button.send(type="primary" :disabled="!inputText.trim()" @click="eventSend") 发送
</template>
<script lang="coffee" src="./index.coffee"></script>
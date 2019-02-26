<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.tab-box
		h2 {{ title }}
		span.dialogCount(v-if="dialogInfo") 对话次数：{{ dialogInfo.num }}
		button.close(v-if="isChatting" @click="eventCloseTheChat")
			i.icon.icon-close
		.closing-confirm-box(v-if="confirmToClose")
			span.box-arrow
				i
			p 确定要结束对话吗？
			div
				el-button(type="default" @click="confirmToClose = 0") 取消
				el-button(type="primary" @click="confirmToClose = 0, closingTheChat()") 确定
	.content-box(:class="{active: isReadyToType}")
		.chat-history
			//- 未读消息提醒（顶部）
			.unreadCount(data-type="up" v-if="unreadCount")
				a(href="javascript:;" @click="eventShowUpperUnread") 
					strong {{ unreadCount | calcUnReadCount }} 条新消息
				button.icon.icon-close(@click="clearUnread")
			//- 未读消息提醒（底部）
			.unreadCount(data-type="down" v-if="newUnreadCount")
				a(href="javascript:;" @click="eventShowLowerUnread") 
					strong {{ newUnreadCount | calcUnReadCount }} 条新消息
				button.icon.icon-close(@click="clearNewUnread")
			//- 消息滚动窗口
			.chat-window(
				ref="chatWindow"
				@scroll="eventScrollHistory"
			)
				//- 历史消息加载中
				.loading-history(v-if="isLoadingHistory")
					i.icon.icon-loading.icon-spin.icon-fast
				div(v-if="!dialogInfo" class="no-chat")
					div.icon.icon-dialogue-attention
					p 请在左侧打开对话
				div(ref="chatWrapper")
					//- 每一条消息
					.chat-content(
						v-for="item in chatHistoryList"
						:key="item.id"
						:data-unread="item.isUnread"
						:data-timeline="item.hasTimeline"
					)
						//- 时间线
						.time-line(v-if="item.hasTimeline") {{ item.timeStamp | timeline }}
						//- 消息体
						.clear(:class="item.sendType | sideClass")
							.msg-bubble
								.msg-content(v-html="renderMessage(item)")
							.msg-arrow
								i

		.chat-toolbar(v-if="isChatting")
			emoji-picker(@emoji="insert" class="emoji-picker" ref="emojiPicker" v-if="!isFromIE")
				button(slot="emoji-invoker" slot-scope="{ events }" v-on="events")
					i.icon.icon-face
				div(class="face-wrapper" slot="emoji-picker" slot-scope="{ emojis, insert }")
					span.box-arrow
						i
					div.face-box
						div
							span(class="face" v-for="(emoji, emojiName) in emojis.People" :key="emojiName" @click="insertEmoji(emoji)") {{ emoji }}
			form(enctype="multipart/form-data")
				input(type="file" accept="image/gif, image/jpeg, image/png" @change="eventSendPic")
				i.icon.icon-picture

		.chat-sendbox(v-if="isChatting")
			textarea(
				ref="input"
				placeholder="请输入消息..."
				@keydown.enter.exact="$event.preventDefault()"
				@keyup.enter.exact="eventSend"
				@focus="isReadyToType = 1"
				@blur="isReadyToType = 0"
				v-model="inputText"
				spellcheck="false"
				:readonly="!dialogInfo"
				maxlength="1000"
			)
			el-button.send(type="primary" :disabled="!inputText.trim()" @click="eventSend") 发送
</template>
<script lang="coffee" src="./index.coffee"></script>
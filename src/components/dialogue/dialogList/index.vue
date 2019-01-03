<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
.root
	.tab-box
		.underline(ref="underline")
		ul
			li(:class="{active: tabIndex === 0}" data-index="0")
				a(href="javascript:;" @mouseenter="eventTabMouseEnter" @mouseleave="eventTabMouseLeave" @click="tabIndex = 0") 我的对话
			li(:class="{active: tabIndex === 1}" data-index="1")
				a(href="javascript:;" @mouseenter="eventTabMouseEnter" @mouseleave="eventTabMouseLeave" @click="tabIndex = 1") 已结束对话
	.content-box
		div(v-show="tabIndex === 0")
			div.no-data(v-if="!chattingList.length")
				i.icon.icon-empty-box
				p 暂无对话记录
			p.count-box(v-if="chattingList.length").
				进行中的会话：{{ chattingList.length }}
			ul(data-type="0" v-if="chattingList.length")
				router-link(tag="li" replace :to="item.id | createChatRoute" v-for="item in chattingList" :key="item.id" :class="{active: dialogID === item.id}")
					a
						span.icon-wrap
							i.icon(:class="item.conversation.channel | channelIcon")
						span.time {{ item.message.timeStamp | formatTime }}
						span.count {{ item.unreadCount | unreadCount }}
						h3 {{ item.name }}
						p {{ item.message.message  }}
		div(v-show="tabIndex === 1")
			div.no-data(v-if="!closedList.length")
				i.icon.icon-empty-box
				p 暂无对话记录
			ul(data-type="1" v-if="closedList.length")
				router-link(tag="li" replace :to="item.id | createChatRoute" v-for="item in closedList" :key="item.id" :class="{active: dialogID === item.id}")
					a
						span.icon-wrap
							i.icon(:class="item.conversation.channel | channelIcon")
						span.time {{ item.message.timeStamp | formatTime }}
						span.count {{ item.unreadCount | unreadCount }}
						h3 {{ item.name }}
						p {{ item.message.message  }}
</template>
<script lang="coffee" src="./index.coffee"></script>
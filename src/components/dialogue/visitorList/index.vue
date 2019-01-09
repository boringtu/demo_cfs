<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
el-table.root(height="190" :data="list" @row-click="eventReceiveCustomer")
	el-table-column(label="姓名" prop="name")
	el-table-column(label="渠道" width="60")
		template(slot-scope="scope")
			i.icon(:class="scope.row.conversation.channel | channelIcon")
	el-table-column(label="访问次数" prop="num" width="100")
	el-table-column(label="地理位置" prop="address")
	el-table-column(label="进入时间" width="100")
		template(slot-scope="scope").
			{{ scope.row.conversation.addTime | entryTime }}
	el-table-column(label="等待时间" width="100")
		template(slot-scope="scope").
			{{ scope.row.conversation.waitingTime | waitingTime }}
	el-table-column(label="" prop="conversation.os")
	el-table-column(label="" prop="conversation.browser")
	el-table-column(label="来源" prop="conversation.origin")
</template>
<script lang="coffee" src="./index.coffee"></script>
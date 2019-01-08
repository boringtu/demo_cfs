<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
	.root
		.popus(v-if="dsialogFormVisible")
		.alertBox(v-if="dsialogFormVisible")
			h1.tc.addground_title {{alertTitle}}
			.alertCenter
				el-input(placeholder="请输入分组名称",v-model="initModel")
				.tc.btnBox
					el-button(type="plain",size ="medium ",@click="canleAlert") 取消
					el-button(type="primary",size ="medium ",@click="saveGround") 保存

		el-row
			el-col.tl.f18 客服管理
		.center_box
			.left_box 
				ul.left_ul
					li.tc.first_li
						span.pointer.addspan(@click="addGrouping") + 添加分组
					li.all_li.pointer 全部（{{peopleCount}}）
					
					li.resDatali.pointer(@click="loadRightData" ,@mouseenter="bMouseEnterFun(index)" @mouseleave="bMouseLeaveFun",v-for="(items,index) in  resdata.groups",v-if="index>0") 
						span {{items.name}} 
						b(v-if = "items.count && items.count>=1")({{items.count}})
						cite.fr.clears.zindexBox(v-show="index == indexThis")
							div.btn_gobal.edit_btn.pointer(@click.stop.prevent="editGround(items.name,items.id)") 编辑
							div.btn_gobal.delete_btn.pointer(@click.stop.prevent="deleteGround(items.id)") 删除

		
			.right_box
				.clears.title_ul
					ul.ul_li_fl
						li 总人数：1 
						li 管理员：1
						li 客服：1
						li 被禁用人数：1
					span.fr.addspan.pointer.addServe(@click="aHerf()") + 添加客服
				ul.second_ul_box
					li.fisrt_li.li_span_list
						span 客服ID
						span 姓名
						span 昵称
						span 角色
						span(style="flex:2")  操作
					.overBox(v-if="loadedData")
						//- li.li_span_list.center_li(v-for="items in arrylist")
						li.li_span_list.center_li(v-for="items in groupsList[0].newVal")
							span {{items.account}}
							span {{items.name}}
							span {{items.nickname}}
							span {{items.roleId == 1 ?'管理员':'客服'}}
							span(style="flex:2") 
								b.btn_gobal.edit_btn.pointer 编辑
								b.btn_gobal.disa_btn.pointer(@click="disabeldServe(items.id)") 禁用
								b.btn_gobal.delete_btn.pointer(@click="deletedServe(items.id)") 删除
</template>
<script lang="coffee" src="./index.coffee"></script>
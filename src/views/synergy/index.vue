<style lang="sass" src="./index.sass" scoped></style>
<template lang="pug">
	.root
		.popus(v-if="dsialogFormVisible")
		.alertBox(v-if="dsialogFormVisible",:style="{'width':!hasInput ? '280px':''}")
			h1.tc.addground_title(v-if="hasInput") {{alertTitle}}
			template(v-if="hasInput")
				.alertCenter
					el-input( :placeholder="inputmsg",v-model="initModel",maxlength="20",@focus="hiddentip",ref="inputBox",:class="errorTipbox?'errorInput':''")
					cite.errortip
						span(@click="hiddentip",v-if="errorTipbox") 分组名称不能为空
						i.icon.el-icon-warning(v-if="errorTipbox")
					.tc.btnBox
						el-button.cancle_btn(type="plain",size ="medium ",@click="canleAlert") 取消
						el-button.save_btn(type="primary",size ="medium ",@click="saveGround",:disabled="isxhr") 保存
			template(v-if="!hasInput")
				.titleinfo {{titleinfo}}
				.noInputBox
					.btnBox
						el-button.cancle_btn(type="plain",size ="medium ",@click="canleAlert") 取消
						el-button.save_btn(type="primary",size ="medium ",@click="determine(titleinfo)",:disabled="isxhr") 确定
		el-row
			el-col.tl.f18 客服管理
		.center_box
			.left_box 
				ul.left_ul
					li.tc.first_li
						span.pointer.addspan(@click="addGrouping") + 添加分组
					li.all_li.pointer(@click="loadRightData(0)") 全部（{{peopleCount}}）
					
					li.resDatali.pointer(@click="loadRightData(index)",@mouseenter="bMouseEnterFun(index)" @mouseleave="bMouseLeaveFun",v-for="(items,index) in  resdata.groups",v-if="index>0") 
						span.nametitle {{items.name}}
						span ( {{items.newVal.length}} )
						cite.fr.clears.zindexBox(v-show="index == indexThis")
							div.btn_gobal.edit_btn.pointer(@click.stop.prevent="editGround(items.name,items.id)") 编辑
							div.btn_gobal.delete_btn.pointer(@click.stop.prevent="deleteGround(items.id)") 删除

			.right_box(v-if="loadedData")
				.clears.title_ul
					ul.ul_li_fl
						li 总人数： {{groupsList[initIndex].newVal.length}}
						li 管理员： {{servenumber}}
						li 客服： {{kefnumber}}
						li 被禁用人数： {{disablednumber}}
					span.fr.addspan.pointer.addServe(@click="aHerf()") + 添加客服
				ul.second_ul_box
					li.fisrt_li.li_span_list
						span 客服ID
						span 姓名
						span 昵称
						span 角色
						span(style="flex:2")  操作
					.overBox
						li.li_span_list.center_li(v-for="items,index in groupsList[initIndex].newVal")
							span {{items.account}}
							span {{items.name}}
							span {{items.nickname}}
							span {{items.roleId == 1 ?'管理员':'客服'}}
							span(style="flex:2") 
								b.btn_gobal.edit_btn.pointer(@click="aHerf(items.id)") 编辑
								b.btn_gobal.disa_btn.pointer(@click="disabeldServe($event,index,items.id)")
									span {{items.status == 1 ?'启用':'禁用'}}
								b.btn_gobal.delete_btn.pointer(@click="deletedServe(items.id)") 删除
</template>
<script lang="coffee" src="./index.coffee"></script>
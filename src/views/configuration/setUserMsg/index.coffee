'use strict'
import Utils from '@/assets/scripts/utils'
export default
    data: ->
        switchOpen: ''
        tableData: []
        showData: []
        visitorMsg: ''
        msgNumber: ''
        isShowPop: false
        saveParams: {
            visitorInfoOpen: '',
            visitorInfoMsg: '',
            visitorInfoJson: [
                {
                    "filed": 'name',
                    "name": '账号',
                    "require": '',
                    "type": '',
                    "ban": ''
                },
                {
                    "filed": 'phone',
                    "name": '手机号',
                    "require": '',
                    "type": '',
                    "ban": ''
                }
            ]
        }
        # visitor_info_json: []
        # visitor_info_msg: ''
        # visitor_info_open: ''

    methods:
        getVisitorInfo: ->
            data =
                adminId: ALPHA.admin.adminId
                type: "visitor_info"
            Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence,
            params: data
            .then (res) =>
                if res.msg is 'success'
                    for item in res.data.sys_conf
                        if item.key is "visitor_info_json"
                            @tableData = JSON.parse(item.value)
                            @showData = @tableData.concat()
                        else if item.key is "visitor_info_open"
                            @switchBtn = item.value
                        else if item.key is "visitor_info_msg"
                            @visitorMsg = item.value
                            @msgNumber = @visitorMsg.length + '/200'
        getNumber: ->
            @msgNumber = @visitorMsg.length + '/200'
        # 必填与选填
        boxIsChecked:(index) ->
            if @tableData[index].ban is 0
                if @tableData[index].require is 0
                    @tableData[index].require = 1
                else if @tableData[index].require is 1
                    @tableData[index].require = 0
            else if @tableData[index].ban is 1
                # @$message('该项并未启用，请启用后再进行设置')
                return
        # 是否禁用
        forbiddenOrEnabeld:(index) ->
            if @tableData[index].ban is 0
                @tableData[index].ban = 1
                @tableData[index].require = 0
                @boxIsChecked(index)
                @showData.splice(@tableData[index],1)
            else if @tableData[index].ban is 1
                @tableData[index].ban = 0
                @showData.push(@tableData[index])
        # 恢复默认设置
        recoverDefault: ->
            return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.dialogueModifiable
            params =
                type: 'visitor_info'
            Utils.ajax ALPHA.API_PATH.configManagement.recoverDefaultSet,
                method: 'put'
                data: params
            .then (res) =>
                if res.msg is 'success'
                    vm.$notify
                        type: 'success'
                        title: '已恢复默认设置'
                    @isShowPop = false
        saveVisitorInfo: ->
            if @switchOpen is true
                @switchOpen = 1
            else
                @switchOpen = 0
            return unless ALPHA.checkPermission ALPHA.PERMISSIONS.configManagement.saveVisitorInfo
            Utils.ajax ALPHA.API_PATH.configManagement.saveVisitorInfo,
                method: 'put'
                data:
                    visitorInfoOpen: @switchOpen
                    visitorInfoMsg: @visitorMsg
                    visitorInfoJson: @tableData
            .then (res) =>
                if res.msg is 'success'
                    vm.$notify
                        type: 'success'
                        title: '提示'
                        message: '保存成功'

    created: ->
        @getVisitorInfo()
        # @getNumber()

'use strict'
import Utils from '@/assets/scripts/utils'
export default
    data: ->
        switchOpen: true
        tableData: []
        showData: []
        visitorMsg: ''
        msgNumber: ''
        isShowPop: false
        isUpdate: false
        atuoIsDisabled: true
        # switchOpen: 1
    methods:
        # 获取初始数据
        getVisitorInfo: ->
            data =
                adminId: ALPHA.admin.adminId
                type: "visitor_info"
            Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence,
            params: data
            .then (res) =>
                if res.msg is 'success'
                    console.log res.data.sys_conf
                    for item in res.data.sys_conf
                        if item.key is "visitor_info_json"
                            @tableData = JSON.parse(item.value)
                            @showData = @tableData.concat()
                        if item.key is "visitor_info_open"
                            # if item.value is 0
                            #     @switchOpen = false
                            # else if item.value is 1
                            #     @switchOpen = true
                            @switchOpen = +item.value is 1
                        if item.key is "visitor_info_msg"
                            @visitorMsg = item.value
                            @msgNumber = @visitorMsg.length + '/200'
        getNumber: ->
            @msgNumber = @visitorMsg.length + '/200'
        # 必填与选填
        boxIsChecked:(index) ->
            @atuoIsDisabled = false
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
            @atuoIsDisabled = false
            if @tableData[index].ban is 0
                @tableData[index].ban = 1
                @tableData[index].require = 0
                @boxIsChecked(index)
                @showData.splice(@tableData[index],1)
            else if @tableData[index].ban is 1
                @tableData[index].ban = 0
                @showData.push(@tableData[index])
    	# 获取默认设置
        fetchInitSetting: ->
            data =
                adminId: ALPHA.admin.adminId
                type: 'visitor_info'
            Utils.ajax ALPHA.API_PATH.configManagement.defaultWelcomeSentence,
            params: data
            .then (res) =>
                if res.msg is 'success'
                    for item in res.data.sys_conf
                        if item.key is "visitor_info_json"
                            @tableData = JSON.parse(item.value)
                            @showData = @tableData.concat()
                        if item.key is "visitor_info_open"
                            # if item.value is 0
                            #     @switchOpen = false
                            # else if item.value is 1
                            #     @switchOpen = true
                            #     console.log @switchOpen
                            @switchOpen = true
                            # @switchOpen = item.value is 1
                            # console.log @switchOpen
                        if item.key is "visitor_info_msg"
                            @visitorMsg = item.value
                            @msgNumber = @visitorMsg.length + '/200'
        # 保存按钮是否可用
        saveBtnUnable: ->
            @atuoIsDisabled = false
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
                    @fetchInitSetting()
        saveVisitorInfo: ->
            if @switchOpen is false
                @switchOpen = 0
            else
                @switchOpen = 1
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
                    @getVisitorInfo()

    created: ->
        @getVisitorInfo()
    # watch:
    #     switchOpen (n,o) ->
    #         @isUpdate = true if n

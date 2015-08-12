package nts.system.controllers

import groovy.xml.MarkupBuilder
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.Consumer
import nts.user.domain.UserGroup
import nts.utils.CTools


class WebUserController {
    //nts.program.services.ProgramService programService

    /**
     * 功能：post方法提交用户XML数据,查询用户表，返回xml数据
     。
     * 调用：http://localhost:8080/nts/webUser/list
     * 说明：可参见西南大学接口说明,现在暂不实现
     */
    def list = {

    }

    /**
     * 功能：post方法提交用户XML数据,接口批量保存用户，已存在的用户不保存。
     * 调用：http://localhost:8080/nts/webUser/save
     * 说明：可参见西南大学接口说明,现在暂实现post提交，以后可扩充从xml文件中导入，以满足西南大学导入界面
     */
    def save = {
        def user = null    //xml用户对象
        def consumer = null    //nts.user.domain.Consumer domain对象
        def manager = null    //认证用户(管理员)
        def username = ""
        def msgXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"    //操作返回xml
        def msg = ""
        def authUser = null
        int saveNum = 0
        int existNum = 0
        int okNo = 0
        boolean bOK = true
        boolean bExist = true
        boolean bAuth = false    //认证是否成功

        try {
            def xml = request.XML
            authUser = xml.authUser

            manager = Consumer.findByName(authUser.name.text())
            if (manager && manager.role <= Consumer.MANAGER_ROLE && manager.password == (authUser.password.text()).encodeAsPassword() && manager.userState == true) bAuth = true


            if (bAuth) {
                def userList = xml.users.user
                int userNum = userList.size()

                for (int i = 0; i < userNum; i++) {
                    user = userList[i]
                    bExist = Consumer.countByName(user.name.text()) > 0
                    if (!bExist) {
                        consumer = new Consumer()
                        consumer.name = user.name
                        consumer.nickname = user.name

                        if (!user.password.isEmpty()) consumer.password = (user.password.text()).encodeAsPassword()
                        if (CTools.nullToBlank(user.nickname.text()) != "") consumer.nickname = user.nickname
                        if (!user.trueName.isEmpty()) consumer.trueName = user.trueName
                        if (!user.email.isEmpty()) consumer.email = user.email
                        if (!user.telephone.isEmpty()) consumer.telephone = user.telephone
                        if (!user.idCard.isEmpty()) consumer.idCard = user.idCard

                        if (!user.role.isEmpty()) consumer.role = CTools.nullToZero(user.role)
                        if (!user.uploadState.isEmpty()) consumer.uploadState = CTools.nullToZero(user.uploadState)
                        if (!user.gender.isEmpty()) consumer.gender = CTools.nullToOne(user.gender)
                        if (!user.canDownload.isEmpty()) consumer.canDownload = CTools.nullToZero(user.canDownload)
                        if (!user.userJob.isEmpty()) consumer.userJob = CTools.nullToZero(user.userJob)
                        if (!user.jobName.isEmpty()) consumer.jobName = CTools.nullToZero(user.jobName)
                        if (!user.userEducation.isEmpty()) consumer.userEducation = CTools.nullToZero(user.userEducation)
                        if (!user.canComment.isEmpty()) consumer.canComment = CTools.nullToOne(user.canComment)
                        if (!user.notExamine.isEmpty()) consumer.notExamine = CTools.nullToZero(user.notExamine)

                        //防止用户恶意改为超级管理员
                        if (consumer.role == Consumer.SUPER_ROLE) consumer.role = Consumer.STUDENT_ROLE


                        if (consumer.save(flush: true)) {
                            saveNum++
                        } else {
                            consumer.errors.allErrors.each { println it }
                            bOK = false
                            msg = "The ${i + 1}th user(${user?.name}) can not save!"
                            break
                        }


                    } else {
                        existNum++
                    }

                    okNo = i;
                }

                //生成操作日志
                new OperationLog(operation: OperationEnum.ADD_USER, modelName: '外部调用', operatorIP: request.getRemoteAddr(), tableName: 'consumer', tableId: 0, brief: '添加用户', operator: manager.name, operatorId: 0).save()
            } else {
                bOK = false
                msg = "Authentication failure: please check the user ${authUser.name} in the multimedia system."
            }
        }
        catch (Exception e) {
            bOK = false
            msg = "The ${okNo + 2}th user(${user?.name}) can not save:" + e.toString();
        }

        msgXml += "<message>\n"
        msgXml += "<stauts>${bOK ? 'success' : ' failure'}</stauts>\n"
        msgXml += "<saveNum>${saveNum}</saveNum>\n"
        msgXml += "<existNum>${existNum}</existNum>\n"
        msgXml += "<description>${msg}</description>\n"
        msgXml += "</message>\n"

        render(text: msgXml, contentType: "text/xml", encoding: "UTF-8")
    }

    /**
     * 功能：post方法提交用户XML数据,接口批量删除用户，如果该用户在资源表中有记录或是管理员，不删除改为禁用帐号，避免该用户上传的资源也被删除。
     * 调用：http://localhost:8080/nts/webUser/delete
     * 说明：可参见西南大学接口说明,现在暂实现post提交
     */
    def delete = {
        def user = null
        def consumer = null
        def manager = null
        def username = ""
        def msgXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        def msg = ""
        def authUser = null
        int saveNum = 0
        int existNum = 0
        int okNo = 0
        boolean bOK = true
        boolean hasProgram = true    //资源表中是否有该用户的记录
        boolean bAuth = false    //认证是否成功

        try {
            def xml = request.XML
            authUser = xml.authUser

            manager = Consumer.findByName(authUser?.name?.text())
            if (manager && manager.role <= Consumer.MANAGER_ROLE && manager.password == (authUser.password.text()).encodeAsPassword() && manager.userState == true) bAuth = true

            if (bAuth) {
                def userList = (xml.users.text()).split(',')    //实际上是用户名列表,是个字符串列表

                int userNum = userList.size()

                for (int i = 0; i < userNum; i++) {
                    username = userList[i]

                    consumer = Consumer.findByName(username)
                    //master，匿名用户不能删除
                    if (consumer && consumer.name != 'maser' && consumer.name != 'anonymity') {
                        hasProgram = ProgramModel.countByConsumer(consumer) > 0

                        //用户在资源表中没有记录且不是管理员
                        if (!hasProgram && consumer.role > Consumer.MANAGER_ROLE) {
                            //////////////////////////////////////删除组代码开始 沿用范嘉
                            //通过用户组创建者查询出该用户共创建过多少组
                            def groupList = UserGroup.findAllByConsumer(consumer.id)
                            //循环该组中的对像
                            groupList.toList().each { group ->
                                //循环该用户所创建的组中有多少个用户
                                group.consumers.toList().each {
                                    //删除与userGroup对像的关系
                                    it.removeFromUserGroups(group)
                                    //删除consumer对像实列
                                    group.delete()
                                }
                            }
                            //////////////////////////////////////删除组代码结束 沿用范嘉

                            consumer.delete(flush: true)
                        }
                        //管理员或资源表中有记录的用户禁用不删除
                        else {
                            consumer.userState = false
                            consumer.save(flush: true)
                        }
                    }

                }

                //生成操作日志
                new OperationLog(operation: OperationEnum.DELETE_USER, modelName: '外部调用', operatorIP: request.getRemoteAddr(), tableName: 'consumer', tableId: 0, brief: '删除用户', operator: manager.name, operatorId: 0).save()
            } else {
                bOK = false
                msg = "Authentication failure: please check the user ${authUser?.name} in the multimedia system."
            }
        }
        catch (Exception e) {
            bOK = false
            msg = e.toString();
        }

        msgXml += "<message>\n"
        msgXml += "<stauts>${bOK ? 'success' : ' failure'}</stauts>\n"
        msgXml += "<description>${msg}</description>\n"
        msgXml += "</message>\n"

        render(text: msgXml, contentType: "text/xml", encoding: "UTF-8")
    }

    /**
     * 功能：post方法提交用户XML数据,接口批量修改用户。
     * 调用：http://localhost:8080/nts/webUser/update
     * 说明：可参见西南大学接口说明
     */
    def update = {
        def user = null
        def consumer = null
        def manager = null
        def username = ""
        def msgXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        def msg = ""
        def authUser = null
        int saveNum = 0
        int existNum = 0
        int okNo = 0
        boolean bOK = true
        boolean bExist = true
        boolean bAuth = false    //认证是否成功

        try {
            def xml = request.XML
            authUser = xml.authUser

            manager = Consumer.findByName(authUser.name.text())
            if (manager && manager.role <= Consumer.MANAGER_ROLE && manager.password == (authUser.password.text()).encodeAsPassword() && manager.userState == true) bAuth = true


            if (bAuth) {
                def userList = xml.users.user
                int userNum = userList.size()

                for (int i = 0; i < userNum; i++) {
                    user = userList[i]
                    consumer = Consumer.findByName(user.name.text())
                    if (consumer) {
                        if (!user.newName.isEmpty()) consumer.name = user.newName
                        if (!user.password.isEmpty()) consumer.password = (user.password.text()).encodeAsPassword()
                        if (CTools.nullToBlank(user.nickname.text()) != "") consumer.nickname = user.nickname
                        if (!user.trueName.isEmpty()) consumer.trueName = user.trueName
                        if (!user.email.isEmpty()) consumer.email = user.email
                        if (!user.telephone.isEmpty()) consumer.telephone = user.telephone
                        if (!user.idCard.isEmpty()) consumer.idCard = user.idCard

                        if (!user.role.isEmpty()) consumer.role = CTools.nullToZero(user.role)
                        if (!user.uploadState.isEmpty()) consumer.uploadState = CTools.nullToZero(user.uploadState)
                        if (!user.gender.isEmpty()) consumer.gender = CTools.nullToOne(user.gender)
                        if (!user.canDownload.isEmpty()) consumer.canDownload = CTools.nullToZero(user.canDownload)
                        if (!user.userJob.isEmpty()) consumer.userJob = CTools.nullToZero(user.userJob)
                        if (!user.jobName.isEmpty()) consumer.jobName = CTools.nullToZero(user.jobName)
                        if (!user.userEducation.isEmpty()) consumer.userEducation = CTools.nullToZero(user.userEducation)
                        if (!user.canComment.isEmpty()) consumer.canComment = CTools.nullToOne(user.canComment)
                        if (!user.notExamine.isEmpty()) consumer.notExamine = CTools.nullToZero(user.notExamine)

                        //防止用户恶意改为超级管理员
                        if (consumer.role == Consumer.SUPER_ROLE) consumer.role = Consumer.STUDENT_ROLE

                        if (consumer.save(flush: true)) {
                            //saveNum++
                        } else {
                            //consumer.errors.allErrors.each {
                            //println it
                            //}

                            bOK = false
                            msg = "The ${i + 1}th user(${user?.name}) can not update!"
                            break
                        }


                    } else {
                        existNum++
                    }

                    okNo = i;
                }

                //生成操作日志
                new OperationLog(operation: OperationEnum.EDIT_USER, modelName: '外部调用', operatorIP: request.getRemoteAddr(), tableName: 'consumer', tableId: 0, brief: '修改用户', operator: manager.name, operatorId: 0).save()
            } else {
                bOK = false
                msg = "Authentication failure: please check the user ${authUser.name} in the multimedia system."
            }
        }
        catch (Exception e) {
            bOK = false
            msg = "The ${okNo + 2}th user(${user?.name}) can not save:" + e.toString();
        }

        msgXml += "<message>\n"
        msgXml += "<stauts>${bOK ? 'success' : ' failure'}</stauts>\n"
        msgXml += "<description>${msg}</description>\n"
        msgXml += "</message>\n"

        render(text: msgXml, contentType: "text/xml", encoding: "UTF-8")
    }

    //说明:consumer表中密码字段字节要加大到100
    /**
     发送成功后，返回
     <?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <message stauts=></message>

     status 含义:
     success:成功
     e_xxx失败
     */
}

package nts.admin.programmgr.serverNode

import grails.converters.JSON
import nts.user.domain.Consumer
import org.codehaus.groovy.grails.web.json.JSONElement

class ServerNodeController {
    def serverNodeService;
    def queryReceiveProgram(){
        def result=serverNodeService.queryReceiveProgram(params);
        return render(result as JSON)
    }
    def queryAllProgramHash(){
        def result=serverNodeService.queryAllProgramHash(params);
        return render(result as JSON)
    }
    def queryAllProgram(){
        def result=serverNodeService.queryAllProgram(params);
        return render(result as JSON)
    }
    def saveProgram(){
        Consumer consumer=Consumer.findByName("master");
        params.consumer=consumer;
        def result=serverNodeService.saveProgram(params);
        return render(result as JSON)
    }
}

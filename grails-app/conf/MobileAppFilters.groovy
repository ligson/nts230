import nts.user.domain.Consumer

class MobileAppFilters {
    def filters = {
        /*statistics(controller:'*', action:'*' ){
            before = {
                def statisticController = ['mobileApp', 'mobileLogin', 'mobileProgram'];
                if (statisticController.contains(controllerName)) {
                    if(params.consumerId){
                        session.consumer = Consumer.get(params.consumerId as long);
                    } else {
                        def name = servletContext.anonymityUserName
                        def password = servletContext.anonymityPassword
                        session.consumer = Consumer.findByNameAndPassword(name, password.toString().encodeAsPassword());
                    }
                }
            }
        }*/
    }
}

// 在线人用统计用Filter
class StatisticsFilters {

    public static HashSet onlineUserSet = new HashSet();
    public static HashMap onlineUserMap = new HashMap();

    def filters = {
        statistics(controller:'*', action:'*' ){
            before = {
                def statisticController = ['userActivity', 'userWork', 'community', 'communityMgr', 'notice', 'index', 'program', 'my', 'mobileApp', 'mobile', 'mobileShow'];
                if (statisticController.contains(controllerName)) {
                    // 获取客户端ip
                    String ip = request.getRemoteAddr();
                    if (request.getHeader("x-forwarded-for")) {
                        ip = request.getHeader("x-forwarded-for");
                    }
                    // 获取用户id
                    String consumerId = null;
                    if (session.consumer) {
                        consumerId = session.consumer.id;
                    }
                    if (!consumerId) {
                        return;
                    }
                    // 如果不是匿名用户
                    if (consumerId != "2") {
                        // 删除掉已经保存的匿名用户
                        String removeKey = "${ip}-2";
                        onlineUserSet.remove(removeKey);
                    }
                    // 保存的key，格式：客户端ip + 用户id
                    String key = "${ip}-${consumerId}";
                    onlineUserSet.add(key);
                    onlineUserMap.put(session.getId(), key);
                    def servletContext = session.getServletContext();
                    // 保存相关内容
                    servletContext.setAttribute("onlineNum", onlineUserSet.size());
                    servletContext.setAttribute("onlineUserSet", onlineUserSet);
                    servletContext.setAttribute("onlineUserMap", onlineUserMap);
                }
            }
        }
    }
}
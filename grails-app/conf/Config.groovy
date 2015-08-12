import com.boful.nts.utils.SystemConfig
import com.boful.nts.utils.SystemConstant
import grails.plugin.quartz2.ClosureJob
import groovy.sql.Sql
import org.apache.log4j.RollingFileAppender
import org.quartz.CronExpression
import org.quartz.impl.triggers.CronTriggerImpl
import org.quartz.impl.triggers.SimpleTriggerImpl

import javax.servlet.ServletContext;

// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }
grails.config.locations = ["file:${userHome}/.${SystemConstant.companyName}/${SystemConstant.appName}/${SystemConstant.appName}-config.properties"]
SystemConfig.init("${SystemConstant.appName}");
grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
        all          : '*/*',
        atom         : 'application/atom+xml',
        css          : 'text/css',
        csv          : 'text/csv',
        form         : 'application/x-www-form-urlencoded',
        html         : ['text/html', 'application/xhtml+xml'],
        js           : 'text/javascript',
        json         : ['application/json', 'text/json'],
        multipartForm: 'multipart/form-data',
        rss          : 'application/rss+xml',
        text         : 'text/plain',
        xml          : ['text/xml', 'application/xml'],
        gif          : 'image/gif'
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000
//remoting.rmi.port = 9999
// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']
grails.resources.debug = true
//grails.resources.mappers.uglifyjs.forceBundleMinification = true

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart = false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

environments {
    development {
        grails.logging.jul.usebridge = true
    }
    production {
        grails.logging.jul.usebridge = false
        // TODO: grails.serverURL = "http://www.changeme.com"
    }
}

// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console appender:
    //
    appenders {
//        file name: 'file', file: "${SystemConfig.userHome.path + '/.' + SystemConstant.companyName + '/log/server.log'}"
//        rollingFile name: "myAppender",maxFileSize: 1024, file: "${SystemConfig.userHome.path + '/.' + SystemConstant.companyName + '/log/server.log'}"
//        console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
//        appender new RollingFileAppender(name:"myAppender", maxFileSize:10240, fileName:"${SystemConfig.userHome.path + '/.' + SystemConstant.companyName + '/log/server.log'}")
        appender new org.apache.log4j.DailyRollingFileAppender(name: "dailyAppender", layout: pattern(conversionPattern: "%-d{yyyy-MM-dd HH:mm:ss} [%p]-[%c] %m%n"), file: "${SystemConfig.userHome.path + '/.' + SystemConstant.companyName + '/' + SystemConstant.appName + '/logs/server_'}", datePattern: "yyyy-MM-dd'.log'")
    }

    if ("error".equals(SystemConfig.configObject.logLevel)) {
        error dailyAppender: ['org.codehaus.groovy.grails.web.servlet',        // controllers
                              'org.codehaus.groovy.grails.web.pages',          // GSP
                              'org.codehaus.groovy.grails.web.sitemesh',       // layouts
                              'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
                              'org.codehaus.groovy.grails.web.mapping',        // URL mapping
                              'org.codehaus.groovy.grails.commons',            // core / classloading
                              'org.codehaus.groovy.grails.plugins',            // plugins
                              'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
                              'org.springframework',
                              'org.hibernate',
                              'net.sf.ehcache.hibernate',
                              'com.boful',
                              'nts',
                              'grails.app']
    } else if ("debug".equals(SystemConfig.configObject.logLevel)) {
        debug dailyAppender: ['nts',
                              'com.boful',
                              'grails.app',
                              'org.apache']
    } else if ("off".equals(SystemConfig.configObject.logLevel)) {
        off dailyAppender: ['org.codehaus.groovy.grails.web.servlet',        // controllers
                            'org.codehaus.groovy.grails.web.pages',          // GSP
                            'org.codehaus.groovy.grails.web.sitemesh',       // layouts
                            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
                            'org.codehaus.groovy.grails.web.mapping',        // URL mapping
                            'org.codehaus.groovy.grails.commons',            // core / classloading
                            'org.codehaus.groovy.grails.plugins',            // plugins
                            'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
                            'org.springframework',
                            'org.hibernate',
                            'net.sf.ehcache.hibernate',
                            'com.boful',
                            'nts',
                            'grails.app']
    } else {
        info dailyAppender: ['nts',
                             'com.boful',
                             'grails.app']
    }
}

ckeditor {
    //config = "/js/myckconfig.js"
    skipAllowedItemsCheck = false
    defaultFileBrowser = "ofm"
    upload {
        basedir = "/upload/ckeditor/"
        overwrite = false
        link {
            browser = true
            upload = false
            allowed = []
            denied = ['html', 'htm', 'php', 'php2', 'php3', 'php4', 'php5',
                      'phtml', 'pwml', 'inc', 'asp', 'aspx', 'ascx', 'jsp',
                      'cfm', 'cfc', 'pl', 'bat', 'exe', 'com', 'dll', 'vbs', 'js', 'reg',
                      'cgi', 'htaccess', 'asis', 'sh', 'shtml', 'shtm', 'phtm']
        }
        image {
            browser = true
            upload = true
            allowed = ['jpg', 'gif', 'jpeg', 'png']
            denied = []
        }
        flash {
            browser = false
            upload = false
            allowed = ['swf']
            denied = []
        }
    }
}

// Uncomment and edit the following lines to start using Grails encoding & escaping improvements

// GSP settings
grails {
    views {
        gsp {
            encoding = 'UTF-8'
            htmlcodec = 'xml' // use xml escaping instead of HTML4 escaping
            codecs {
                expression = 'none' // escapes values inside null
                scriptlet = 'none' // escapes output from scriptlets in GSPs
                taglib = 'none' // escapes output from taglibs
                staticparts = 'none' // escapes output from static template parts
            }
        }
        // escapes all not-encoded output at final stage of outputting
        filteringCodecForContentType {
            //'text/html' = 'html'
        }
    }
}


grails.plugin.quartz2.jobSetup.buyTheTicket = { quartzScheduler, ctx ->
    if (SystemConfig.configObject.syncBmc) {
        if (SystemConfig.configObject.syncBmc.cronExpression) {
            String expression = SystemConfig.configObject.syncBmc.cronExpression;
            //how it should look
            def jobDetail = ClosureJob.createJob { jobCtx, appCtx ->
                try {
                    appCtx.coreMgrService.syncTranscodeStateJob();
                    //同步活动作品转码状态
                    appCtx.userActivityService.syncUserWorkTranscodeStateJob();
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("同步转码状态失败!" + e.getMessage());
                }

            }

            def trigger1 = new CronTriggerImpl(name: "trig1", group: "syncBmcJob", cronExpression: expression);

            quartzScheduler.scheduleJob(jobDetail, trigger1)
        }
    }
}
grails.plugin.quartz2.jobSetup.indexJob = { quartzScheduler, ctx ->
    def driverClass = SystemConfig.getDBConfig().driverClassName;
    def url = SystemConfig.getDBConfig().url;
    def username = SystemConfig.getDBConfig().username;
    def password = SystemConfig.getDBConfig().password;
    Sql sql = null;
    try {
        sql = Sql.newInstance(url, username, password, driverClass);
        // 取得高级搜索是否启用
        def seniorSearchOpt = sql.firstRow("SELECT config_value FROM sys_config WHERE config_name='SeniorSearchOpt'");
        if (seniorSearchOpt && seniorSearchOpt.config_value == "true") {
            // 取得高级搜索数据同步表达式
            def cronExpression = sql.firstRow("SELECT config_value FROM sys_config WHERE config_name='CronExpression'");
            if (cronExpression) {
                String expression = cronExpression.config_value;
                if (expression) {
                    if (CronExpression.isValidExpression(expression)) {
                        //how it should look
                        def jobDetail = ClosureJob.createJob { jobCtx, appCtx ->
                            appCtx.searchService.indexProgramJob();
                            appCtx.searchService.indexSerialJob();
                        }
                        def trigger1 = new CronTriggerImpl(name: "trig1", group: "indexJob", cronExpression: expression);

                        quartzScheduler.scheduleJob(jobDetail, trigger1)
                    } else {
                        println("表达式无效:" + expression)
                    }
                }
            }
        }
        sql.close();
    } catch (Exception e) {
        if (sql != null) {
            sql.close();
        }
    }

    if (SystemConfig.configObject.search) {
        if (SystemConfig.configObject.search.enable && Boolean.parseBoolean(SystemConfig.configObject.search.enable)) {
            String expression = SystemConfig.configObject.search.cronExpression;
            if (expression) {
                if (CronExpression.isValidExpression(expression)) {
                    //how it should look
                    def jobDetail = ClosureJob.createJob { jobCtx, appCtx ->
                        appCtx.searchService.indexProgramJob();
                        appCtx.searchService.indexSerialJob();
//                        appCtx.programSearchService.indexJob();
//                        appCtx.serialSearchService.indexJob();
                    }

                    //def trigger1 = new SimpleTriggerImpl(name: "trig1", startTime: new Date(), repeatInterval: 1000 * 60 * 10, repeatCount: -1)
                    def trigger1 = new CronTriggerImpl(name: "trig2", group: "indexJob", cronExpression: expression);

                    quartzScheduler.scheduleJob(jobDetail, trigger1)
                } else {
                    println("表达式无效:" + expression)
                }
            }
        }
    }
}

// 在线人数统计Job
grails.plugin.quartz2.jobSetup.onlineUserCountStatistics = { quartzScheduler, ctx ->
    if (SystemConfig.configObject.olUserCountStatistics) {
        if (SystemConfig.configObject.olUserCountStatistics.cronExpression) {
            String expression = SystemConfig.configObject.olUserCountStatistics.cronExpression;
            //how it should look
            def jobDetail = ClosureJob.createJob { jobCtx, appCtx ->
                try {
                    // 在线人数统计
                    appCtx.coreMgrService.onlineUserCountStatisticsJob();
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("在线人数统计失败!" + e.getMessage());
                }

            }

            def trigger1 = new CronTriggerImpl(name: "trig3", group: "onlineUserCountStatisticsJob", cronExpression: expression);

            quartzScheduler.scheduleJob(jobDetail, trigger1)
        }
    }
}

/*
cachefilter {
    boolean pageCacheEnable = false;
    SystemConfig.init(SystemConstant.appName);
    if (SystemConfig.configObject.pageCache) {
        if (SystemConfig.configObject.pageCache.enable && (Boolean.parseBoolean(SystemConfig.configObject.pageCache.enable.toString()))) {
            pageCacheEnable = true;
            if (SystemConfig.configObject.pageCache.cacheTime) {
                cacheTime = SystemConfig.configObject.pageCache.cacheTime as int;
            }
            println("页面缓存时间:${cacheTime}秒")
        }
    }
    if (pageCacheEnable) {
        println("页面缓存已启用")
    } else {
        println("页面缓存未启用")
    }
    filters = [
            filterStatic      : [
                    enabled: pageCacheEnable,
                    scope  : 'application',
                    time   : cacheTime,
                    expires: 'time',
                    pattern: '/images*/
/*,/css*/
/*,/skin*/
/*,/js*/
/*'
            ],
            filterIndex       : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/index/index'
            ],
            filterCourseIndex : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/courseIndex'
            ],
            filterVideoIndex  : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/videoIndex'
            ],
            filterDocIndex    : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/docIndex'
            ],
            filterImageIndex  : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/imageIndex'
            ],
            filterAudioIndex  : [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/audioIndex'
            ],
            filterProgramIndex: [
                    enabled: pageCacheEnable,
                    scope  : 'session',
                    time   : cacheTime,
                    pattern: '/program/programIndex'
            ]
    ]
}*/

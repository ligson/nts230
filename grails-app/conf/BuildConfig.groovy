
grails.servlet.version = "3.0" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.work.dir = "target/work"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
grails.server.port.http = 8888
//grails.project.war.exploded.dir="target/${appName}"
//grails.war.exploded = false

grails.project.war.file = "target/${appName}-${new Date().format('yyyy-MM-dd-HH-mm-ss')}.war"

// uncomment (and adjust settings) to fork the JVM to isolate classpaths
//grails.project.fork = [
//   run: [maxMemory:1024, minMemory:64, debug:false, maxPerm:256]
//]
grails.project.dependency.resolver = "maven" // or ivy


grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
        excludes "org.springframework:spring-web:3.0.7"

    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve
    legacyResolve false
    // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        mavenRepo("http://developer.ouknow.com:8081/nexus/content/groups/public/")
        grailsCentral()

        mavenLocal()
        mavenCentral()

        // uncomment these (or add new ones) to enable remote dependency resolution from public Maven repositories
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }

    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes e.g.

        compile 'mysql:mysql-connector-java:5.1.22'
        compile 'org.apache.httpcomponents:httpclient:4.3.1'
        compile 'net.sf.opencsv:opencsv:2.3'
        //compile 'c3p0:c3p0:0.9.1.2'
        compile 'com.boful:boful-common:1.0'
        // excludes "bcprov-jdk14","bcmail-jdk14"
        compile "org.springframework:spring-orm:$springVersion"
        compile "org.apache.solr:solr-solrj:4.9.0"
        compile "org.apache.pdfbox:pdfbox:1.8.2"
        compile "com.boful:boful-rms-search:2.0"
        compile "org.tmatesoft.svnkit:svnkit:1.8.5"
    }

    plugins {
        //runtime ":hibernate:3.6.10.7" // or ":hibernate4:4.1.11.6"
        runtime ':hibernate4:4.3.6.1'
        compile ":cached-resources:1.0"
        runtime ":resources:1.2.8"

        // Uncomment these (or add new ones) to enable additional resources capabilities
        compile ":cache-headers:1.1.7"
        runtime ":zipped-resources:1.0"
        runtime ":cached-resources:1.0"
        //compile ":cachefilter:0.5"
        //runtime ":yui-minify-resources:0.1.5"

        build ":tomcat:7.0.55"
        compile ":scaffolding:2.1.2"
        compile ':cache:1.1.8'
        compile ":asset-pipeline:1.9.9"

        // plugins needed at runtime but not for compilation
        runtime ":database-migration:1.4.0"
        runtime ":jquery:1.11.1"



        compile ":ckeditor:4.4.1.0"
        compile ":quartz2:2.1.6.2"
        compile ":remoting:1.3"
        compile ":cxf:2.0.1"
        //compile "org.apache.cxf:cxf-rt-transports-http-jetty:2.7.10"
        // compile ":axis2:0.7.0"
        //compile ":uglify-js-minified-resources:0.1.1"


    }
}

//打包后删除的文件，用于分别打包前台，后台
grails.war.resources = { stagingDir, args ->
    //admin = "admin",则是打后台包，如果为"front"，则是前台包,自行设置，默认为全包
    def admin = "";
    if ("admin".equals(admin)) {
        delete(includeEmptyDirs: true, verbose: true, quiet: false, failonerror: true) {
            fileset(dir: "${stagingDir}/WEB-INF/classes/nts", includes: "front/")
            fileset(dir: "${stagingDir}/WEB-INF/grails-app/views", includes: "community/, index/, my/, program/, communityMgr/, userActivity/, userWork/")
            fileset(dir: "${stagingDir}/js/boful", includes: "community/, index/, userspace/")
            fileset(dir: "${stagingDir}/skin/blue/pc/", includes: "front/")
        }
    } else if ("front".equals(admin)) {
        delete(includeEmptyDirs: true, verbose: true, quiet: false, failonerror: true) {
            fileset(dir: "${stagingDir}/WEB-INF/classes/nts", includes: "admin/")
            fileset(dir: "${stagingDir}/WEB-INF/grails-app/views", includes: "admin/, appMgr/, communityManager/, coreMgr/, programMgr/, userActivityMgr/, userMgr/")
            fileset(dir: "${stagingDir}/js/boful", includes: "admin/, appMgr/, communityManager/, coreMgr/, programMgr/, userActivityMgr/, userMgr/")
            fileset(dir: "${stagingDir}/skin/blue/pc", includes: "admin/")
        }
    }
}

/*
grails.war.resources = { stagingDir, args ->

    if (args == null)
        return;
    def argsMap = parseArgs(args);

    if (argsMap?.ra) {
        println "------ delete no use file in ra begin -------";
        propertyfile(file: "${stagingDir}/WEB-INF/classes/application.properties") {
            entry(key: "app.type", value: "ra")
        }

        delete(includeEmptyDirs: true, verbose: true, quiet: false, failonerror: true) {
            fileset(dir: "${stagingDir}/WEB-INF/classes/cn/topca/tca", includes: "ca/,offlineca/")
            fileset(dir: "${stagingDir}/WEB-INF/grails-app/views", includes: "adminEnroll/,adminManager/,raEnroll/,console/,crs/,ca/,offlineCA/")
        }
        println "------  delete no use file in ra end  -------";
    } else if (argsMap?.offlineca) {
        println "------ delete no use file in offlineca begin -------";
        propertyfile(file: "${stagingDir}/WEB-INF/classes/application.properties") {
            entry(key: "app.type", value: "offlineca")
        }
        delete(includeEmptyDirs: true, verbose: true, quiet: false, failonerror: true) {
            fileset(dir: "${stagingDir}/WEB-INF/classes/cn/topca/tca", includes: "ra/,ca/")
            fileset(dir: "${stagingDir}/WEB-INF/grails-app/views", includes: "adminEnroll/,adminManager/,raEnroll/,console/,crs/,raManager/,userEnroll/,allHost/")
        }
        println "------  delete no use file in offlineca end  -------";
    } else if (argsMap?.ca) {
        println "------  delete no use file in ca end  -------";
        println "------ delete no use file in offlineca begin -------";
        propertyfile(file: "${stagingDir}/WEB-INF/classes/application.properties") {
            entry(key: "app.type", value: "ca")
        }
        delete(includeEmptyDirs: true, verbose: true, quiet: false, failonerror: true) {
            fileset(dir: "${stagingDir}/WEB-INF/classes/cn/topca/tca", includes: "ra/,offlineca/")
            fileset(dir: "${stagingDir}/WEB-INF/grails-app/views", includes: "offlineCA/,userEnroll/,raManager/,allHost")
        }
        println "------  delete no use file in ca end  -------";
    }
}*/



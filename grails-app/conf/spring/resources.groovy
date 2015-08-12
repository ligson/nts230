// Place your Spring DSL code here
/*beans = {
}*/
import com.boful.nts.utils.SystemConfig
import com.boful.nts.utils.SystemConstant
import com.mchange.v2.c3p0.ComboPooledDataSource
import org.springframework.remoting.rmi.RmiProxyFactoryBean
import org.springframework.remoting.rmi.RmiServiceExporter

beans = {

    /**
     * c3P0 pooled data source that forces renewal of DB connections of certain age
     * to prevent stale/closed DB connections and evicts excess idle connections
     * Still using the JDBC configuration settings from DataSource.groovy
     * to have easy environment specific setup available
     */
   /* dataSource(ComboPooledDataSource) { bean ->
        //use grails' datasource configuration for connection user, password, driver and JDBC url
        def configObject = SystemConfig.configObject;
        user = configObject.dataSource.username
        password = configObject.dataSource.password
        driverClass = configObject.dataSource.driverClassName
        jdbcUrl = configObject.dataSource.url
        //c3p0配置
        if (configObject.C3P0.get("acquireIncrement")) {
            acquireIncrement = configObject.C3P0.get("acquireIncrement");
        }
        if (configObject.C3P0.get("acquireRetryAttempts")) {
            acquireRetryAttempts = configObject.C3P0.get("acquireRetryAttempts");
        }
        if (configObject.C3P0.get("acquireRetryDelay")) {
            acquireRetryDelay = configObject.C3P0.get("acquireRetryDelay");
        }
        if (configObject.C3P0.get("checkoutTimeout")) {
            checkoutTimeout = configObject.C3P0.get("checkoutTimeout");
        }
        if (configObject.C3P0.get("initialPoolSize")) {
            initialPoolSize = configObject.C3P0.get("initialPoolSize");
        }
        if (configObject.C3P0.get("maxConnectionAge")) {
            maxConnectionAge = configObject.C3P0.get("maxConnectionAge");
        }
        if (configObject.C3P0.get("maxIdleTime")) {
            maxIdleTime = configObject.C3P0.get("maxIdleTime");
        }
        if (configObject.C3P0.get("maxPoolSize")) {
            maxPoolSize = configObject.C3P0.get("maxPoolSize");
        }
        if (configObject.C3P0.get("autoCommitOnClose")) {
            autoCommitOnClose = configObject.C3P0.get("autoCommitOnClose");
        }
        if (configObject.C3P0.get("forceIgnoreUnresolvedTransactions")) {
            forceIgnoreUnresolvedTransactions = configObject.C3P0.get("forceIgnoreUnresolvedTransactions");
        }
        if (configObject.C3P0.get("idleConnectionTestPeriod")) {
            idleConnectionTestPeriod = configObject.C3P0.get("idleConnectionTestPeriod");
        }
        if (configObject.C3P0.get("maxStatements")) {
            maxStatements = configObject.C3P0.get("maxStatements");
        }
        if (configObject.C3P0.get("maxStatementsPerConnection")) {
            maxStatementsPerConnection = configObject.C3P0.get("maxStatementsPerConnection");
        }
        if (configObject.C3P0.get("overrideDefaultUser")) {
            overrideDefaultUser = configObject.C3P0.get("overrideDefaultUser");
        }
        if (configObject.C3P0.get("overrideDefaultPassword")) {
            overrideDefaultPassword = configObject.C3P0.get("overrideDefaultPassword");
        }
        if (configObject.C3P0.get("propertyCycle")) {
            propertyCycle = configObject.C3P0.get("propertyCycle");
        }
        if (configObject.C3P0.get("testConnectionOnCheckin")) {
            testConnectionOnCheckin = configObject.C3P0.get("testConnectionOnCheckin");
        }
        if (configObject.C3P0.get("automaticTestTable")) {
            automaticTestTable = configObject.C3P0.get("automaticTestTable");
        }
        if (configObject.C3P0.get("breakAfterAcquireFailure")) {
            breakAfterAcquireFailure = configObject.C3P0.get("breakAfterAcquireFailure");
        }
        if (configObject.C3P0.get("connectionCustomizerClassName")) {
            connectionCustomizerClassName = configObject.C3P0.get("connectionCustomizerClassName");
        }
        if (configObject.C3P0.get("connectionTesterClassName")) {
            connectionTesterClassName = configObject.C3P0.get("connectionTesterClassName");
        }
        if (configObject.C3P0.get("debugUnreturnedConnectionStackTraces")) {
            debugUnreturnedConnectionStackTraces = configObject.C3P0.get("debugUnreturnedConnectionStackTraces");
        }
        if (configObject.C3P0.get("driverClass")) {
            driverClass = configObject.C3P0.get("driverClass");
        }
        if (configObject.C3P0.get("factoryClassLocation")) {
            factoryClassLocation = configObject.C3P0.get("factoryClassLocation");
        }
        if (configObject.C3P0.get("maxAdministrativeTaskTime")) {
            maxAdministrativeTaskTime = configObject.C3P0.get("maxAdministrativeTaskTime");
        }
        if (configObject.C3P0.get("maxIdleTimeExcessConnections")) {
            maxIdleTimeExcessConnections = configObject.C3P0.get("maxIdleTimeExcessConnections");
        }
        if (configObject.C3P0.get("minPoolSize")) {
            minPoolSize = configObject.C3P0.get("minPoolSize");
        }
        if (configObject.C3P0.get("numHelperThreads")) {
            numHelperThreads = configObject.C3P0.get("numHelperThreads");
        }
        if (configObject.C3P0.get("preferredTestQuery")) {
            preferredTestQuery = configObject.C3P0.get("preferredTestQuery");
        }
        if (configObject.C3P0.get("testConnectionOnCheckout")) {
            testConnectionOnCheckout = configObject.C3P0.get("testConnectionOnCheckout");
        }
        if (configObject.C3P0.get("unreturnedConnectionTimeout")) {
            unreturnedConnectionTimeout = configObject.C3P0.get("unreturnedConnectionTimeout");
        }

    }*/
    /*service(RmiServiceExporter){
        service=ref("appService")
        serviceName="IApp"
        serviceInterface="com.boful.nts.service.IApp"
        registryPort=9999
    }*/

}

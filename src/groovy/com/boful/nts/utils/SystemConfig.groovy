package com.boful.nts.utils

import org.apache.commons.io.FileUtils
import org.apache.commons.logging.LogFactory
import org.springframework.core.io.ClassPathResource

import javax.servlet.ServletContext

/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-4-23
 * Time: ����8:55
 * To change this template use File | Settings | File Templates.
 */
class SystemConfig {
    public static final File userHome = new File(System.getProperty("user.home"));
    public static File rootDir;
    public static File config;
    public static ConfigObject configObject;
    public static File webRootDir;
    public static boolean isInit = false;

    public static void initWebRootDir(ServletContext servletContext) {
        webRootDir = new File(servletContext.getRealPath("/"));
    }

    public static init(String appName) {
        if (!isInit) {
            isInit = true;
        }
        rootDir = new File(userHome, ".${SystemConstant.companyName}/${appName}");
        if (!rootDir.exists()) {
            rootDir.mkdirs();
        }
        config = new File(rootDir, "${SystemConstant.appName}-config.properties");
        //每次启动读取默认文件
        ClassPathResource resource = new ClassPathResource("${SystemConstant.appName}-config.properties");
        File file;
        if (resource.exists()) {
            file = resource.file;
        } else {
            file = new File("./grails-app/conf/${SystemConstant.appName}-config.properties");
        }
        //拷贝配置文件生成模板，每次启动，保持模板最新
        if (file.exists()) {
            FileUtils.copyFile(file, new File(rootDir, "${SystemConstant.appName}-config-default.properties"));
            //如果用户没有配置文件，就拷贝默认文件
            if (!config.exists()) {
                FileUtils.copyFileToDirectory(file, rootDir)
            }
        }
//        log.debug(file.path);
        Properties properties = new Properties();
        properties.load(new FileInputStream(config))
        configObject = new ConfigSlurper().parse(properties);
       /* if (!configObject.C3P0) {
            SystemConfig.updateC3P0(file);
        }*/
    }
    //更新配置文件文件中的C3P0
    public static updateC3P0(File fileTmp) {
        BufferedReader br = null;
        BufferedWriter bw = null;
        try {
            //读取包中配置文件
            //文件输入输出
            if (fileTmp) {
                br = new BufferedReader(new FileReader(fileTmp));
                bw = new BufferedWriter(new FileWriter(config, true));
                //每一行文本
                String lineText = "";
                Boolean tmpFalse = false;
                //读取文本
                while ((lineText = br.readLine()) != null) {
                    //设置读取位置
                    if (lineText.indexOf("C3P0配置") > 0) {
                        tmpFalse = true;
                    }
                    //写入文件
                    if (tmpFalse) {
                        bw.newLine();
                        bw.append(lineText, 0, lineText.size());
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            //关闭流
            if (br != null) {
                br.close();
            }
            if (bw != null) {
                bw.close();
            }
        }
    }

    public static ConfigObject getDBConfig() {
        return configObject.dataSource;
    }

    public static ConfigObject getMemConfig() {
        return configObject.memcached;
    }

    public static ConfigObject getTranscodeConfig() {
        return configObject.transcode;
    }

    public static ConfigObject getUploadConfig() {
        return configObject.upload;
    }

    public static ConfigObject getMoocAddressAndPort(){
        return configObject.mooc;
    }

    public static void setConfig(String key, String value) {

        StringBuffer stringBuffer = new StringBuffer();
        config.eachLine {
            if (it.startsWith(key + "=")) {
                stringBuffer.append(key + "=" + value);
            } else {
                stringBuffer.append(it);
            }
            stringBuffer.append("\n")
        }
        config.write(stringBuffer.toString(), "UTF-8");

    }

    public static void reload() {
        init(SystemConstant.appName);
    }


}

package com.boful.nts;

import org.apache.log4j.Logger;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
/**
 * Created by Administrator on 2014/6/25.
 */
public class SqlFileExecutor {
    /**
     * 读取 SQL 文件，获取 SQL 语句
     * @param sqlFile SQL 脚本文件
     * @return List<sql> 返回所有 SQL 语句的 List
     * @throws Exception
     */
    private static Logger logger = Logger.getLogger(SqlFileExecutor.class);
    public static List<String> loadSql(String sqlFile) {
        List<String> sqlList = new ArrayList<String>();

        try {
            FileReader reader = new FileReader(sqlFile);
            BufferedReader br = new BufferedReader(reader);
            String str = null;
            while((str = br.readLine()) != null) {
                str = str.trim();
                if(str.trim().length() > 0 && (!str.startsWith("--"))){
                    sqlList.add(str);
                }
            }
            br.close();
            reader.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            sqlList = null ;
        }
        return sqlList ;
    }

    //根据当前版本号，查找新版本文件
    public static String getNewSqlFile(int version, String dataBaseType, String rootPath){
        String file = "" ;
        logger.info("系统当前版本:"+version);
        try {
            int newVersion = version + 1 ;
            String name =  dataBaseType + "-" + newVersion + ".sql" ;
            File sqlFile = new File(rootPath,name) ;
            logger.info("高版本升级文件："+sqlFile.getPath()+(sqlFile.exists()?"存在":"不存在"));
            if(sqlFile.exists()){
                file = sqlFile.getAbsolutePath() ;
            }
            else{
                file = "0" ;
            }
        } catch (Exception e) { file = "-1" ; }

        return file ;
    }

}

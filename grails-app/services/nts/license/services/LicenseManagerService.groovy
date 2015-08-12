package nts.license.services

import com.boful.common.net.utils.NetUtils
import com.boful.nts.utils.CertUtils
import com.boful.nts.utils.CipherUtils
import com.boful.nts.utils.RSACrrptoUtils
import com.boful.nts.utils.SystemConfig
import nts.user.domain.SecurityResource
import org.apache.commons.codec.binary.Base64
import org.apache.log4j.Logger
import sun.misc.BASE64Decoder
import sun.misc.BASE64Encoder

import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.PublicKey
import java.security.cert.Certificate
import java.security.cert.X509Certificate
import java.security.interfaces.RSAPrivateCrtKey
import java.text.SimpleDateFormat

class LicenseManagerService {
    private static Logger logger = Logger.getLogger(LicenseManagerService.class);
    /**
     * 存放bofulLicense赋予的客户端权限
     */
    public static List<String> roleResources = new ArrayList<String>();
    /**
     * 读取license文件
     * @return
     */
    public Map checkLicense() {
        def result = [:];
        def temp = [:];
        StringBuffer buffer = new StringBuffer();
        Map map = new HashMap();
        def path = SystemConfig.rootDir;
        File file = new File(path, "boful_license.txt");
        if (file.exists()) {
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
            String str;
            while ((str = br.readLine()) != null) {
                buffer.append(str);
            }
            String strs = buffer.toString();
            if (strs.indexOf(";") != -1) {
                String[] strings = strs.split(";");
                for (int i = 1; i < strings.length; i++) {
                    String row = strings[i];
                    if (row.indexOf(":") != -1) {
                        int index = row.indexOf(":");
                        map.put(row.substring(0, index), row.substring(index + 1, row.length()))
                    }
                }
                //解码处理
                String objArr = map.get("objArr");
                byte[] bytes = Base64.decodeBase64(objArr);
                def resultKey = queryCustomer();
                PrivateKey privateKey = resultKey.privateKey;
                bytes = RSACrrptoUtils.decrypt(privateKey, bytes);
                objArr = new String(bytes);
                Map objMap = new HashMap();
                if (objArr.indexOf(";") != -1) {
                    strings = objArr.split(";");
                    for (String str1 : strings) {
                        if (str1.indexOf(":") != -1) {
                            int index = str1.indexOf(":");
                            objMap.put(str1.substring(0, index), str1.substring(index + 1, str1.length()));
                        }
                    }
                }

                for (String strMap : objMap.keySet()) {
                    if (strMap.equals("macList")) {
                        String mac = objMap.get("macList").toString();
                        String macStr = mac.substring(1, mac.length() - 1);
                        List macList = new ArrayList();
                        if (macStr.indexOf(",") != -1) {
                            strings = macStr.split(",");
                            for (String str1 : strings) {
                               log.debug("------------mac:-------------"+str1.trim()+",")
                                macList.add(str1.trim());
                            }
                        } else {
                            log.debug("---------------------mac:------------"+macStr.trim()+",")
                            macList.add(macStr.trim());
                        }
                        def macResult = queryMacAddress();
                        String[] strMac = macResult.address.split(";");
                        HashSet set = new HashSet();
                        for(String str111:strMac){
                            log.debug("---------------------------strMac:---------------------"+str111+"-----------")
                            set.add(str111);
                        }
                        log.debug("---------------------if:---------------"+(macList.size() > 0 && (set.size() == macList.size())))
                        if (macList.size() > 0 && (set.size() == macList.size())) {
                            for (String strMac1 : set) {
                                log.debug("-----------------macList.contains(strMac1):----------------"+macList.contains(strMac1))
                                if (!macList.contains(strMac1)) {
                                    logger.error("mac地址不存在或者不匹配");
                                    System.exit(0);
                                }
                            }
                        } else {
                            logger.error("mac地址不存在或者不匹配");
                            System.exit(0);
                        }
                    } else if (strMap.equals("modules")) {
                        String moduleStr = objMap.get("modules").toString();
                        if (moduleStr.indexOf("],[") != -1) {
                            int index = moduleStr.indexOf(",[");
                            String staStr = moduleStr.substring(0, index);
                            String endStr = moduleStr.substring(index + 1, moduleStr.length());
                            if ((staStr.indexOf(",") != -1) && (endStr.indexOf(",") != -1)) {
                                String[] controllerEnNames = staStr.substring(1, staStr.length() - 1).split(",");
                                String[] actionEnNames = endStr.substring(1, endStr.length() - 1).split(",");
                                for (int i = 0; i < controllerEnNames.length; i++) {
                                    String controllerEnName = controllerEnNames[i].trim();
                                    String actionEnName = actionEnNames[i].trim();
                                    SecurityResource resource = SecurityResource.findByControllerEnNameAndActionEnName(controllerEnName, actionEnName);
                                    if (resource) {
                                        roleResources.add(controllerEnName + "-" + actionEnName);
                                    }

                                }
                            }

                        }
                    }
                }





                Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("startDate").toString());
                Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(map.get("endDate").toString());
                Date nowDate = new Date();
                if (startDate > nowDate) {
                    logger.error("目前该项目还未到可以正常运行的时间段内");
                    System.exit(0);
                } else if (endDate < nowDate) {
                    logger.error("项目已经过期");
                    System.exit(0);
                } else {
                    result.success = true;
                    logger.info("license检查通过")
                }
            }
        } else {
            def initCus = initCustomer();
            logger.error("客户未注册,请把" + initCus.path + "目录下" + initCus.fileName + "发送给服务器");
            System.exit(0);
        }
        return result
    }

    /**
     * 读取nts_customer.txt文件
     * @return
     */
    public Map queryCustomer() {
        def result = [:];
        def path = SystemConfig.rootDir;
        File file = new File(path, "nts_customer.txt");
        if (file.exists()) {
            StringBuffer buffer = new StringBuffer();
            Map<String, String> map = new HashMap<String, String>();
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
            String str;
            while ((str = br.readLine()) != null) {
                buffer.append(str);
            }
            String strs = buffer.toString();
            if (strs.indexOf(",") != -1) {
                String[] strings = strs.split(",");
                strings.each {
                    if (it.indexOf(":") != -1) {
                        int index = it.indexOf(":");
                        map.put(it.substring(0, index), it.substring(index + 1, it.length()));
                    }
                }
            }
            BASE64Decoder decoder = new BASE64Decoder();
            Iterator it = map.keySet().iterator();
            for (String key : map.keySet()) {
                if (key.equals("privateKey")) {
                    byte[] byt = decoder.decodeBuffer(map.get(key));
                    PrivateKey privateKey = CipherUtils.byte2PrivateKey(byt);
                    result.privateKey = privateKey;
                }
            }
        } else {
            logger.error(file.getName() + "文件不存在或者不在" + path + "目录下")
        }
        return result;
    }
    /**
     * 生成客户端文件
     */
    public Map initCustomer() {
        def result = [:];
        def path = SystemConfig.rootDir;
        File file = new File(path, "nts_customer.txt");
        if (!file.exists()) {
            def keyStores = queryKeyStore();
            def macs = queryMacAddress();
            PrintWriter writer = new PrintWriter(file);
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append("alias:" + keyStores.alias + ",\n");
            stringBuffer.append("publicKey:" + keyStores.publicKey + ",\n");
            stringBuffer.append("privateKey:" + keyStores.privateKey + ",\n");
            stringBuffer.append("mac:" + macs.address + ",\n");
            stringBuffer.append("hostName:" + macs.hostName);
            writer.println(stringBuffer.toString());
            writer.close();

        }
        result.path = file.getAbsolutePath();
        result.fileName = file.getName();
        return result
    }
    /**
     * 本地生成密钥
     * @return
     */
    public Map queryKeyStore() {
        def result = [:];
        String alias;
        PublicKey publicKey;
        PrivateKey privateKey;
        try {
            KeyStore keyStore = KeyStore.getInstance("jks");
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
            generator.initialize(2048);
            keyStore.load(null, null);
            KeyPair keyPair = generator.generateKeyPair();
            publicKey = keyPair.getPublic();
            privateKey = keyPair.getPrivate();
            alias = UUID.randomUUID().toString();
            result.alias = Base64.encodeBase64String(alias.getBytes("UTF-8"));
            result.publicKey = Base64.encodeBase64String(publicKey.getEncoded());
            result.privateKey = Base64.encodeBase64String(privateKey.getEncoded());
        } catch (e) {
            logger.error("生成密钥对失败！" + e.getMessage());
        }
        return result;
    }
    /**
     * 获取本机所有的物理地址以及主机名
     * @return
     */
    public static Map queryMacAddress() {
        def result = [:];
        StringBuffer buffer = new StringBuffer();
        String hostName;
        try{
            hostName = InetAddress.getLocalHost().getHostName();
            result.hostName = hostName;
            Map map = NetUtils.getMacAddress();
            for (String str : map.keySet()) {
                buffer.append(map.get(str).trim() + ";");
            }
            result.address = buffer.toString();
        }catch (e){
            logger.error("获取不到主机名称,请配置......!")
        }
        return result;

    }


}

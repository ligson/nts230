package nts.utils

import org.apache.commons.lang.StringUtils

import javax.servlet.http.HttpServletRequest
import java.util.regex.Matcher
import java.util.regex.Pattern

class CTools {
    //显示多行文本换行等
    static codeToHtml(strSrc) {
        if (!strSrc) {
            return ''
        }

        strSrc = strSrc.encodeAsHTML()
        strSrc = strSrc.replaceAll('\n\n', '<p>')
        strSrc = strSrc.replaceAll('\r\n', '<br>')
        strSrc = strSrc.replaceAll('\n', '<br>')
        strSrc = strSrc.replaceAll('\t', '&nbsp;&nbsp;&nbsp;&nbsp')
        strSrc = strSrc.replaceAll(' ', '&nbsp;')
        return strSrc
    }

    static nullToBlank(str) {
        if (str == null) return "";
        return str;
    }

    static nullToZero(str) {
        try {
            return str.toInteger()
        }
        catch (Exception e) {
            return 0
        }
    }

    static nullToOne(str) {
        try {
            return str.toInteger()
        }
        catch (Exception e) {
            return 1
        }
    }

    static strToInt(str) {
        try {
            return str.toInteger()
        }
        catch (Exception e) {
            return -1
        }
    }

    static cutString(strSrc, maxLength) {
        if (!strSrc)
            return ''
        else if (strSrc.size() > maxLength)
            return strSrc[0..maxLength] + '...'
        else
            return strSrc
    }

    //通过绝对路径获取文件名称,hasExtName是否包括扩展名
    static readFileName(String sFilePath, boolean hasExtName) {
        if (sFilePath == null || sFilePath == "")
            return "";

        String sFileName = "";
        int nTPos = 0;
        sFilePath = sFilePath.replaceAll("\\\\", "/");
        nTPos = sFilePath.lastIndexOf("/");
        if (nTPos != -1)
            sFileName = sFilePath.substring(nTPos + 1);
        else
            sFileName = sFilePath;

        if (!hasExtName) {
            nTPos = sFileName.lastIndexOf(".");
            if (nTPos > 0) sFileName = sFileName.substring(0, nTPos);
        }

        return sFileName;
    }

    //通过绝对路径获取文件路径,最后以/号结尾
    static readFileDir(String sFilePath) {
        if (sFilePath == null || sFilePath == "")
            return "";

        String sFileDir = "";
        int nTPos = 0;
        sFilePath = sFilePath.replaceAll("\\\\", "/");
        nTPos = sFilePath.lastIndexOf("/");
        if (nTPos > 0) {
            sFileDir = sFilePath.substring(0, nTPos + 1);
        }

        return sFileDir;
    }

    //得到文件扩展名
    static readExtensionName(sFilePath) {
        if (sFilePath == null || sFilePath == "") return ""

        def sExtName = ""
        int nTPos = sFilePath.lastIndexOf(".")
        if (nTPos > 0) sExtName = sFilePath.substring(nTPos + 1)

        return sExtName;
    }

    //生成缩略：sImgPath是源图片路径，sAbbrImgPath是缩略图路径，edgeLength 是缩略图的大小
    static boolean createAbbrImg(String sImgPath, String sAbbrImgPath, float edgeLength) throws Exception {
        /*if(nullToBlank(sImgPath).equals("") || nullToBlank(sAbbrImgPath).equals(""))
        {
            return false;
        }

        if(edgeLength<1) edgeLength = 100F;

        try
        {
            def imageTool = new ImageTool()
            //imageTool.load(f.getBytes())//载入二进制图片数据
            imageTool.load(sImgPath) //从文件载入图片
            imageTool.thumbnail(edgeLength) // 缩略图
            imageTool.writeResult(sAbbrImgPath, "JPEG") //另存为
        }
        catch (Exception e)
        {
            //System.err.println("Can not create abbr img."+e.getMessage());
            throw new Exception("Can not create abbr img:"+e.getMessage());
            //return false;
        }*/
        return true;
    }

    //0转换成未知，用于时长，
    static zeroToUnknown(num) {
        if (num == null || num == 0) {
            return "未知"
        } else {
            return String.valueOf(num)
        }
    }

    /**
     * 得到格式化后的系统当前日期
     * @param strScheme 格式模式字符串:"yyyy-MM-dd HH:mm:ss"
     * @return 格式化后的系统当前时间，如果有异常产生，返回空串""
     * @see java.text.SimpleDateFormat
     */
    public static final String readNowDateTime(String strScheme) {
        String strReturn = null;
        java.util.Date now = new java.util.Date();

        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strScheme);
            strReturn = sdf.format(now);
        }
        catch (Exception e) {
            strReturn = "";
        }

        return strReturn;
    }

    /**
     * 用于将播放时间秒转换为n小时n分n秒
     */
    public static String timeLenToStr(int nTimeLen) {
        String hh, mm, ss, sTimeLen

        hh = String.valueOf((int) (nTimeLen / 3600))
        mm = String.valueOf((int) ((nTimeLen % 3600) / 60))
        ss = String.valueOf((int) (nTimeLen % 60))
        if (hh.length() == 1) {
            hh = "0" + hh
        }
        if (mm.length() == 1) {
            mm = "0" + mm
        }
        if (ss.length() == 1) {
            ss = "0" + ss
        }
        sTimeLen = hh + ":" + mm + ":" + ss

        return sTimeLen
    }

    //实用方法暂时放此，以后移到专门服务页面
    //正整数 + 0 返回true
    static isNumber(str) {
        return str =~ '^\\d+$'
        //"^\\d+$"　　//非负整数（正整数 + 0）
        //"^[0-9]*[1-9][0-9]*$"　　//正整数
        //"^((-\\d+)|(0+))$"　　//非正整数（负整数 + 0）
        //"^-[0-9]*[1-9][0-9]*$"　　//负整数
        //"^-?\\d+$"　　　　//整数
    }

    static isEmpty(String str) {
        if (str == null) {
            return null;
        } else {
            return str.equals("");
        }
    }
    /**
     * 转码UTF8
     */
    static String toUTF8(String trueName) {
        String name = URLEncoder.encode(trueName, "utf-8");
        return name
    }
    /**
     * 解码UTF8
     */
    static String deUTF8(String trueName) {
        String name = URLDecoder.decode(trueName, "utf-8");
        return name
    }

    public static String readInputStreamContent1(String sUrl, String method, String sCode) {
        String sUserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows 2000)";
        String sHtm = "";
        sHtm = readInputStreamContent(sUrl, method, sCode, sUserAgent);

        return sHtm;
    }

    public static String readInputStreamContent(String sUrl, String method, String sCode, String sUserAgent) {
        String curLine = "";
        StringBuffer sbuf = new StringBuffer("");
        try {
            URL url = new URL(sUrl);
            HttpURLConnection httpUrl = (HttpURLConnection) url.openConnection();
            httpUrl.setRequestMethod(method);
            httpUrl.setRequestProperty("User-Agent", sUserAgent); //模仿IE 否则被禁
            //httpUrl.setRequestProperty("accept","text/xml");
            httpUrl.setConnectTimeout(500);
            httpUrl.setReadTimeout(60000);

            httpUrl.connect();
            InputStream is = httpUrl.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, sCode));//用于网页是utf-8编码

            while ((curLine = reader.readLine()) != null) {
                sbuf.append(curLine);
            }

            is.close();
            reader.close();
            httpUrl.disconnect();
        } catch (Exception e) {
            e.printStackTrace()
        }

        return sbuf.toString();
    }

    private static String remoteService(String sUrl, Object object, String method, String sCode) {
        HttpURLConnection httpUrl = null;
        URL url = null;

        String sHtm = "";
        String curLine = "";
        StringBuffer sbuf = new StringBuffer();
        try {
            url = new URL(sUrl);
            httpUrl = (HttpURLConnection) url.openConnection();
            httpUrl.setDoOutput(true);
            httpUrl.setRequestMethod(method);
            //httpUrl.setRequestProperty("User-Agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows 2000)"); //模仿IE 否则被禁
            httpUrl.setRequestProperty("Content-Type", "text/xml");
            httpUrl.setConnectTimeout(60000);
            httpUrl.setReadTimeout(60000);

            httpUrl.connect();

            OutputStreamWriter wr = new OutputStreamWriter(httpUrl.getOutputStream(), sCode);
            wr.write(object.toString());
            wr.flush();
            wr.close();

            InputStream is = httpUrl.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, sCode));//用于网页是utf-8编码

            while ((curLine = reader.readLine()) != null) {
                sbuf.append(curLine);
            }

            is.close();
            reader.close();
            httpUrl.disconnect();

            sHtm = sbuf.toString();

        } catch (Exception e) {
            e.printStackTrace()
        }

        return sHtm;
    }

    private static String getInputStreamContent(InputStream is) {
        StringBuffer sb = new StringBuffer()
        BufferedReader reader = new BufferedReader(new InputStreamReader(is, "utf-8"));

        String content = ""
        while ((content = reader.readLine()) != null) {
            sb.append(content);
        }

        return sb.toString()
    }

    //获得时间计划中的不同的日期显示  2010.12.29 by xieyabo
    static String getDate(int nType, int nTimeLen) {
        String sDate = "";
        switch (nType) {
            case 0:
                sDate = "每天";
                break;
            case 1:
                def arrWeek = ["每周一", "每周二", "每周三", "每周四", "每周五", "每周六", "每周日"];
                sDate = arrWeek[(int) (nTimeLen / 86400)];
                break;
            case 2:
                sDate = "每月" + ((int) (nTimeLen / 86400)) + "日";
                break;
            case 3:
                int month = ((int) (nTimeLen / (86400 * 31)))
                int day = ((int) ((nTimeLen % (86400 * 31)) / 86400))
                if (day == 0) {
                    day = 31;
                    month = month - 1
                }
                sDate = month + "月" + day + "日";
                break;
            default:
                break;
        }
        return sDate;
    }

    /**
     * 得到定时表达式
     * @param nType 0.天 1.周 2.月 3.年
     * @param nTimeLen 对应数据库start_time字段
     * @return String
     */
    static String getCronExpression(int nType, int nTimeLen) {
        String express = "";

        def SHour = ((nTimeLen % 86400) / 3600).intValue()
        def SMin = ((nTimeLen % 3600) / 60).intValue()
        def SSec = (nTimeLen % 60).intValue()

        express = "${SSec} ${SMin} ${SHour} "

        switch (nType) {
            case 0:
                //每天
                express += "* * ?";
                break;
            case 1:
                def arrWeek = [2, 3, 4, 5, 6, 7, 1];
                express += "? * ${arrWeek[(int) (nTimeLen / 86400)]}";
                break;
            case 2:

                express += "${(int) (nTimeLen / 86400)} * ?";
                break;
            case 3:
                int month = ((int) (nTimeLen / (86400 * 31)))
                int day = ((int) ((nTimeLen % (86400 * 31)) / 86400))
                int year = Calendar.getInstance().get(Calendar.YEAR);
                if (day == 0) {
                    day = 31;
                    month = month - 1
                }
                express += "${day} ${month} ? ${year}";
                break;
            default:
                break;
        }
        return express;
    }

    //用于首页内容描述中去掉<p></p>等html标签
    static htmlToBlank(strSrc) {
        if (!strSrc) {
            return ''
        }

        strSrc = strSrc.replaceAll('<[\\s\\S]*?>', '')
        return strSrc
    }

    //用于统计图表时 数据为0时设定一个最小的数
    static nullToSmall(str) {
        if (str == 0) {
            return 0.01
        }
        return str.toInteger()
    }

    //用于全文检索
    static String enhance(String content, String keyword, String prefix, String suffix) {
        StringBuffer result = null
        result = new StringBuffer();
        int index = content.indexOf(keyword);
        if (index != -1) {
            result.append(content.substring(0, index));
            result.append("@").append(content.substring(index, index + keyword.length())).append("#");
            result.append(content.substring(index + keyword.length(), content.length()));
            return result.toString().replace("@", prefix).replace("#", suffix);
        } else {
            result.append(content);
            return result.toString()
        }
    }

    /**
     * 返回两个日期相差的天数  来自网上， 原函数名getDistDates
     * @param startDate
     * @param endDate
     * @return
     * @throws java.text.ParseException
     */
    static int dateDiff(Date startDate, Date endDate) {
        int totalDate = 0;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        long timestart = calendar.getTimeInMillis();
        calendar.setTime(endDate);
        long timeend = calendar.getTimeInMillis();
        totalDate = (Math.abs((timeend - timestart)) / (1000 * 60 * 60 * 24));
        return totalDate;
    }

    /**
     * 得到格式化后的给定日期
     * @param strScheme 格式模式字符串:"yyyy-MM-dd HH:mm:ss"
     * @return 格式化后的系统当前时间，如果有异常产生，返回空串""
     * @see java.text.SimpleDateFormat
     */
    public static final String readSpecifiedDateTime(String strScheme, Date date) {
        String strReturn = null;

        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strScheme);
            strReturn = sdf.format(date);
        }
        catch (Exception e) {
            strReturn = "";
        }

        return strReturn;
    }

    //获得15位IP地址，用于IP段限制比较
    public static String get15WIP(String vIP) {
        String strIP = "";
        String[] arrIP;
        arrIP = str2Array(vIP, ".");
        if (arrIP.length != 4) {
            return "";
        }
        try {
            for (int i = 0; i < 4; i++) {
                if (arrIP[i].length() == 1)
                    arrIP[i] = "00" + arrIP[i];
                else if (arrIP[i].length() == 2)
                    arrIP[i] = "0" + arrIP[i];

                if (strIP == "")
                    strIP = arrIP[i];
                else
                    strIP = strIP + "." + arrIP[i];
            }
        }
        catch (Exception e) {
            return "";
        }
        return strIP;
    }

    /**
     * add by jianglf 用于得到当前日期后(或前)多少天，月，年的日期。
     /* sDateType为YEAR,MONTH,DATE;nAddNum为整数，负数表示前多少天，或月或年,正数表后
     /*如：getAfterOrBeforeDate("MONTH",-3)表示得3个月前的日期字符串：2003-03-04
     */
    public static String readAfterOrBeforeDate(String sDateType, int nAddNum,
                                               String sSeparate) {
        String sYear, sMon, sDay, todayTimeWeekStr;
        if (sSeparate.equals("")) {
            sSeparate = "-";

        }
        GregorianCalendar calendar = new GregorianCalendar();

        if (sDateType.equals("YEAR")) {
            calendar.add(calendar.YEAR, nAddNum);
        } else if (sDateType.equals("MONTH")) {
            calendar.add(calendar.MONTH, nAddNum);
        } else if (sDateType.equals("DATE")) {
            calendar.add(calendar.DATE, nAddNum);
        } else {
            return "";
        }

        sYear = String.valueOf(calendar.get(Calendar.YEAR));
        sMon = String.valueOf(calendar.get(Calendar.MONTH) + 1);
        if (sMon.length() == 1) {
            sMon = "0" + sMon;
        }
        sDay = String.valueOf(calendar.get(Calendar.DATE));
        if (sDay.length() == 1) {
            sDay = "0" + sDay;

        }
        todayTimeWeekStr = sYear + sSeparate + sMon + sSeparate + sDay;

        return todayTimeWeekStr;
    }

    public static String[] str2Array(String str) {
        if (str == null) {
            return null;
        }

        if (str.charAt(str.length() - 1) == ',') {
            str = str.substring(0, str.length() - 1);

        }
        StringTokenizer token = new StringTokenizer(str, ",");
        String[] array = new String[token.countTokens()];

        int i = 0;

        while (token.hasMoreTokens()) {
            array[i] = token.nextToken();
            i++;
        }

        return array;
    }

    public static String[] str2Array(String str, String delim) {
        if (str == null) {
            return null;
        }

        if (str.endsWith(delim)) {
            str = str.substring(0, str.length() - 1);

        }
        StringTokenizer token = new StringTokenizer(str, delim);
        String[] array = new String[token.countTokens()];

        int i = 0;

        while (token.hasMoreTokens()) {
            array[i] = token.nextToken();
            i++;
        }

        return array;
    }

    public static String findImgFormContent(String content) {
        if (StringUtils.isBlank(content)) {
            return "";
        }
        Pattern pattern = Pattern.compile("<img [^<>]*>");
        Matcher matcher = pattern.matcher(content);
        if (matcher.find()) {
            Pattern pattern1 = Pattern.compile("src=\"[^\"]*\"");
            Matcher matcher1 = pattern1.matcher(matcher.group());
            if (matcher1.find()) {
                return matcher1.group().replaceAll("src=", "").replaceAll("\"", "");
            }
        }
        return "";
    }
    /**
     * 获取用户真实ip
     * @param request
     * @return
     */
    public static String readIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("http_client_ip");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        // 如果是多级代理，那么取第一个ip为客户ip
        if (ip != null && ip.indexOf(",") != -1) {
            ip = ip.substring(ip.lastIndexOf(",") + 1, ip.length()).trim();
        }
        return ip;
    }

    //解析字符串
    public static boolean regex(String regex, String str) {
        Pattern p = Pattern.compile(regex, Pattern.MULTILINE);
        Matcher m = p.matcher(str);
        return m.find();
    }

    /**
     * 根据毫秒数转换为n小时n分n秒.毫秒
     */
    public static String timeMillisToStr(long nTimeMillisLen) {
        String hh, mm, ss, sTimeLen, ms
        int nTimeLen = (int) (nTimeMillisLen / 1000)
        hh = String.valueOf((int) (nTimeLen / 3600))
        mm = String.valueOf((int) ((nTimeLen % 3600) / 60))
        ss = String.valueOf((int) (nTimeLen % 60))
        ms = String.valueOf((int) (nTimeMillisLen % 1000))
        if (hh.length() == 1) {
            hh = "0" + hh
        }
        if (mm.length() == 1) {
            mm = "0" + mm
        }
        if (ss.length() == 1) {
            ss = "0" + ss
        }
        sTimeLen = hh + ":" + mm + ":" + ss + "." + ms

        return sTimeLen
    }
}
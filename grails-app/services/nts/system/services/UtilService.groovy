package nts.system.services

import com.boful.nts.service.model.RMSNode
import com.boful.nts.wsdl.client.RmsNode
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFFont
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.util.HSSFColor
import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.codehaus.groovy.grails.web.util.WebUtils

import javax.servlet.ServletContext
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

class UtilService {

    public static final anonymousName = "anonymous";
    def grailsApplication
    def appService
    /**
     * Getting the Request object
     * @return
     */
    public HttpServletRequest getRequest() {
        def webUtils = WebUtils.retrieveGrailsWebRequest()
        return webUtils.getCurrentRequest()
    }

    /**
     * Getting the Response object
     * @return
     */
    public HttpServletResponse getResponse() {
        def webUtils = WebUtils.retrieveGrailsWebRequest()
        return webUtils.getCurrentResponse()
    }

    /**
     * Getting the ServletContext object
     * @return
     */
    public ServletContext getServletContext() {
        try {
            def webUtils = WebUtils.retrieveGrailsWebRequest()
            return webUtils.getServletContext()
        } catch (Exception ignored) {
            ServletContext servletContext = ServletContextHolder.servletContext
            return servletContext;
        }
    }

    /**
     * Getting the Session object
     * @return
     */
    public HttpSession getSession() {
        return getRequest().getSession();
    }

    public Consumer getCurrentUser() {
        Consumer consumer = getSession().getAttribute("consumer") ? (getSession().getAttribute("consumer") as Consumer) : null;
        return consumer;
    }

    public File buildExcel(Properties properties) {
        try {
            HSSFWorkbook workbook = new HSSFWorkbook();
            Sheet sheet = workbook.createSheet();
            Row row = sheet.createRow(0);
            //row.setHeight((short) 100);
            sheet.setColumnWidth(0, 10000);

            HSSFCellStyle cellStyle = workbook.createCellStyle();
            cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
            cellStyle.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);

            HSSFFont fontStyle = workbook.createFont();
            fontStyle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            cellStyle.setFont(fontStyle);

            Cell cell1 = row.createCell(0);
            Cell cell2 = row.createCell(1);


            cell1.setCellValue("名称");
            cell2.setCellValue("值");

            cell1.setCellStyle(cellStyle)
            cell2.setCellStyle(cellStyle)

            properties.eachWithIndex { property, index ->
                Row _row = sheet.createRow(index + 1);
                Cell _cell1 = _row.createCell(0);
                Cell _cell2 = _row.createCell(1);
                _cell1.setCellValue(property.getKey().toString());
                _cell2.setCellValue(property.getValue().toString());
            }

            File file = File.createTempFile("properties", ".xls");
            FileOutputStream fileOutputStream = new FileOutputStream(file);
            workbook.write(fileOutputStream);
            fileOutputStream.close();
            return file;
        } catch (Exception e) {
            log.error(e);
        }
        return null;
    }

    public String generalVideoServerUrl() {
        ServletContext servletContext = getServletContext();

        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口


        String ip = null;
        String port = null;

        if (!videoSevr) {
            SysConfig sysConfig = SysConfig.findByConfigName('VideoSevr');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                ip = sysConfig.configValue;
            } else {
                ip = InetAddress.getLocalHost().getHostAddress();
            }
            servletContext.setAttribute("videoSevr", ip);
        } else {
            ip = videoSevr;
        }

        if (!videoPort) {
            SysConfig sysConfig = SysConfig.findByConfigName('videoPort');     //视频服务器IP地址
            if (sysConfig && sysConfig.configValue) {
                port = sysConfig.configValue;
            } else {
                port = "1680";
            }

            servletContext.setAttribute("videoPort", port);
        } else {
            port = videoPort;
        }
        return "http://${ip}:${port}/bmc/";
    }

    public RMSNode findLocalNode() {
        return appService.queryNodeInfo();
    }

    public ServerNode findLocalServerNode() {
        RMSNode rmsNode = findLocalNode();
        return ServerNode.findByIpAndPort(rmsNode.getRmsIPAddress(), rmsNode.getRmsIPPort());
    }

}

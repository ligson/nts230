package nts.program.services

import com.boful.common.file.utils.FileType
import com.boful.nts.utils.SystemConfig
import com.boful.rms.search.provider.RmsSearchProvider
import grails.transaction.Transactional
import nts.program.domain.Program
import nts.program.domain.Serial
import org.apache.commons.io.FileUtils
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.pdfbox.pdmodel.PDDocument
import org.apache.pdfbox.util.PDFTextStripper
import org.apache.solr.client.solrj.SolrServerException

import javax.servlet.ServletContext

/**
 * Created by tianqiulian on 14-9-17.
 */
@Transactional
class SearchService {
    private static RmsSearchProvider rmsSearchProvider;
    def programService;

    public void init(ServletContext servletContext) throws Exception {
        try {
            String programUrl = SystemConfig.configObject.search.solr.program.url;
            String serialUrl = SystemConfig.configObject.search.solr.serial.url;
            //String programUrl = servletContext.solrProgramUrl;
            //String serialUrl = servletContext.solrSerialUrl;
            rmsSearchProvider = new RmsSearchProvider(programUrl, serialUrl);
        } catch (Exception e) {
            log.error("索引服务初始化失败", e)
        }
    }

//    private static Program modelToProgram(ProgramModel programModel) {
//        return Program.findByIdAndGuid(programModel.getId(), programModel.getGuid());
//    }
//
//    private Serial modelToSerial(SerialModel model) {
//        return Serial.findById(model.getId());
//    }

    public Object searchByGuid(Object obj, String guid) {
        Class aClass = obj.getClass();
        if (aClass == Program.class) {
            return rmsSearchProvider.searchProgramByGuid(guid);
        } else if (aClass == Serial.class) {
            return rmsSearchProvider.searchSerialByGuid(guid);
        }
    }

    public void indexProgram(List<Program> programList) {
        try {
            rmsSearchProvider.addProgramIndexAll(programList);
//            rmsSearchProvider.serverCommit(Program);
        } catch (Exception e) {
            log.error(e);
        }
    }

    public void indexSerial(List<Serial> serials, List<String> contentList) {
        try {
            rmsSearchProvider.addSerialIndexAll(serials, contentList);
        } catch (Exception e) {
            log.error(e);
        }
    }

    public void addProgramIndex(Program program) {
        try {
            rmsSearchProvider.addProgramIndex(program);
        } catch (Exception e) {
            log.error(e);
        }
    }

    public void addSerialIndex(Serial serial) {
        try {
            String content = findContent(serial);
            rmsSearchProvider.addSerialIndex(serial, content);
        } catch (Exception e) {
            log.error(e);
        }
    }

    public void deleteIndex(Object obj, String guid) {
        Class aClass = obj.getClass();
        rmsSearchProvider.deleteIndex(guid, aClass);
    }

    public void deleteSerialIndex(Serial serial) {
        String guid = serial.program.guid + "#" + serial.id;
        deleteIndex(serial, guid);
    }

    public void deleteAllIndex(Object obj) {
        Class aClass = obj.getClass();
        rmsSearchProvider.deleteAllIndex(aClass);
    }

    public void updateProgramIndex(Program program) {
        try {
            rmsSearchProvider.updateProgramIndex(program);
        } catch (Exception e) {
            log.error(e)
        }
    }

    public void updateSerialIndex(Serial serial) {
        String content = findContent(serial);
        try {
            rmsSearchProvider.updateSerialIndex(serial, content);
        } catch (Exception e) {
            log.error(e);
        }
    }

    public Map<String, Object> searchProgram(List<String> field, List<String> key, List<String> relation, List<String> facetField, Map<String, Object> facetValue, int start,
                                             int count, List<String> sortfield, List<Boolean> flag, boolean hightlight) {
        Map<String, Object> map = new HashMap<String, Object>();
        map = rmsSearchProvider.searchObject(Program.class, field, key, relation, facetField, facetValue, start, count, sortfield, flag, hightlight);
        if (map == null) {
            map = new HashMap<String, Object>();
        }
        return map;
    }

    public Map<String, Object> searchSerial(List<String> field, List<String> key, List<String> relation, int start,
                                            int count, List<String> sortfield, List<Boolean> flag, boolean hightlight) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<String> facetField = [];
        Map<String, Object> facetValue = [:];
        map = rmsSearchProvider.searchObject(Serial.class, field, key, relation, facetField, facetValue, start, count, sortfield, flag, hightlight)
        if (map == null) {
            map = new HashMap<String, Object>();
        }
        return map;
    }

    public String[] suggestProgram(String prefix, int min) {
        String[] words = null;
        words = rmsSearchProvider.suggest(Program.class, prefix, min);
        return words;
    }

    public String[] suggestSerial(String prefix, int min) {
        return rmsSearchProvider.suggest(Serial.class, prefix, min);
    }

    private String findContent(Serial serial) {
        if (FileType.isDocument(serial.filePath) || serial.filePath.endsWith("pdf") || serial.filePath.endsWith("PDF")) {
            def jsonObject = programService.generalFilePlayAddress(serial.fileHash, true);
            if (jsonObject && jsonObject.playList[0]) {
                String url = jsonObject.playList[0].url;
                try {
                    File file = downloadPdf(url);
                    if (file && file.exists()) {
                        String content = pdfToText(file);
                        if (content != null) {
                            file.delete();
                            return content;
                        }
                    }
                } catch (Exception e) {
                    log.error(e);
                }
            } else {
                log.error("播放地址获取失败");
            }
        }
        return "";
    }

    private File downloadPdf(String url) {
        HttpClient client = HttpClientBuilder.create().build();
        HttpGet getMethod = new HttpGet(url);
        getMethod.setHeader("Referer", "http://192.168.1.0")

        File file = new File("./tmp/" + new Date().getTime() + ".pdf");
        try {
            HttpResponse httpResponse = client.execute(getMethod);
            HttpEntity httpEntity = httpResponse.getEntity()
            InputStream inputStream = httpResponse.getEntity().getContent()

            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            if (file.exists()) {
                file.delete();
            }
            file.createNewFile();
            FileUtils.copyInputStreamToFile(inputStream, file);
            return file;
        } catch (Exception e) {
            log.error("下载url:${url}失败");
            if (file.exists()) {
                file.delete();
            }
            return null;
        }

    }

    private String pdfToText(File pdfFile) {
        //是否排序
        boolean sort = false;

        //输入文本文件名称
        String textFile = null;
        //编码方式
        String encoding = "UTF-8";
        //开始提取页数
        int startPage = 1;
        //结束提取页数
        int endPage = Integer.MAX_VALUE;
        //文件输入流，输入文本文件
        Writer output = null;
        //内存中存储的PDF Document
        PDDocument document = null;

        try {
            try {
                //首先当作一个URL来加载文件，如果得到异常再从本地系统装载文件
                document = PDDocument.load(pdfFile);
                String fileName = pdfFile.getName();

                if (fileName.length() > 4) {
                    //以原来pdf名称来命名新产生的txt文件
                    File outputFile = new File("./tmp", fileName.substring(0, fileName.length() - 4) + ".txt");
                    textFile = outputFile.getName();
                }
            } catch (Exception e) {
                log.error("解析文件失败：${pdfFile}")
            }
            //文件输出流，写入文件到textFile
            output = new OutputStreamWriter(new FileOutputStream(textFile), encoding);
            //PDFTextStripper来提取文本
            PDFTextStripper stripper = new PDFTextStripper();
            //设置是否排序
            stripper.setSortByPosition(sort);
            //设置起始页
            stripper.setStartPage(startPage);
            //设置结束页
            stripper.setEndPage(endPage);
            //调用PDFTextStripper的writeText提取并输出文本
            stripper.writeText(document, output);
            File textFile2 = new File(textFile);
            String text = textFile2.getText();
            if (text != null) {
                text.replaceAll(" ", "");
            }
            textFile2.delete();
            return text;
        } catch (Exception e) {
            log.error(e);
        } finally {
            if (output != null) {
                output.close();
            }
            if (document != null) {
                document.close();
            }
        }
        return null;
    }

    static long offsetProgram = 0;
    static long offsetSerial = 0;

    public void indexProgramJob() {
        if (!rmsSearchProvider) {
            return;
        }
        try {
            // SolrPingResponse pingResponse = new HttpSolrServer(server.baseURL+"/admin/ping").ping();
        } catch (SolrServerException e1) {
            log.error("资源搜索solr服务未连接");
            return;
        }

        def programIds = [];
        List states = new ArrayList();
        states.add(Program.STATE_SUCCESS);
        states.add(Program.STATE_SUCCESS_PART);
        programIds = Program.createCriteria().list() {
            projections {
                distinct('id')
            }
            'in'("transcodeState", states.toArray())
        }
        int total = Program.countByIdInList(programIds);
        if (offsetProgram > total) {
            offsetProgram = 0;
        }
        List<Program> list = Program.findAllByIdInList(programIds, [offset: offsetProgram, max: 100, sort: 'id', order: 'desc']);
        offsetProgram += 100;
        try {
            indexProgram(list);
        } catch (Exception e) {
            log.error("索引失败!", e);
        }
    }

    public void indexSerialJob() {
        if (!rmsSearchProvider) {
            return;
        }
        try {
            //SolrPingResponse pingResponse = new HttpSolrServer(server.baseURL+"/admin/ping").ping();
        } catch (SolrServerException e1) {
            log.error("文档搜索solr服务未连接", e1);
            return;
        }

        int total = Serial.countByStateAndUrlType(Serial.CODED_STATE, Serial.URL_TYPE_DOCUMENT);
        if (offsetSerial > total) {
            offsetSerial = 0;
        }
        List<Serial> serials1 = Serial.findAllByStateAndUrlType(Serial.CODED_STATE, Serial.URL_TYPE_DOCUMENT, [offset: offsetSerial, max: 100, sort: 'id', order: 'desc']);
        offsetSerial += 100;
        List<String> contentList = new ArrayList<String>();
        for (Serial serial1 : serials1) {
            String content = findContent(serial1);
            contentList.add(content);
        }
        try {
            indexSerial(serials1, contentList);
        } catch (Exception e) {
            log.error("索引失败!", e);
        }
    }

    /**
     * 根据id同步索引
     * @param programIds
     */
    public void indexProgramJobByIds(List programIds) {
        if (!rmsSearchProvider) {
            return;
        }
        try {
            // SolrPingResponse pingResponse = new HttpSolrServer(server.baseURL+"/admin/ping").ping();
        } catch (SolrServerException e1) {
            log.error("资源搜索solr服务未连接");
            return;
        }

        List<Program> list = Program.findAllByIdInList(programIds, [sort: 'id', order: 'desc']);
        try {
            indexProgram(list);
        } catch (Exception e) {
            log.error("索引失败!", e);
        }
    }

    public Map<String, Object> docSearch(int offset, int max, String key) {
        def field = ["name", "description", "content"];
        def relation = ["OR", "OR"]; ;
        def keys = [key, key, key];
        int start = offset;
        int count = max;
        def sortfield = [];
        def flag = [];
        boolean hightlight = true;
        return searchSerial(field, keys, relation, start, count, sortfield, flag, hightlight);
    }

    public Map<String, Object> superSearch(int offset, int max, String key, String orderBy, String order, List<String> facetField, Map<String, Object> facetValue) {
        def field = [];
        def keys = [];
        def relation = [];
        if (key) {
            field = ["name", "description"];
            keys = [key, key];
            relation = ["OR"];
        }

        int start = offset;
        int count = max;
        def sortfield = [];
        def flag = [];
        if (orderBy) {
            sortfield.add(orderBy);
            if ("desc" == order) {
                flag.add(false);
            } else {
                flag.add(true);
            }
        }
        boolean hightlight = true;
        return searchProgram(field, keys, relation, facetField, facetValue, start, count, sortfield, flag, hightlight);
    }

    /**
     * 查询相关资源
     * @param offset
     * @param max
     * @param key
     * @param orderBy
     * @param order
     * @return
     */
    public Map<String, Object> searchRelationProgram(int offset, int max, String key, String orderBy, String order){
        def facetField = [];
        def facetValue = [:];
        def field = [];
        def keys = [];
        def relation = [];
        if (key) {
            field = ["name", "description"];
            keys = [key, key];
            relation = ["OR"];
        }

        int start = offset;
        int count = max;
        def sortfield = [];
        def flag = [];
        if (orderBy) {
            sortfield.add(orderBy);
            if ("desc" == order) {
                flag.add(false);
            } else {
                flag.add(true);
            }
        }
        boolean hightlight = true;
        return searchProgram(field, keys, relation, facetField, facetValue, start, count, sortfield, flag, hightlight);
    }
}

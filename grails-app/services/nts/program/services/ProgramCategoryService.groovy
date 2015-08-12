package nts.program.services

import com.boful.nts.utils.SystemConfig
import grails.transaction.Transactional
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.category.domain.ProgramCategory
import nts.utils.CTools
import nts.program.domain.*

@Transactional
class ProgramCategoryService {
    def utilService;

    public void initCategory() {
        int total = ProgramCategory.count();
        if (total == 0) {
            ProgramCategory programCategory = new ProgramCategory();
            programCategory.name = "资源库";
            programCategory.level = 0;
            programCategory.mediaType = 0;
            programCategory.allowDelete = false;
            programCategory.orderIndex = 0;
            programCategory.save(flush: true);
            List<Program> programList = Program.withCriteria {
                isEmpty('programCategories')
            };

            programCategory.programs.addAll(programList);
            programCategory.save(flush: true);

            String[] name = ["默认资源库", "视频资源库", "文档资源库", "图片资源库", "开放课程资源库", "音频资源库"];
            def orderIndex = 0;
            for (int i = 0; i < 5; i++) {
                ProgramCategory programCategory1 = new ProgramCategory();
                programCategory1.name = name[i];
                programCategory1.level = 1;
                programCategory1.orderIndex = orderIndex;
                orderIndex++;
                if (i == 0) {
                    programCategory1.isDisplay = ProgramCategory.STATE_INVISIBLE;
                    programCategory1.mediaType = 0;
                }
                if (i == 1) {
                    programCategory1.mediaType = 1;
                }
                if (i == 2) {
                    programCategory1.mediaType = 3;
                }
                if (i == 3) {
                    programCategory1.mediaType = 4;
                }
                if (i == 4) {
                    programCategory1.mediaType = 5;
                }
                if (i == 5) {
                    programCategory1.mediaType = 2;
                }
                programCategory1.allowDelete = false;
                programCategory1.parentCategory = programCategory;
                programCategory1.save(flush: true);
                List<Program> programList1 = Program.withCriteria {
                    isEmpty('programCategories')
                };


                programCategory1.programs.addAll(programList1);
                programCategory1.save(flush: true);

            }


        } else {
            ProgramCategory parentCategory = ProgramCategory.findByName("资源分类");
            if (parentCategory) {
                parentCategory.name = "资源库";
                parentCategory.save(flush: true);

                //修改分类名
                List<ProgramCategory> programCategoryList = ProgramCategory.findAllByParentCategory(parentCategory);
                if (programCategoryList && programCategoryList.size() > 0) {
                    programCategoryList.each { ProgramCategory category ->
                        def name = category.name;
                        if (name.contains("资源库")) {

                        } else if (name.contains("资源")) {
                            category.name = name + "库";
                        } else {
                            category.name = name + "资源库";
                        }
                        category.save(flush: true);
                    }
                }
            } else {
                parentCategory = ProgramCategory.findByName("资源库");
            }
            int count = ProgramCategory.countByParentCategory(parentCategory);

            ProgramCategory programCategory = ProgramCategory.findByNameAndParentCategory("音频资源库", parentCategory);
            if (!programCategory) {
                ProgramCategory programCategory1 = new ProgramCategory();
                programCategory1.name = "音频资源库";
                if (parentCategory) {
                    programCategory1.parentCategory = parentCategory;
                }
                programCategory1.mediaType = 2;
                programCategory1.allowDelete = false;
                if (count > 0) {
                    programCategory1.orderIndex = count;
                } else {
                    programCategory1.orderIndex = 0;
                }
                programCategory1.save(flush: true);
                List<Program> programList1 = Program.withCriteria {
                    isEmpty('programCategories')
                };


                programCategory1.programs.addAll(programList1);
                programCategory1.save(flush: true);
            }
            count = ProgramCategory.countByParentCategory(parentCategory);
            programCategory = ProgramCategory.findByNameAndParentCategory("开放课程资源库", parentCategory);
            if (!programCategory) {
                ProgramCategory programCategory1 = new ProgramCategory();
                programCategory1.name = "开放课程资源库";
                if (parentCategory) {
                    programCategory1.parentCategory = parentCategory;
                }
                programCategory1.mediaType = 5;
                programCategory1.allowDelete = false;
                if (count > 0) {
                    programCategory1.orderIndex = count;
                } else {
                    programCategory1.orderIndex = 0;
                }
                programCategory1.save(flush: true);
                List<Program> programList1 = Program.withCriteria {
                    isEmpty('programCategories')
                };


                programCategory1.programs.addAll(programList1);
                programCategory1.save(flush: true);
            }

            // 数据库初始化order_index字段
//            syncOrderIndex(parentCategory);  //如果数据库没有order_index字段,第一次运行时打开此代码;完成后还需要注掉此行
            //syncEnNameAndOrderIndex(ProgramCategory.findByName("资源库"));
        }
    }

    // 数据库初始化program_category表的order_index字段
    private void syncOrderIndex(ProgramCategory parentCategory) {
        List<ProgramCategory> programCategories = ProgramCategory.findAllByParentCategory(parentCategory);
        def index = 0;
        programCategories?.each { ProgramCategory category ->
            category.orderIndex = index;
            category.save(flush: true);
            syncOrderIndex(category);
            index++;
        }
    }

    // 数据库初始化category_facted表的en_name和order_index字段
    private void syncEnNameAndOrderIndex(ProgramCategory parentCategory) {
        List<ProgramCategory> programCategories = ProgramCategory.findAllByParentCategory(parentCategory);
        programCategories?.each { ProgramCategory category ->
            syncEnNameAndOrderIndex(category);
            def index = 1;
            def facteds = CategoryFacted.findAllByCategory(category)
            facteds?.each { CategoryFacted facted ->
                facted.orderIndex = index;
                facted.enName = "value" + index + "_facet";
                facted.save(flush: true);
                index++;
            }
        }
    }

    /**
     * 同步分类树
     */
    public void syncProgramCategory() {
        List<ProgramCategory> categoryList = ProgramCategory.list();
        Map<Long, List<ProgramCategory>> fastTreeMap = new HashMap<Long, List<ProgramCategory>>();
        categoryList.each { ProgramCategory category ->
            if (category.isDisplay == ProgramCategory.STATE_DISPLAY) {
                fastTreeMap.put(category.id, subCategoryId(category));
            }
        }
        utilService.getServletContext().setAttribute("categoryTree", fastTreeMap);

        createCategoryTreeJs();
    }

    /**
     * 同步子分类attribute
     * @param programCategory
     */
    public void syncSubProgramCategory(ProgramCategory programCategory) {
        String keyName = "category-${programCategory}";
        Object obj = utilService.getServletContext().getAttribute(keyName);
        List<ProgramCategory> subCategory = null;
        subCategory = queryAllByParentCategoryAndIsDisplay(programCategory, ProgramCategory.STATE_DISPLAY);
        utilService.getServletContext().setAttribute(keyName, subCategory);
        subCategory?.each {
            syncSubProgramCategory(it);
        }
    }

    /***
     * 查询分类下所有分类
     * @param programCategory
     * @return
     */
    public List<ProgramCategory> querySubAllCategory(ProgramCategory programCategory) {
        List<ProgramCategory> categoryList = new ArrayList<ProgramCategory>();
        if (utilService.getServletContext().getAttribute("categoryTree")) {
            Map<Long, List<ProgramCategory>> fastTreeMap = (Map<Long, List<ProgramCategory>>) utilService.getServletContext().getAttribute("categoryTree");
            categoryList = (List<ProgramCategory>) fastTreeMap.get(programCategory.id);
        }
        return categoryList;
    }

    /***
     * 查询分类下一级分类
     * @param programCategory
     * @return
     */
    public List<ProgramCategory> querySubCategory(ProgramCategory programCategory) {
        String keyName = "category-${programCategory}";
        Object obj = utilService.getServletContext().getAttribute(keyName);
        List<ProgramCategory> subCategory = null;
        if (obj) {
            subCategory = (List<ProgramCategory>) obj;
        } else {
            subCategory = queryAllByParentCategoryAndIsDisplay(programCategory, ProgramCategory.STATE_DISPLAY);
            //已按照orderIndex排序
            //排序
            //Collections.sort(subCategory);
            utilService.getServletContext().setAttribute(keyName, subCategory);
        }
        return subCategory;
    }

    /***
     * 查询顶级资源分类
     * @return
     */
    public ProgramCategory querySuperCategory() {
        Object obj = utilService.getServletContext().getAttribute("superCategory");
        ProgramCategory superCategory = null;
        if (obj) {
            superCategory = (ProgramCategory) obj;
        } else {
            superCategory = ProgramCategory.findByParentCategoryAndLevel(null, 0);
            utilService.getServletContext().setAttribute("superCategory", superCategory);
        }
        return superCategory;
    }

    /***
     * 查询课程顶级分类
     * @return 课程顶级分类
     */
    public ProgramCategory queryCourseCategory() {
        return queryCategory("courseSuperCategory", 5);
    }

    /***
     * 查询视频顶级分类
     * @return
     */
    public ProgramCategory queryVideoCategory() {
        return queryCategory("videoSuperCategory", 1);
    }

    /***
     * 查询动画顶级分类
     * @return
     */
    public ProgramCategory queryFlashCategory() {
        return queryCategory("flashSuperCategory", 6);
    }

    /***
     * 查询音频顶级分类
     * @return
     */
    public ProgramCategory queryAudioCategory() {
        return queryCategory("audioSuperCategory", 2);
    }

    /***
     * 查询图片顶级分类
     * @return
     */
    public ProgramCategory queryImageCategory() {
        return queryCategory("imageSuperCategory", 4);
    }

    /***
     * 查询文档顶级分类
     * @return
     */
    public ProgramCategory queryDocCategory() {
        return queryCategory("docSuperCategory", 3);
    }


    private ProgramCategory queryCategory(String categoryKeyName, int mediaType) {
        Object obj = utilService.getServletContext().getAttribute(categoryKeyName);
        ProgramCategory category = null;
        if (obj) {
            category = (ProgramCategory) obj;
        } else {
            category = ProgramCategory.findByParentCategoryAndMediaTypeAndIsDisplay(querySuperCategory(), mediaType, ProgramCategory.STATE_DISPLAY);
            utilService.getServletContext().setAttribute(categoryKeyName, category);
        }
        return category;
    }

    private static List<ProgramCategory> subCategoryId(ProgramCategory programCategory) {
        List<ProgramCategory> categoryList = new ArrayList<ProgramCategory>();
        List<ProgramCategory> subCategoryList = queryAllByParentCategoryAndIsDisplay(programCategory, ProgramCategory.STATE_DISPLAY);
        categoryList.addAll(subCategoryList);
        subCategoryList.each { ProgramCategory programCategory1 ->
            categoryList.addAll(subCategoryId(programCategory1));
        }
        return categoryList;
    }

    //program分类修改
    public Map changeProgramCategory(Map params) {
        def result = [:];
        String programIds = params.programIds;
        String programCategoryId = params.programCategoryId;
        if (!programIds || !programCategoryId) {
            result.msg = "参数不全";
            return result;
        }
        ProgramCategory programCategory = ProgramCategory.findById(Long.parseLong(programCategoryId));
        if (!programCategory) {
            result.msg = "分类未找到";
            return result;
        }
        ProgramCategory parentCategory = ProgramCategory.findByParentCategory(programCategory);
        if (parentCategory) {
            result.msg = "该分类存在父分类";
            return result;
        }
        String[] pIds = programIds.split(",");
        Program program;
        for (String programId : pIds) {
            program = Program.findById(Long.parseLong(programId));
            if (program) {
                //这里不能把program存入programCategory然后保存，会出现bug，所以只能这样保存
                program.programCategories.clear();
                program.addToProgramCategories(programCategory);
                program.save(flush: true);
            }
        }
        result.msg = "保存成功!!";
        return result;

    }

    private void changeSubCategoryLevel(ProgramCategory category) {
        def categories = ProgramCategory.findAllByParentCategory(category);
        categories.each { ProgramCategory programCategory ->
            programCategory.level = category.level + 1;
            programCategory.save(flush: true);
            changeSubCategoryLevel(programCategory);
        }
    }

    /**
     * 取得音频资源名
     * @return 音频资源名
     */
    public String queryAudioCategoryName() {
        return queryAudioCategory().name;
    }

    /**
     * 取得文档资源名
     * @return 文档资源名
     */
    public String queryDocCategoryName() {
        return queryDocCategory().name;
    }

    /**
     * 取得图片资源名
     * @return 图片资源名
     */
    public String queryPhotoCategoryName() {
        return queryImageCategory().name;
    }

    /**
     * 取得视频资源名
     * @return 视频资源名
     */
    public String queryVideoCategoryName() {
        return queryVideoCategory().name;
    }

    public String queryCourseCategoryName() {
        return queryCourseCategory()?.name;
    }

    /**
     * 取得该分类下的显示子分类并按照orderIndex排序
     * @param parentCategory
     * @param isDisplay
     * @return
     */
    private
    static List<ProgramCategory> queryAllByParentCategoryAndIsDisplay(ProgramCategory parentCategory, int isDisplay) {
        List<ProgramCategory> categoryList = ProgramCategory.createCriteria().list {
            eq('parentCategory', parentCategory)
            eq('isDisplay', isDisplay)
            order('orderIndex', 'asc')
        }
        return categoryList;
    }

    /***
     * 创建分类js
     */
    public void createCategoryTreeJs() {
        File webRoot = SystemConfig.webRootDir;

        //寻找js文件
        File jsFile = new File(webRoot, "js/boful/index/programCategoryTree.js");
        if (jsFile.exists()) {
            jsFile.delete();
        }
        jsFile.createNewFile();

        StringBuffer sb = new StringBuffer();
        sb.append("var programCategoryTree=[");
        ProgramCategory superCategory = querySuperCategory();
        List<ProgramCategory> secondCategoryList = querySubCategory(superCategory);
        //排序
        secondCategoryList?.sort { category1, category2 ->
            category1.orderIndex <=> category2.orderIndex
        }
        sb.append(buildProgramCategory(secondCategoryList, 2));
        sb.append("];")
        jsFile.append(sb.toString(), "UTF-8");
    }

    /***
     * 从二级分类开始缓存
     * @param secondCategoryList 分类列表
     * @param level 分类级别
     * @return 组装后的字符串
     */
    private StringBuffer buildProgramCategory(List<ProgramCategory> secondCategoryList, int level) {
        StringBuffer sb = new StringBuffer();
        for (ProgramCategory secondCategory : secondCategoryList) {
            if ("默认资源库".equals(secondCategory.name) || secondCategory.mediaType == 0) {
                continue;
            }

            StringBuffer facteds = new StringBuffer();
            List<CategoryFacted> categoryFacteds = CategoryFacted.findAllByCategory(secondCategory);
            categoryFacteds.eachWithIndex{categoryFacted, index->
                // values
                StringBuffer facetValues = new StringBuffer();
                List<FactedValue> values = categoryFacted.values.toList();
                values.eachWithIndex{ facetedValue, i ->
                    facetValues.append("{\"id\":${facetedValue.id},\"content\":\"${facetedValue.contentValue.encodeAsJavaScript()}\"}");
                    if(i !=(facetValues.size()-1)){
                        facetValues.append(",");
                    }
                }
                facteds.append("{\"id\":${categoryFacted.id},\"name\":\"${categoryFacted.name.encodeAsJavaScript()}\",\"enName\":\"${categoryFacted.enName.encodeAsJavaScript()}\",\"values\":[${facetValues.toString()}]}");
                if(index!=(categoryFacteds.size()-1)){
                    facteds.append(",");
                }
            }

            //TODO icon暂时没有
            sb.append("{\"id\":${secondCategory.id},\"level\":${level + 1},\"name\":\"${secondCategory.name.encodeAsJavaScript()}\",\"mediaType\":\"${secondCategory.mediaType}\",\"description\":\"${secondCategory.description ? (secondCategory.description + "").encodeAsJavaScript() : ""}\",\"icon\":\"\",\"faceted\":[${facteds.toString()}],childCategoryList:[");
            List<ProgramCategory> thirdCategoryList = querySubCategory(secondCategory);
            //排序
            thirdCategoryList?.sort { category1, category2 ->
                category1.orderIndex <=> category2.orderIndex
            }
            sb.append(buildProgramCategory(thirdCategoryList, (level + 1)));
            sb.append("]}");
            if (secondCategoryList.indexOf(secondCategory) != (secondCategoryList.size() - 1)) {
                sb.append(",");
            }
        }
        return sb;
    }

    /**
     * 查询分类下所有子分类集合,供后台查询资源用
     * @param programCategory
     * @return
     */
    public List<ProgramCategory> querySubAllCategoryForAdmin(ProgramCategory programCategory) {
        List<ProgramCategory> categoryList = new ArrayList<ProgramCategory>();
        List<ProgramCategory> subCategoryList = ProgramCategory.findAllByParentCategory(programCategory);
        categoryList.addAll(subCategoryList);
        subCategoryList.each { ProgramCategory programCategory1 ->
            categoryList.addAll(querySubAllCategoryForAdmin(programCategory1));
        }
        return categoryList;
    }

    /**
     * 查询分类下一级子分类集合,供后台查询资源用
     * @param programCategory
     * @return
     */
    public List<ProgramCategory> querySubCategoryForAdmin(ProgramCategory programCategory) {
        List<ProgramCategory> categoryList = ProgramCategory.findAllByParentCategory(programCategory);
        return categoryList;
    }

    /**
     * 根据分类查询该分类的顶级父分类
     * @param programCategory
     * @return
     */
    public ProgramCategory querySuperCategoryByCategory(ProgramCategory programCategory) {
        ProgramCategory superCategory = ProgramCategory.findByParentCategoryAndLevel(null, 0);
        ProgramCategory targetCategory = null;
        if (programCategory) {
            if (programCategory?.parentCategory && programCategory?.parentCategory.id == superCategory.id) {
                targetCategory = ProgramCategory.get(programCategory.id);
            } else {
                targetCategory = querySuperCategoryByCategory(programCategory.parentCategory);
            }
        }
        return targetCategory;
    }
}

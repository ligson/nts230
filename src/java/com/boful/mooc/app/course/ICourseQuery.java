package com.boful.mooc.app.course;

import java.util.HashMap;

/**
 * Created by lvy6 on 14-8-25.
 */
public interface ICourseQuery {
    public HashMap<String,String> queryCourseListByCondition(String categoryId, int offset, int max, String sort, String order);
    public HashMap<String,String> queryFatherCategoryList();
    public HashMap<String,String> queryCategoryById(String id);
}

package com.boful.nts;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;

public class BofulClassUtils {

    public static void cloneObject(Object src, Object dest, String[] ignored) {
        Class<?> class1 = src.getClass();
        Class<?> class2 = dest.getClass();
        Field[] fields1 = class1.getDeclaredFields();
        Field[] fields2 = class2.getDeclaredFields();
        Method[] methods1 = class1.getDeclaredMethods();
        Method[] methods2 = class2.getDeclaredMethods();

        for (Field field : fields1) {

            String fieldName1 = field.getName();
            if (ignored != null && ignored.length > 0) {
                if (Arrays.binarySearch(ignored, fieldName1) < 0) {
                    continue;
                }
            }


            boolean isContain = false;
            for (Field field2 : fields2) {
                if (field2.getName().equals(fieldName1)) {
                    isContain = true;
                    break;
                }
            }

            if (isContain) {
                isContain = false;
                String setMethodName = "set"
                        + fieldName1.substring(0, 1).toUpperCase()
                        + fieldName1.substring(1);
                String getMethod = "get";
                if((field.getType()==Boolean.class)||(field.getType()==boolean.class)){
                    getMethod = "is";
                }
                String getMethodName = getMethod + fieldName1.substring(0, 1).toUpperCase()
                        + fieldName1.substring(1);

                for (Method method : methods2) {

                    if (method.getName().equals(setMethodName)) {
                        if (method.getReturnType() == void.class) {
                            if (method.getModifiers() == Modifier.PUBLIC) {
                                Class<?>[] paramTypes = method
                                        .getParameterTypes();
                                if ((paramTypes.length == 1)
                                        && (paramTypes[0] == field.getType())) {
                                    try {
                                        Method getMehod = class1.getMethod(getMethodName);
                                        Object value = getMehod.invoke(src);
                                        Method method2 = class2
                                                .getMethod(setMethodName,
                                                        field.getType());
                                        method2.invoke(dest, value);
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public static void cloneObject(Object src, Object dest) {
        cloneObject(src, dest, null);
    }
}

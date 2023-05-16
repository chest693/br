package kr.or.chest.br.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;

/**
 * @author IT0557
 *
 */
public class ConvertUtil {


    /**
     * camelcase를 "_" 형으로 return
     * testValue -> TEST_VALUE
     * @param str
     * @return String
     */
    public static String camelToDbStyle(String str)	{
        String regex = "([a-z])([A-Z])";
        String replacement = "$1_$2";
        String value = "";
        value = str.replaceAll(regex, replacement).toUpperCase();

        return value;
    }


    /**
     * 리스트를 MAP으로 변환함.
     * KEY BY VALUE로 사용할 경우.
     * @param list
     * @return
     */
    public static CamelCaseMap convertCodeMap(List<CamelCaseMap> list){
        CamelCaseMap resultMap = null;
        try {
            resultMap = new CamelCaseMap();

            for(CamelCaseMap map : list){
                resultMap.put(map.get("code").toString(), map.get("name"));
            }

        }catch (Exception e){
            e.printStackTrace();
        }
        return resultMap;
    }

    /**
     * 리스트를 MAP으로 변환함.
     * KEY BY VALUE로 사용할 경우.
     * @param list
     * @return
     */
    public static CamelCaseMap convertCodeMap(List<CamelCaseMap> list, String key){
        CamelCaseMap resultMap = null;
        try {
            resultMap = new CamelCaseMap();

            for(CamelCaseMap map : list){
                resultMap.put(map.get(key).toString(), map);
            }

        }catch (Exception e){
            e.printStackTrace();
        }
        return resultMap;
    }

    /**
     * LONG 타입 날짜를 변환한다.
     * @param date
     * @return
     */
    public static String convertDate(String format, long date) {
        String strDate = null;
        try {
            SimpleDateFormat dateFormatter = new SimpleDateFormat (format);
            strDate = dateFormatter.format(date).toString();
        } catch (Exception e) {

        }
        return strDate;
    }

    /**
     * LONG 타입 날짜를 변환한다.
     * @param date
     * @return
     */
    public static String convertDate(long date){
        return convertDate("yyyyMMddHHmmss", date);
    }

    /**
     * SAP dats type을 yyyy-MM-dd 형태로 변환한다.
     * @param bfDate
     * @return
     */
    public static String convertSapDayToString(String bfDate) {
        String regExp = "(\\d{4})(\\d{2})(\\d{2})(\\d{2})(\\d{2})(\\d{2})";
        return bfDate.replaceAll(regExp, "$1-$2-$3");
    }
    /**
     * SAP date type String을 Date로 변환한다.
     * @param bfDate
     * @return
     */
    public static Date convertSapDatToDate(String format, String bfDate) {
        Date date;
        try {
            if(StringUtils.isEmpty(format)){
                format = "yyyyMMddHHmmss";
            }
            DateFormat dateFormat = new SimpleDateFormat(format, Locale.ENGLISH);
            String beforeDate = bfDate;
            date = dateFormat.parse(beforeDate);
            return  date;
        } catch (ParseException e) {
            e.printStackTrace();
            return  null;
        }
    }


    /**
     * SAP date type String을 Date로 변환한다.
     * @param bfDate
     * @return
     */
    public static Date convertSapDatToDate(String bfDate) {
        return convertSapDatToDate("EEE MMM dd HH:mm:ss z yyyy", bfDate);
    }

    /**
     * MAP TO CLASS
     * @param map
     * @param clazz
     * @return
     */
    public static Object bindMapToClass(Map map, Object obj, String keyField, String prefix){
        Map model = null;
        String key;
        String fieldName;
        try {
            //키가되는 필드 값이 없을 경우 null을 반환함.
            if(BeanUtils.getProperty(obj, keyField)==null)
                return null;

            model = (Map)map.get(BeanUtils.getProperty(obj, keyField));

            if(model==null){
                return null;
            }

            Iterator<String> keys = model.keySet().iterator();

            while(keys.hasNext()){
                key = keys.next();

                if(keyField.equals(key)){
                    continue;
                }

                if(StringUtils.isEmpty(prefix)){
                    fieldName = key;
                } else {
                    fieldName = prefix+key.substring(0, 1).toUpperCase()+key.substring(1);
                }

                try {
                    if(null!=obj.getClass().getDeclaredField(fieldName)){
                        BeanUtils.setProperty(obj, fieldName , model.get(key));
                    }
                } catch (NoSuchFieldException ex ){
                    //해당필드가 검색되지 않을경우 셋팅하지 않고 넘어간다.
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(ex.getMessage());
        }
        return obj;
    }

    /**
     * 숫자로 변형이 가능한지 아닌지를 판별한다.
     * @param number
     * @return
     */
    public static boolean isNumber(String number) {
        boolean flag = true;

        if (number == null || "".equals(number)) {
            return false;
        }

        int size = number.length();
        int st_no = 0;

        if (number.charAt(0) == 45) {// 음수인지 아닌지 판별 . 음수면 시작위치를 1부터
            st_no = 1;
        }

        for (int i = st_no; i < size; ++i) {
            if (!(48 <= (number.charAt(i)) && 57 >= (number.charAt(i)))) {
                flag = false;
                break;
            }
        }

        return flag;
    }

    /**
     * 숫자type로 변형이 가능한 문자열일 경우 숫자로 변환하여 String으로 반환한다.
     * @param str
     * @return
     */
    public static String convertStringToNumberString(String str) {
        String retStr = "";
        try {
            if (isNumber(str)) {
                // 숫자로 변형이 가능(000010000)일 경우 (10000)으로 반환.
                retStr = Long.toString(Long.parseLong(str));
            } else {
                retStr = str;
            }
        } catch (Exception e) {
            retStr = str;
        }

        return retStr;
    }


    /**
     * 숫자를 제외한 모든 문자 공백으로 변경
     *
     * @param value
     * @return
     */
    public static String replaceNotNumber(String value) {

        // 숫자를 제외한 모든 문자선택 정규식
        final String regex = "\\D";

        // null & 공백
        if (StringUtils.isEmpty(value)) {
            return value;
        }

        return value.replaceAll(regex, "");
    }
    
    public static byte[] getBytesFromFile(File file) throws IOException {
        InputStream is = new FileInputStream(file);

       long length = file.length();

       // You cannot create an array using a long type.
        // It needs to be an int type.
        // Before converting to an int type, check
        // to ensure that file is not larger than Integer.MAX_VALUE.
        if (length > Integer.MAX_VALUE) {
            // File is too large
        }

       // Create the byte array to hold the data
        byte[] bytes = new byte[(int)length];

       // Read in the bytes
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
            offset += numRead;
        }

       // Ensure all the bytes have been read in
        if (offset < bytes.length) {
            throw new IOException("Could not completely read file "+file.getName());
        }

       // Close the input stream and return bytes
        is.close();
        return bytes;
    }

    public static String getToDay(){
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddhhmmss");
		java.util.Date date = calendar.getTime();

		String yyyyMMdd = new SimpleDateFormat("yyyyMMdd").format(date);
        return yyyyMMdd;
    }

    
    public static String getFirstDay(){
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddhhmmss");
		java.util.Date date = calendar.getTime();

		String yyyyMM = new SimpleDateFormat("yyyyMM").format(date);
		int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
        int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
        int day = Integer.parseInt(new SimpleDateFormat("dd").format(date));
 
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
 
        cal.set(year, month-1, day); //월은 -1해줘야 해당월로 인식
        String firstDay = Integer.toString(cal.getMinimum(Calendar.DAY_OF_MONTH)); 
        if(firstDay.length()==1) firstDay = "0" + firstDay;
        
        return yyyyMM+firstDay;
    }

    public static String getLastDay(){
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddhhmmss");
		java.util.Date date = calendar.getTime();

		String yyyyMM = new SimpleDateFormat("yyyyMM").format(date);
		int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
        int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
        int day = Integer.parseInt(new SimpleDateFormat("dd").format(date));
 
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
 
        cal.set(year, month-1, day); //월은 -1해줘야 해당월로 인식

        return yyyyMM+Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
    }
    

    /**
     * Null일경우 ''을 반환한다.
     * @param str
     * @return
     */
    public static String convertNull(Object obj) {
    	if(obj==null)  obj="";

    	return obj.toString(); 
    }
    
    
    /*
     * 날짜계산
     * String getPreDay("20200320", "-5") = "20200315"
     * String getPreDay("20200320", "+5") = "20200325"
     * 
     */
    public static String getPreDay(Object _yyyymmdd, Object _cnt) {
    	Date date = null;
    	String preDd = null;
        String yyyymmdd = (String)_yyyymmdd;
        int cnt = Integer.parseInt((String)_cnt);
        
        
    	Calendar calendar = Calendar.getInstance();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd", Locale.KOREA);
        try {
            date =  dateFormat.parse(yyyymmdd);
        }catch(ParseException pe) {
            System.out.println(pe.getMessage());
            return "";
        }

        calendar.setTime(date); 

        calendar.add(Calendar.DATE, cnt);
        preDd =  dateFormat.format(calendar.getTime());	  	
    	
    	return preDd;
    }  
    

}

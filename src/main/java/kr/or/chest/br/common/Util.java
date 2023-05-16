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
import org.apache.commons.lang.StringUtils;
import java.text.DecimalFormat;
/**
 * @author IT0557
 *
 */
public class Util {

	
	/*파일사이즈 표시*/
    public static String byteCalculation(String bytes) {
        String retFormat = "0";
       Double size = Double.parseDouble(bytes);

        String[] s = { "bytes", "KB", "MB", "GB", "TB", "PB" };
        

        if (bytes != "0") {
              int idx = (int) Math.floor(Math.log(size) / Math.log(1024));
              DecimalFormat df = new DecimalFormat("#,###.##");
              double ret = ((size / Math.pow(1024, Math.floor(idx))));
              retFormat = df.format(ret) + " " + s[idx];
         } else {
              retFormat += " " + s[0];
         }

         return retFormat;
    }     
	
  	public static boolean isAllowExtension( String fileName ,String allowFileExts){   
  		
  		boolean result = false;         

  		result = getFileInfo(fileName, allowFileExts);
        if( result ) /*test*/System.out.println("'" + fileName + "' 파일은 업로드가 금지된 파일");

        return result;     
  	}

 	private static boolean getFileInfo(String fullFileName, String allowFileExts){
		
		int length = 0, pos = 0;
		String fileName = null, fileExtention = null; 
		boolean contain = false, isAllowFile = false;
		
		//(1)allowFileExts문자열에서  앞/뒤 공백제거, 소문자변환, 문자열내 공백을 제거함 
		allowFileExts = allowFileExts.trim().toLowerCase().replaceAll(" ","");
		
		//(2)업로드대상 파일에서 '파일명'과 '확장자' 추출 
		length = fullFileName.length();
		pos = StringUtils.indexOf(fullFileName, ".");
		fileName = StringUtils.substring(fullFileName, 0, pos);
		fileExtention = StringUtils.substring(fullFileName, pos + 1, length).toLowerCase();

		//(3)업로드된 파일 확장자의 금지 목록 포함여부를 반환 
		contain = StringUtils.contains(allowFileExts, fileExtention);
		if(contain){
			isAllowFile = false;
		}else{
			isAllowFile = true;
		}
		
		return isAllowFile;
	}
	
	
    public static String htmlEncode(String s/*, boolean encodeSpecialChars*/) {
        s = noNull(s, "");

        StringBuilder str = new StringBuilder();

        for (int j = 0; j < s.length(); j++) {
            char c = s.charAt(j);

            // encode standard ASCII characters into HTML entities where needed
            if (c < '\200') {
                switch (c) {
                case '"':
                    str.append("&quot;");
                    break;
                case '&':
                    str.append("&amp;");
                    break;
                case '<':
                    str.append("&lt;");
                    break;
                case '>':
                    str.append("&gt;");
                    break;
                case '(':
                    str.append("&#40;");
                    break;
                case ')':
                    str.append("&#41;");
                    break;
                case '#':
                    str.append("&#35;");
                    break;
                case '\'':
                    str.append("&#39;");
                    break;
                default:
                    str.append(c);
                }
            }
            /*
            // encode 'ugly' characters (ie Word "curvy" quotes etc)
            else if (encodeSpecialChars && (c < '\377')) {
                String hexChars = "0123456789ABCDEF";
                int a = c % 16;
                int b = (c - a) / 16;
                str.append("&#x").append(hexChars.charAt(b)).append(hexChars.charAt(a)).append(';');
            }
            //add other characters back in - to handle charactersets
            //other than ascii
             */
            else {
                str.append(c);
            }
        }

        return str.toString();
    }    
    
    private static String noNull(String string, String defaultString) {
        return (stringSet(string)) ? string : defaultString;
    }    
    
    private static boolean stringSet(String string) {
        return (string != null) && !"".equals(string);
    }    

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

	public static String getToday(String format) {
		SimpleDateFormat formatter = new SimpleDateFormat(format, java.util.Locale.KOREA);
	    Calendar cal = Calendar.getInstance();
		String resultDate = formatter.format(cal.getTime());

		return resultDate;
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

    /**
     * upload path에서 파일명만 분리
     * @param fileName
     * @return
     */
    public static String getFileNameFromPath(String fileName) {
        return fileName.substring(fileName.lastIndexOf('\\') + 1, fileName.length());
    }    
    
}

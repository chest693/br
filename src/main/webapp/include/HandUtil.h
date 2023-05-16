<%!

/* ========================================================================== */
/*  00. Null Check                                                            */
/* ========================================================================== */
public static boolean isNull(String s)
  {
      if ( s == null ) {
          return true;
      } else if ( s.trim().toLowerCase().equals("null") ){
          return true;
      } else if ( s.trim().equals("") ){
          return true;
      } else {
          return false;
      }
  }

/* ========================================================================== */
/*  01. getDateTime                                                           */
/* ========================================================================== */
public static String getDateTime() {
    String currentDateTime = null;
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMddHHmmss", java.util.Locale.KOREA);
    currentDateTime =  dateFormat.format(new java.util.Date());

    return currentDateTime;
}

/* ========================================================================== */
/*  01-1. getDateTime(Format)                                                 */
/* ========================================================================== */
public static String getDateTime( String format) {
    String currentDateTime = null;
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat(format, java.util.Locale.KOREA);
    currentDateTime =  dateFormat.format(new java.util.Date());

    return currentDateTime;
}

/* ========================================================================== */
/*  01-2. getDate                                                             */
/* ========================================================================== */
public static String getDate() {
    String currentDateTime = null;
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
    currentDateTime =  dateFormat.format(new java.util.Date());

    return currentDateTime;
}

/* ========================================================================== */
/*  01-2. getAddMonth                                                             */
/* ========================================================================== */
public static String getAddMonth( String yyyymmdd, int v ) {
    String addDateTime = null;
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);


    int YY = Integer.parseInt(yyyymmdd.substring(0,4));
    int MM = Integer.parseInt(yyyymmdd.substring(4,6))-1;
    int DD = Integer.parseInt(yyyymmdd.substring(6,8));

    java.util.Calendar cal = java.util.Calendar.getInstance();
    cal.set( YY, MM, DD);
    cal.add( Calendar.MONTH, v);

    java.util.Date date = cal.getTime();


    addDateTime = dateFormat.format(date);

    return addDateTime;
}


/* ========================================================================== */
/*  01-2. getLastDay(fomat)    해당날짜의 마지막일 확인                       */
/* ========================================================================== */
public static String getLastDay(String dateStr) {
    String currentDateTime = "";
    char c; // 문자를 담을 레퍼런스 생성

    for ( int i =0;  i< dateStr.length(); i++ ){ // 반복 문구

        c = dateStr.charAt(i);
        if ( c >= '0' && c <= '9'){
            currentDateTime += c;
        }
    }

    java.util.Calendar dday = java.util.Calendar.getInstance();

    int YY = Integer.parseInt(currentDateTime.substring(0,4));
    int MM = Integer.parseInt(currentDateTime.substring(5,6))-1;

    dday.set(dday.YEAR, YY);
    dday.set(dday.MONTH, MM);
    dday.set(dday.DAY_OF_MONTH, 1);

    currentDateTime = dday.getActualMaximum(dday.DAY_OF_MONTH)+"";
    return currentDateTime;
}
/* ========================================================================== */
/*  01-1. getNextWeek(Format)   차주 1주일   2010-12-15 김준희                                           */
/* ========================================================================== */
    public static String[] getNextWeek() {
        String[] date = new String[2];

    	Calendar rightNow = Calendar.getInstance();
    	//요일, 일1 월2 화3 수4 목5 금6 토7
    	int nowWeek = rightNow.get(rightNow.DAY_OF_WEEK);
    	
    	if (nowWeek==1) rightNow.add(rightNow.DATE, 1); 
    	if (nowWeek==2) rightNow.add(rightNow.DATE, 7); 
    	if (nowWeek==3) rightNow.add(rightNow.DATE, 6); 
    	if (nowWeek==4) rightNow.add(rightNow.DATE, 5); 
    	if (nowWeek==5) rightNow.add(rightNow.DATE, 4); 
    	if (nowWeek==6) rightNow.add(rightNow.DATE, 3); 
    	if (nowWeek==7) rightNow.add(rightNow.DATE, 2); 
    	
    	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.KOREA);
    	
    	date[0] = dateFormat.format(rightNow.getTime());
    	rightNow.add(rightNow.DATE, 6);
    	date[1] = dateFormat.format(rightNow.getTime());
    	
    	return date;
    }

/* ========================================================================== */
/*  02. Null to Balnk                                                         */
/* ========================================================================== */
public static String N2B(String s)
{
  if ( s == null ) {
      return "";
  } else {
    return s;
  }
}

/* ========================================================================== */
/*  03. 서버Path                                                              */
/* ========================================================================== */
public String getServerConfigPath(ServletContext application,HttpServletRequest request)
{
 String tmpRDHome = application.getRealPath(request.getServletPath()); //C:\Tomcat6\webapps\ROOT\include\Global.jsp
 String tmpRDHomeDir = "";

//tmpRDHomeDir = new File(new File(tmpRDHome).getParent()).getParent();
//tmpRDHomeDir = tmpRDHomeDir.replace('\\','/');

 return tmpRDHome;
}

/* ========================================================================== */
/*  04. 글자수 제한 (over시 [...] 처리)                                       */
/* ========================================================================== */
  public static String limitString(String str, int limit) {
      if (str == null || limit < 4) return str;

      int len = str.length();
      int cnt=0, index=0;

      while (index < len && cnt < limit) {

         if (str.charAt(index++) < 256)
            cnt++;
         else {
               cnt += 2;
         }
      }

      if (index < len && limit >= cnt )
         str = str.substring(0, index) + "..";
      else if(index < len && limit < cnt )
         str = str.substring(0, index-1) + "..";

       return str;
   }


/* ========================================================================== */
/*  05. 금액표시 (3자리마다 콤마표시)                                         */
/* ========================================================================== */
 public static String insertComma(String input)
  {
    java.text.DecimalFormat dfWon  = new java.text.DecimalFormat("###,##0");
    String returnString = "";

    if (input == null) return null;

    double d = 0;

    try {
            d = Double.valueOf(input).doubleValue();
        } catch (Exception e) {
            d = 0;
        }

        returnString = dfWon.format(d);

      return returnString;
  }

/* ========================================================================== */
/*  06. PGM_ID로 권한체크 - 세션USER_MENU에 PGM_ID가 없으면 권한없음          */
/* ========================================================================== */
 public static boolean checkAuth(ArrayList USER_MENU, String PGM_ID)
  {
    boolean AUTH_YN = false; // PGM_ID가 나오면 권한있음
    if ( USER_MENU == null ) {
        return AUTH_YN;
    }

    for (int i=0; i < USER_MENU.size(); i++ ) {
        HashMap hmap = (HashMap) USER_MENU.get(i);
        String menu_id = (String)hmap.get("menu_id");
        //System.out.println( "menu_id : " + menu_id );

        //권한체크
        if ( PGM_ID.equals(menu_id) ) {
            AUTH_YN = true;
        }
    }  
    return AUTH_YN;
  }



/* ========================================================================== */
/*  07. Message Util                                                          */
/* ========================================================================== */
/*
// Spring Message Util #1
public static String[] configLocations = {"messageContext.xml"};
public static org.springframework.context.ApplicationContext context = new org.springframework.context.support.ClassPathXmlApplicationContext(configLocations);
public static java.util.Locale locale = java.util.Locale.getDefault();
//public static java.util.Locale locale = Locale.ENGLISH; // Locale.KOREAN - 언어고정필요시 세팅


//public static String[] configLocations = {"messageContext.xml"};
//public static org.springframework.context.ApplicationContext context = new org.springframework.context.support.AbstractApplicationContext();
//public static org.springframework.context.support.ReloadableResourceBundleMessageSource context = new org.springframework.context.support.ReloadableResourceBundleMessageSource();
//public static java.util.Locale locale = java.util.Locale.getDefault();

public static String getMessage(String _msgId) {
    return context.getMessage(_msgId, new Object[0], locale);  
}

public static String getMessage(String _msgId, String _loc) {
    java.util.Locale locale = java.util.Locale.getDefault();
    if ( "kr".equals(_loc.toLowerCase()) ) {
        locale = Locale.KOREAN;
    } else if ( "en".equals(_loc.toLowerCase()) ) {
        locale = Locale.ENGLISH;
    }
    return context.getMessage(_msgId, new Object[0], locale);  
}
*/


/* ========================================================================== */
/*  08. Select콤보 자동생성                                                   */
/* ========================================================================== */
public String makeCombo( ArrayList _alist, String _codeCol, String _nameCol, String _selCode) throws Exception {
    StringBuffer buf = new StringBuffer();
    
    try {
        for ( int i=0; i < _alist.size(); i++ ) {
            String[]  strData = new String[2];
            HashMap hmap = (HashMap) _alist.get(i);
            strData[ 0] = (String)hmap.get(_codeCol);
            strData[ 1] = (String)hmap.get(_nameCol);
            buf.append("            <option value="+strData[0]);
            if(_selCode.equals(strData[0])) {
                buf.append(" selected");
            }
            buf.append(">"+strData[1]+"</option>\n");
        }

    } catch (Exception e) {
        System.out.println ("[E] : " + e.toString());
    } finally {
    }
    
    return buf.toString();
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


%>
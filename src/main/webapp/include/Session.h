<%------------------------------------------------------------------------
JSP Session
--------------------------------------------------------------------------%>
<% 
HttpSession httpSession = request.getSession(true); 

String URI = request.getRequestURI();
String SPH = request.getServletPath();
System.out.println("getRequestURI  [" + URI +"]" );
System.out.println("getServletPath [" + SPH +"]" );

// Session Info
String USER_ID      = (String) httpSession.getAttribute("DPSTN_ID");
String USER_NM    = (String) httpSession.getAttribute("SPTDPSTN_NM");
String DPSTN_ID      = (String) httpSession.getAttribute("DPSTN_ID");
String SPTDPSTN_CD = (String) httpSession.getAttribute("SPTDPSTN_CD");
String SPTDPSTN_NM = (String) httpSession.getAttribute("SPTDPSTN_NM");

String BHF_CODE = (String) httpSession.getAttribute("BHF_CODE");
String BHF_NM = (String) httpSession.getAttribute("BHF_NM");
String BHF_TELNO = (String) httpSession.getAttribute("BHF_TELNO");
String USER_SE_CODE = (String) httpSession.getAttribute("USER_SE_CODE");


// TOP MENU
ArrayList TOP_MENU  = (ArrayList) httpSession.getAttribute("TOP_MENU");

%>

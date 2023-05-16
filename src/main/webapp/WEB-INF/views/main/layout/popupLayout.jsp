<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ include file="/include/taglib.h"%>

<!DOCTYPE html>
<html lang="ko">
<link rel="stylesheet" type="text/css" href="/css/chest.css" />
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
  <head>
    <meta charset="UTF-8">
    <title>사랑의열매</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link rel="icon" href="images/favicon.ico" />
    
  </head>
   <body>
    <section class="content">
      <tiles:insertAttribute name="body"/> <!-- body -->
    </section>
  </body>
</html>
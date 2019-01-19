<!doctype html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
 <meta name="viewport" content="width=device-width, initial-scale=1">
<%-- <script type="text/javascript" src='<c:url value="/scripts/jquery-1.12.4.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/scripts/bootstrap.min.js"/>'></script>
<link rel="stylesheet" href="/css/bootstrap.min.css"> --%>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script>
  
  
</head>
<body>

<div class="container">
    <header>
        <jsp:include page="header.jsp"/>
    </header>
    <jsp:include page="../${pageView}.jsp"/>
    <footer>
        <jsp:include page="footer.jsp"/>
    </footer>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<c:choose>
			<c:when test="${product['new']}">
				<h1>Add User</h1>
			</c:when>
			<c:otherwise>
				<h1>Update User</h1>
			</c:otherwise>
		</c:choose>

		<spring:url value="/product/save" var="userActionUrl" />
		<form:form method="post" modelAttribute="product" action="${userActionUrl}">
			<form:hidden path="id" />
			<form:input path="name" type="text" />
			<!-- bind to user.name-->
			<form:errors path="name" />

			<button type="submit" class="btn-lg btn-primary pull-right" value="Submit" ></button>
		</form:form>
	</div>
</body>
</html>
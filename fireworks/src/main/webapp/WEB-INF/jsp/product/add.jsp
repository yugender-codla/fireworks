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
				<h1>Add Product</h1>
			</c:when>
			<c:otherwise>
				<h1>Update Product</h1>
			</c:otherwise>
		</c:choose>

		<h4>${msg}</h4>
		<h4>${error}</h4>
		<spring:url value="/product/save" var="addUrl" />
		<spring:url value="/product/list" var="listUrl" />
		<form:form method="post" modelAttribute="product" action="${addUrl}">
			<form:hidden path="id" />
			Name : <form:input path="name" type="text" /><br>
			Price : <form:input path="price" type="text" /><br>
			
  		<label for="Available">Available: </label>
  		<form:select path="available">
  			<form:option value="Y" selected="selected">Yes</form:option>
  			<form:option value="N">No</form:option>
  		
  		</form:select>
		
			
			<br>
			<!-- bind to user.name-->
			<form:errors path="name" />
			<br>
			<input type = "submit" value = "Submit"/>
			
		</form:form>
		<c:choose>
			<c:when test="${product['new']}">
			</c:when>
			<c:otherwise>
				 <button onclick="location.href='${listUrl}'">Back to list</button>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>
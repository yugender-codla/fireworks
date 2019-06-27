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
	<div class="container" style = "padding-top:20px;padding-bottom:20px">
		<c:choose>
			<c:when test="${product['new']}">
				<h1 style="font-size: 22px;">Add Product</h1>
			</c:when>
			<c:otherwise>
				<h1 style="font-size: 22px;">Update Product</h1>
			</c:otherwise>
		</c:choose>

		<hr>
			
		<h4 style="font-size: 14px;">${msg}</h4>
		<h4 style="font-size: 14px;">${error}</h4>
		<spring:url value="/product/save" var="addUrl" />
		<spring:url value="/product/list" var="listUrl" />

		<form:form method="post" modelAttribute="product" action="${addUrl}" class="form-inline">
			<div class="form-group"
				style="padding: 6px; padding-right: 10px; padding-top: 0px; padding-bottom: 4px; margin-bottom: 3px;">
				<label
					style="padding: 10px; padding-left: 0px; padding-bottom: 3px; padding-top: 3px;">Category</label>
					
				<form:hidden path="id" />
					<form:select class="form-control" path="category">
				<form:option value="Sparklers" selected="selected">Sparklers</form:option>
				<form:option value="Flower Pots">Flower Pots</form:option>
				<form:option value="Chakras">Chakras</form:option>
				<form:option value="Novel Fireworks">Novel Fireworks</form:option>
				<form:option value="One Sound Crackers">One Sound Crackers</form:option>
				<form:option value="Bombs">Bombs</form:option>
				<form:option value="Multiple Shots">Multiple Shots</form:option>
				<form:option value="Walas/Larger Land Crackers">Walas/Larger Land Crackers</form:option>
				<form:option value="Comets">Comets</form:option>
				<form:option value="Rockets">Rockets</form:option>
				<form:option value="Fancy Fireworks">Fancy Fireworks</form:option>
				<form:option value="Others">Others</form:option>
			</form:select>
					
			</div>
			<div class="form-group"
				style="padding-right: 10px; padding-top: 0px; padding-bottom: 4px; padding-left: 6px; margin-bottom: 3px;">
				<label
					style="padding: 10px; padding-left: 0px; padding-top: 3px; padding-bottom: 3px;">Name</label>
					<form:input class="form-control" path="name" type="text" style="padding-right: 5px;"/>
					
			</div>
			<div class="form-group"
				style="padding-right: 10px; padding-bottom: 4px; padding-left: 6px; padding-top: 0px; margin-bottom: 3px;">
				<label
					style="padding: 10px; padding-left: 0px; padding-top: 3px; padding-bottom: 3px;">Price</label>
					<form:input class="form-control" path="price" type="text" />
					
			</div>
			<div class="form-group"
				style="padding-top: 0px; padding-right: 10px; padding-left: 6px; padding-bottom: 4px; margin-bottom: 3px;">
				<label
					style="padding: 10px; padding-left: 0px; padding-top: 3px; padding-bottom: 3px;">Available</label>
					
					<form:select class="form-control" path="available">
				<form:option value="Y" selected="selected">Yes</form:option>
				<form:option value="N">No</form:option>

			</form:select>
					
			</div>
			<div class="form-group"
				style="padding-right: 10px; padding-bottom: 4px; padding-left: 6px;">
				<button class="btn btn-primary" type="submit"
					style="padding-top: 6px; ">&nbsp;ADD
					PRODUCT</button>
			</div>
			<br>
			<!-- bind to user.name-->
			<form:errors path="name" />
			<br>
		</form:form>


<%-- 
		<form:form method="post" modelAttribute="product" action="${addUrl}">
			<form:hidden path="id" />
						Category: 
						<form:select path="category">
				<form:option value="Sparklers" selected="selected">Sparklers</form:option>
				<form:option value="Flower Pots">Flower Pots</form:option>
				<form:option value="Chakras">Chakras</form:option>
				<form:option value="Novel Fireworks">Novel Fireworks</form:option>
				<form:option value="One Sound Crackers">One Sound Crackers</form:option>
				<form:option value="Bombs">Bombs</form:option>
				<form:option value="Multiple Shots">Multiple Shots</form:option>
				<form:option value="Walas/Larger Land Crackers">Walas/Larger Land Crackers</form:option>
				<form:option value="Comets">Comets</form:option>
				<form:option value="Rockets">Rockets</form:option>
				<form:option value="Fancy Fireworks">Fancy Fireworks</form:option>
				<form:option value="Others">Others</form:option>
			</form:select>
			<br>
			Name : <form:input path="name" type="text" />
			<br>
			Price : <form:input path="price" type="text" />
			<br>

			<label for="Available">Available: </label>
			<form:select path="available">
				<form:option value="Y" selected="selected">Yes</form:option>
				<form:option value="N">No</form:option>

			</form:select>


			<br>
			<!-- bind to user.name-->
			<form:errors path="name" />
			<br>
			<input type="submit" value="Submit" />

		</form:form> --%>
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


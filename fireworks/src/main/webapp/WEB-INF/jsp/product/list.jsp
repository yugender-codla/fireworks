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

		<c:if test="${not empty msg}">
		    <div class="alert alert-${css} alert-dismissible" role="alert">
			<button type="button" class="close" data-dismiss="alert" 
                                aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>${msg}</strong>
		    </div>
		</c:if>

		<h1>All Products</h1>

		<table class="table table-striped">
			<thead>
				<tr>
					<th>#ID</th>
					<th>Name</th>
					<th>Image 1</th>
					<th>Image 2</th>
					<th>Image 3</th>
					<th>Image 4</th>
					<th>Image 5</th>
				</tr>
			</thead>

			<c:forEach var="item" items="${products}">
			    <tr>
				<td>
					${item.id}
				</td>
				<td>${item.name}</td>
				<td>${item.image1Name} </td>
				<td>${item.image2Name} </td>
				<td>${item.image3Name} </td>
				<td>${item.image4Name} </td>
				<td>${item.image5Name} </td>
				
				<td>
				 
				  
				<spring:url value="/product/${item.id}/update" var="updateUrl" />
 				<spring:url value="/product/${item.id}/delete" var="deleteUrl" />
 				
				 <!-- <button class="btn btn-info" 
                                          onclick="location.href='${userUrl}'">Query</button>  -->
				  <button class="btn btn-primary" 
                                          onclick="location.href='${updateUrl}'">Update</button>
				  <button class="btn btn-danger" 
                                          onclick="this.disabled=true;post('${deleteUrl}')">Delete</button>
                                </td>
			    </tr>
			</c:forEach>
		</table>

	</div>
</body>
</html>
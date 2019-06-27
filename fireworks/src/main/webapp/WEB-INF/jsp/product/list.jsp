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
		
		<div style="margin-top: 28px;margin-bottom:30px;">
            <h1 class="text-left" style="font-size: 22px;">Products</h1>
            <hr>
        </div>
		

		<table class="table table-striped ">
			<thead>
				<tr>
					<!-- <th>#ID</th> -->
					<th>Name</th>
					<th>Price</th>
					<th>A</th>
					<th>Act</th>
					<th>Action</th>
				</tr>
			</thead>

			<c:forEach var="item" items="${products}">
			    <tr>
				<%-- <td>
					${item.id}
				</td> --%>
				<td>${item.name}</td>
				<td>${item.price}</td>
				<td>${item.available}</td>
				<td>${item.active}</td>
				<td>
				 
				  
				<spring:url value="/product/${item.id}/update" var="updateUrl" />
 				<spring:url value="/product/${item.id}/delete" var="deleteUrl" />
 				
				 <!-- <button class="btn btn-info" 
                                          onclick="location.href='${userUrl}'">Query</button>  -->
				  <button class="btn btn-primary" style="font-size:10px;width:25px" 
                                          onclick="location.href='${updateUrl}'">U</button>
				  <button class="btn btn-danger" style="font-size:10px;width:25px"
                                          onclick="this.disabled=true;location.href='${deleteUrl}'">D</button>
                                </td>
			    </tr>
			</c:forEach>
		</table>

	</div>
</body>
</html>
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
            <h1 class="text-left" style="font-size: 22px;">Inventory</h1>
        </div>
		

		<table class="table table-striped ">
			<thead>
				<tr>
					<!-- <th>#ID</th> -->
					<th>Name</th>
					<th>Invoiced</th>
					<th>Used</th>
					<th>Avail</th>
					<th>Req</th>
				</tr>
			</thead>

			<c:forEach var="item" items="${inventory}">
			    <tr>
				<%-- <td>
					${item.id}
				</td> --%>
				<td>${item.productName}</td>
				<td>${item.invoicedQty}</td>
				<td>${item.usedQty}</td>
				<td>${item.availQty}</td>
				<td>${item.requiredQty}</td>
			    </tr>
			</c:forEach>
		</table>

	</div>
</body>
</html>

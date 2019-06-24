<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>


<script>
function callAction(id,obj){
	document.getElementById("orderId").value=id;
	document.getElementById("event").value=obj.value;
	document.getElementById("statusCode").value = document.getElementById("status").options[document.getElementById("status").selectedIndex].value;
	if(obj.value == "MODIFY_ORDER"){
		document.forms[1].action = "/fireworks/"+id+"/retrieve";	
	}
	document.forms[1].submit();
}

$(document).ready(function(){
	var infoModal = $('#myModal');
	
	 $(".view-button").click(function(event){
		 event.preventDefault();
		 var url = $(this).attr("id");
		
		 $.ajax({
	            type: 'GET',
	            url: url,
	            dataType: 'json',
	            success: function (output) {
	            	var lineItemsLength = output.length;
	            	var row = "";
	            	
	            	for(var i=0;i<lineItemsLength;i++){
	            		 row = row + "<tr><td>"+output[i].productName+"</td><td>"+output[i].availableQuantity+"</td><td>"+output[i].requiredQuantity+"</td></tr>";
	            	}
	            	
	            	infoModal.find('.modal-body').find(".mdlTbody").html(row);
            		infoModal.modal('show');
	            	//$('#myModal').modal('toggle');
	            },
	            error: function(output){
	            alert("fail");
	            }
	        });
		 
		 
	 });
});  

</script>
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

		<h1>Search Orders</h1>

<spring:url value="/fireworks/findOrders" var="showFindOrdersUrl" />
<spring:url value="/fireworks/modifyStatus" var="orderModifyStatusUrl" />

 <form:form method="post" action="${showFindOrdersUrl}" modelAttribute="searchOrder">

 		<select id ="status" name ="statusCode" >
		<option value = "0" label = "Select" ${0 == statusCode ? 'selected="selected"' : ''}/>
		<option value ="101" ${101 == statusCode ? 'selected="selected"' : ''}>Order Submitted</option>
		<option value ="103"  ${103 == statusCode ? 'selected="selected"' : ''}>Order Modified</option>
		<option value ="104"  ${104 == statusCode ? 'selected="selected"' : ''}>User Approved Order</option>
		<option value ="102"  ${102 == statusCode ? 'selected="selected"' : ''}>Packing Completed</option>
		<option value ="105"  ${105 == statusCode ? 'selected="selected"' : ''}>Delivered</option>
		<option value ="106"  ${106 == statusCode ? 'selected="selected"' : ''}>Order In Progress</option>
		</select>
    	<br>
    	<input type ="submit" value = "Search">
    	</form:form>
    	
    	<form:form method="post" action="${orderModifyStatusUrl}" modelAttribute="order">
    	<table class="table table-striped">
			<thead>
				<tr>
					<th>#ID</th>
					<th>DeliverBy</th>
					<th>Phone Number</th>
					<th>Price</th>
					<th>Status</th>
					<th>Action</th>
				</tr>
			</thead>
			

			<c:forEach var="item" items="${orders}">
			    <tr>
				<td>
					${item.id}
				</td>
				<td>
				<fmt:formatDate value="${item.deliverBy}" pattern="dd-MM-yyyy" />
				</td>
				<td>${item.phoneNumber} </td>
				<td>${item.priceOfTheOrder}</td>
				<td>${item.status} </td>
			<td>
				<spring:url value="/fireworks/${item.id}/view" var="viewUrl" />
				 <c:forEach var="events" items="${item.events}">
				  <button class="btn btn-primary" type="button" value ="${events}" onclick ="callAction(${item.id},this)">${events}</button>
				  </c:forEach>
				  <button class="view-button btn btn-primary" id="${viewUrl}" type ="button">View</button>
			</td>
				  
			    </tr>
			</c:forEach>
	
			
		</table>
			 <input type="hidden" name="orderId" id="orderId">
			 <input type="hidden" name="event" id="event">
			 <input type="hidden" name="statusCode" id="statusCode">
		</form:form>
	</div>
	
	
	<div class="modal fade" id="myModal">
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h4 class="modal-title">Order Details: <span id="mdlInvoiceId"></span></h4> 
      
      
           
    </div>
    <div class="modal-body">
      <table class="table table-bordered">
          <thead>
          <tr>
          	<th>Product id</th>
          	<th>Available Qty</th>
          	<th>Required Qty</th>
          </tr>
          </thead>
          <tbody class="mdlTbody">
              <tr>
                  <td>1</td>
                  <td>2</td>
              </tr>
              
          </tbody>
      </table>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>
  </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</body>
</html>
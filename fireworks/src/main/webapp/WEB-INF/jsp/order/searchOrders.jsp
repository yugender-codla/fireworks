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
	document.getElementById("statusCode").value = document.getElementById("inputSelect").options[document.getElementById("inputSelect").selectedIndex].value;
	
	if(obj.value == "MODIFY_ORDER"){
		document.forms[1].action = "/firesupport/order/"+id+"/retrieve";	
	}
	document.forms[1].submit();
}

$(document).ready(function(){
	var infoModal = $('#myModal');
	
	 $(".view-button").click(function(event){
		 event.preventDefault();
		 var url = $(this).attr("id");
		 var fn = $(this).attr("fn");
		 var itemPrice = $(this).attr("itemPrice");
		 var itemDeliverBy = $(this).attr("itemDeliverBy");
		 $.ajax({
	            type: 'GET',
	            url: url,
	            dataType: 'json',
	            success: function (output) {
	            	
	            	var lineItemsLength = output.length;
					var row = "";
					var tFootContent = "";
					var qty1 = "";
	            	for(var i=0;i<lineItemsLength;i++){
	            		qty1 = "-";
	            		qty2 = "-";
	            		
	            		if(output[i].qty1 != null){
	            			qty1 = output[i].qty1;
	            		}
	            		
	            		if(output[i].qty2 != null){
	            			qty2 = output[i].qty2;
	            		}
	            		 row = row + "<tr><td>"+output[i].productName+"</td><td>"+qty1+"</td><td>"+qty2+"</td></tr>";
	            	}
	            	
	            	tFootContent = tFootContent + "<tr><td colspan='3'>Price: "+itemPrice+"</td></tr>";
	            	tFootContent = tFootContent + "<tr><td colspan='3'>Deliver By: "+itemDeliverBy+"</td></tr>";
	            	
	            	//Build THead
	            	var th = "";
	            	if(fn=='view'){
	            		$('#mdlInvoiceId').html('Order/Stock Details:');
	            		th = "<tr><th>Product Name</th><th>Qty</th><th>Available</th></tr>"
	            	}else if(fn == "review"){
	            		$('#mdlInvoiceId').html('Order Review');
	            		th = "<tr><th>Product Name</th><th>Curr</th><th>old</th></tr>"
	            	}
	            	
	            	infoModal.find('.modal-body').find(".mdlTHead").html(th);
	            	
	            	infoModal.find('.modal-body').find(".mdlTbody").html(row);
	            	infoModal.find('.modal-body').find(".mdlTfoot").html(tFootContent);
	            	
	            	
	            	
	            	
            		infoModal.modal('show');
	            	//$('#myModal').modal('toggle');
	            },
	            error: function(output){
	            alert("fail");
	            }
	        });
		 
		 
	 });
	 
	 
	 $("#searchBtn").click(function(event){
		 if($("#searchCriteria option:selected").val() == "orderStatus"){
			 $("#searchValue").val($("#inputSelect option:selected").val());	 
		 }else{
			 $("#searchValue").val($("#inputTxt").val());	 
		 }
		 $("#searchForm").submit();
		 
	 });
	 
	 $('#searchCriteria').on('change', function() {
		  if(this.value == "orderStatus"){
			  $('#inputSelect').show();
			  $('#inputTxt').hide();
		  }else{
			  $('#inputSelect').hide();
			  $('#inputTxt').show();
		  }
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

<spring:url value="/firesupport/order/find" var="showFindOrdersUrl" />
<spring:url value="/firesupport/order/modifyStatus" var="orderModifyStatusUrl" />


 <div class="container" style="padding: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;">
        <div style="margin-top: 28px;">
            <h1 class="text-left" style="font-size: 22px;">Search Orders</h1>
            <hr>
        </div>
        <form:form class="border-primary shadow" id="searchForm" method="post" action="${showFindOrdersUrl}" modelAttribute="searchOrder">
        
                <div class="row" style="padding: 20px;">
        <div class="col" style="padding-right: 14px;padding-top: 14px;">
        
         <select class="form-control" style="margin: 0px;width: 178px;height: 38px;" id="searchCriteria" name="searchCriteria" onchange="setCriteriaInput(this)">
                    <option value="orderStatus" selected="selected">Order Status</option>
                    <option value="phoneNumber">Phone Number</option>
                    <option value="orderNumber">Order Number</option>
                    <option value="email">Email</option>
                    </select>
        </div>
        <div
            class="col" style="padding-top: 14px;">
           <!--  <input class="border rounded border-secondary" type="text" style="padding-top: 0px;padding-bottom: 0px;height: 38px;"> -->
            
            <select class="form-control" id ="inputSelect"  style="margin: 0px;width: 178px;height: 38px;">
                    	<option value = "0" label = "Select" ${0 == statusCode ? 'selected="selected"' : ''}/>
						<option value ="101" ${101 == statusCode ? 'selected="selected"' : ''}>Order Submitted</option>
						<option value ="103"  ${103 == statusCode ? 'selected="selected"' : ''}>Order Modified</option>
						<option value ="104"  ${104 == statusCode ? 'selected="selected"' : ''}>User Approved Order</option>
						<option value ="102"  ${102 == statusCode ? 'selected="selected"' : ''}>Packing Completed</option>
						<option value ="105"  ${105 == statusCode ? 'selected="selected"' : ''}>Delivered</option>
						<option value ="106"  ${106 == statusCode ? 'selected="selected"' : ''}>Order In Progress</option>
                     </select>
                     
                    <input class="form-control" type="text" id="inputTxt" style="width: 178px;height: 38px;display:none">
             <input class="form-control" type="hidden" id="searchValue" name="searchValue">
            </div>
    <div class="col" style="padding-top: 14px;"><button class="btn btn-primary" type="button" style="width: 97px;height: 38px;" id="searchBtn">Search</button></div>
    <div class="col"></div>
    </div>
         
    </form:form>


    	<form:form method="post" action="${orderModifyStatusUrl}" modelAttribute="order">
    	<table class="table table-striped">
			<thead>
				<tr style="height:45px;">
					<th>#ID</th>
					<th>Name</th>
					<th>Status</th>
					<!-- <th>Phone</th> -->
					<th>Action</th>
				</tr>
			</thead>
			

			<c:forEach var="item" items="${orders}">
			    <tr>
				<td>
					${item.orderNumber}
				</td>
				<td>
					${item.custName}
				</td>
					<td>${item.status} </td>
				<%-- <td>
				<fmt:formatDate value="${item.deliverBy}" pattern="dd-MM-yyyy" />
				</td> --%>
				<%-- <td>${item.phoneNumber} </td> --%>
				<%-- <td>${item.priceOfTheOrder}</td> --%>
			
			<td style="padding:1px;">
				<spring:url value="/firesupport/order/${item.id}/view" var="viewUrl" />
				<spring:url value="/fireworks/order/${item.id}/review" var="reviewUrl" />
				 <c:forEach var="events" items="${item.events}">
				  <button style="font-size:10px;width:25px" type="button" value ="${events}" onclick ="callAction(${item.id},this)" title="${events}" >${fn:substring(events, 0, 1)}</button>
				  </c:forEach>
				  <button class="view-button" id="${viewUrl}" itemPrice="${item.priceOfTheOrder}" fn="view" itemDeliverBy ="<fmt:formatDate value="${item.deliverBy}" pattern="dd-MM-yyyy" />" type ="button" style="font-size:10px;width:25px" title="View">V</button>
				  <c:if test="${item.modifiedFlag == 'Y'}">
				  	<button class="view-button" id="${reviewUrl}" itemPrice="${item.priceOfTheOrder}" fn="review" itemDeliverBy ="<fmt:formatDate value="${item.deliverBy}" pattern="dd-MM-yyyy" />" type ="button" style="font-size:10px;width:25px" title="View">R</button>
				  </c:if>
			</td>
			    </tr>
			    
			</c:forEach>
	
			
		</table>
			 <input type="hidden" name="orderId" id="orderId">
			 <input type="hidden" name="event" id="event">
			 <input type="hidden" name="statusCode" id="statusCode">
		</form:form>
	</div>
	</div>
	
<div class="modal fade" id="myModal">
<div class="modal-dialog">
  <div class="modal-content">
	<div class="modal-header">
					<h4 class="modal-title">
						<span id="mdlInvoiceId"></span>
					</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
    <div class="modal-body">
      <table class="table table-bordered">
          <thead class="mdlTHead">
          
          </thead>
          <tbody class="mdlTbody">
              <tr>
                  <td>1</td>
                  <td>2</td>
              </tr>
              
          </tbody>
          <tfoot class="mdlTfoot">
          
          </tfoot>
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
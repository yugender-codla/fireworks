<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
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
	            	var lineItemsLength =output.invoiceLineItems.length;
	            	var row = "";
	            	for(var i=0;i<lineItemsLength;i++){
	            		 row = row + "<tr><td>"+output.invoiceLineItems[i].productName+"</td><td>"+output.invoiceLineItems[i].quantity+"</td><td>"+output.invoiceLineItems[i].price+"</td><td>"+output.invoiceLineItems[i].discountPrice+" </td></tr>";
	            	}
	            	
	            	infoModal.find("#mdlInvoiceId").text(output.invoiceid);
	            	infoModal.find("#mdlBillDate").text(output.billDateAsString);
	            	infoModal.find("#mdlBillNo").text(output.billNo);
	            	infoModal.find("#mdlPrice").text('Rs.'+output.totalPrice);
	            	infoModal.find("#mdlDiscountPrice").text('Rs.'+output.discountPrice);
	            	
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

		<c:if test="${not empty msg}">
		    <div class="alert alert-${css} alert-dismissible" role="alert">
			<button type="button" class="close" data-dismiss="alert" 
                                aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>${msg}</strong>
		    </div>
		</c:if>

		<h1>List Invoices</h1>

<spring:url value="/firesupport/invoice/search/find" var="searchUrl" />

<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="todayDate" value="${now}" pattern="yyyy-MM-dd" />

 <form:form method="get" action="${searchUrl}">
    	<label for="bill date">From Bill Date : </label><input name = "fromDate"  type="date" value="2019-09-01" >
    	<label for="bill date">To Bill Date : </label><input name = "toDate"  type="date" value="${todayDate}">
    	
    	<br>
    	<input type ="submit" value = "Search">
    	</form:form>

		<table class="table table-striped">
			<thead>
				<tr>
					<th>#ID</th>
					<th>Bill Date</th>
					<th>Bill No</th>
					<th>Total Price</th>
					<th>Discounted Price</th>
				</tr>
			</thead>
			

			<c:forEach var="item" items="${invoices}">
			    <tr>
				<td>
					${item.invoiceid}
				</td>
				<td><fmt:formatDate pattern="dd-MMM-yyyy" value="${item.billDate}"/></td>
				<td>${item.billNo} </td>
				<td>${item.totalPrice} </td>
				<td>${item.discountPrice} </td>
				<td>
				 
				  
				<spring:url value="/firesupport/invoice/${item.invoiceid}/update" var="updateUrl" />
 				<spring:url value="/firesupport/invoice/${item.invoiceid}/view" var="viewUrl" />
 				
				 <!-- <button class="btn btn-info" onclick="location.href='${userUrl}'">Query</button>  -->
				  <button class="btn btn-primary" onclick="location.href='${updateUrl}'">Edit</button>
				  <button class="view-button btn btn-primary" id="${viewUrl}">View</button>
				  </td>
				  
			    </tr>
			</c:forEach>
		</table>


<div class="modal fade" id="myModal">
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
     <div>
       <table class="table table-borderless">
       <tr>
       <th>Invoice No: </th>
       <td> <span id="mdlInvoiceId"></span></td> 
       <th>Bill No:</th>
       <td><span id="mdlBillNo"></span></td>
       <th>Bill Date:</th>
       <td><span id="mdlBillDate"></span></td>
       </tr>
       <tr>
       <th>Price:</th><td colspan="2"><span id="mdlPrice"></span></td>
       <th>Discount Price:</th><td colspan="2"><span id="mdlDiscountPrice"></span></td>
       </tr>
       </table>
       </div>
      <div> 
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        </div>
      <!-- <h4 class="modal-title">Invoice: <span id="mdlInvoiceId"></span></h4>  -->
    <!--   <h5 >Bill No: </h5><span id="mdlBillNo"></span> 
      <h5 >Bill Date: </h5><span id="mdlBillDate"></span>
      <h5>Price: </h5><span id="mdlPrice"></span>
      <h5>Discount Price: </h5><span id="mdlDiscountPrice"></span> -->
      
    </div>
    <div class="modal-body">
      <table class="table table-bordered">
          <thead>
          <tr>
          	<th>Product Name</th>
          	<th>Quantity</th>
          	<th>Price</th>
          	<th>Discount Price</th>
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
	

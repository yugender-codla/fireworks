<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

 <link rel="stylesheet" href="/css/style.css">
  <link rel="stylesheet" href="/assets/css/styles.css">
 
<head>
<script type="text/javascript">


	$(document).ready(function() {
		$("#qntyCountInputTxt").val(0);
		$("#qntyCountInputLbl").text(0);

		$(".quantityBtnAdd").click(function() {
			var parentTag = $(this).parent().children('label');
			var val = parseInt(parentTag.text());
			val = val + 1;
			parentTag.text(val);

			calculateQty();
		});

		$(".quantityBtnMinus").click(function() {
			var parentTag = $(this).parent().children('label');
			var val = parseInt(parentTag.text());
			if (val > 0) {
				val = val - 1;
				parentTag.text(val);
			}
			calculateQty();
		});

		function calculateQty(){
			var qnty = 0;
			var price = 0;
			var totalPrice = 0;
			$(".qty-class").each(function() {
				qnty = qnty + parseInt($(this).text());
				price = $(this).parent().children(".hiddenPrice").val();
				$(this).parent().children(".hiddenQnty").val(parseInt($(this).text()));
				
				totalPrice = totalPrice + parseInt($(this).text()) * parseFloat(price);
				
			});
			
			$("#qntyCountInputTxt").val(qnty);
			$("#qntyCountInputLbl").text(qnty);


			$("#priceCountInputTxt").val(totalPrice);
			$("#priceCountInputLbl").text(totalPrice);			
		}
		
		calculateQty();

		
		
		
		var infoModal = $('#myModal');
		
		 $(".view-button").click(function(event){
			 event.preventDefault();
			 var url = $(this).attr("id");
			 var htmlHeadString = "<div> <table class='table table-bordered'><tbody class='mdlTbody'>";
			 var htmlFootString = "</tbody></table></div>";
			 $.ajax({
		            type: 'GET',
		            url: url,
		            dataType: 'json',
		            success: function (output) {
		            	var lineItemsLength = output.length;
		            
						var row = "";
						var tFootContent = "";
		            	for(var i=0;i<lineItemsLength;i++){
		            	
		            		 row = row + "<tr><td>"+output[i].pid1+ "</td></tr>";
		            	}
		            	
		            	var fullString = htmlHeadString + row + htmlFootString;
		            	
		            	infoModal.find('.modal-body').html(fullString);
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

<style>
#mainNavbar5{
position:fixed;
top:100px;
}

.middleContent{
padding-top:80px;
}
</style>
</head>


<!------ Include the above in your HEAD tag ---------->

<div class="container">
	<div class="row">
	
			<div class="col-xs-3" style="width:300px;">
<nav id="mainNavbar5" >
			<ul class="nav nav-pills nav-stacked flex-column">
					<c:set var="categoryCounter" value="${0}" />
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="categoryCounter" value="${categoryCounter + 1}" />

						<c:choose>
							<c:when test="${categoryCounter eq 1}">
								<li  class="nav-item active"><a class="nav-link active"
									href="#tab${categoryCounter}">${item.key}</a></li>
							</c:when>
							<c:otherwise>
								<li class="nav-item "><a class="nav-link"
									href="#tab${categoryCounter}"
									>${item.key}</a></li>
							</c:otherwise>
						</c:choose>

					</c:forEach>
				</ul>
</nav>

			<!-- <nav id="mainNavbar" >
				
					
 					<ul class="nav nav-pills nav-stacked">
 					<li class="nav-item nav-link"><a href="#divDesert">Desert</a></li>
 					<li class="nav-item nav-link active" ><a href="#divLight">Desert</a></li>
 					<li class="nav-item nav-link "><a href="#divTulips">Desert</a></li>
 					<li class="nav-item nav-link "><a href="#div">Desert</a></li>
 					</ul>
 					
 
 </nav> -->

			
</div>


			<div class="col-xs-6">
				


					<c:set var="itemsCounter" value="${0}" />
					<c:set var="tabsCounter" value="${0}" />
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="tabsCounter" value="${tabsCounter + 1}" />

					<div class="middleContent" id="tab${tabsCounter}">
						<div class="pb-2 mt-4 mb-2 border-bottom" >
							<h4>${item.key}</h4>
						</div>
						<c:forEach var="subItem" items="${item.value}" varStatus="loop">
							<c:set var="itemsCounter" value="${itemsCounter + 1}" />
						<spring:url value="/firesupport/product/${subItem.productId}/viewCombo" var="viewUrl" />
							<div class="col-12 col-sm-12 col-md-12 col-lg-12 ">
								<div class="card">
									<div class="card-body">

										<div class="float-left">
											<c:set var="nameParts"
												value="${fn:split(subItem.productName, ',')}" />
											<input type="hidden"
												name="orderLineItems[${itemsCounter}].productId"
												value="${subItem.productId}"> <input type="hidden"
												name="orderLineItems[${itemsCounter}].productName"
												value="${subItem.productName}">
											<a href="#" class="view-button" id="${viewUrl}">
											<h4 class="card-text">${nameParts[0]}
												${nameParts[1]} ${nameParts[2]}<br> ${nameParts[3]}
											</h4>
											</a>

											<div style="font-size: 12px;">
												<span><i class="fa" style="color: grey">&#xf156;</i>
												</span> <label class="price-class" style="color: grey">${subItem.price}</label>
											</div>
										</div>

										<div
											class="rounded border border-grey quantity-padding float-right">
											<button class="btn quantityBtnMinus" type="button">
												<i class="fa fa-minus" aria-hidden="true"
													style="color: grey; cursor: hand"></i>
											</button>
											<input type="hidden" class="hiddenPrice"
												name="orderLineItems[${itemsCounter}].price"
												value="${subItem.price}"> <input type="hidden"
												name="orderLineItems[${itemsCounter}].quantity"
												class="hiddenQnty" value="${subItem.quantity}"> <label
												class="qty-class" style="color: grey;" >${subItem.quantity}</label>
											<button class="btn quantityBtnAdd" type="button">
												<i class="fa fa-plus" aria-hidden="true"
													style="color: #F26522; cursor: hand"></i>
											</button>
										</div>

									</div>
								</div>
							</div>
						</c:forEach>
				
</div>
				</c:forEach>
				</div>
				
		<div class="col-xs-3 middleContent">Cart Empty</div>
	</div>

</div>


<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<span id="mdlInvoiceId">Products:</span>
					</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>



				</div>
				<div class="modal-body"></div>
				
				
				<!-- <div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div> -->
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
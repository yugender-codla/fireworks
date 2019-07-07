<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
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

	});
</script>
</head>


<!------ Include the above in your HEAD tag ---------->

<div class="container">
	<div class="row">
	
		<div role="tabpanel">
			<div class="col-sm-3">

				<ul class="nav nav-pills brand-pills nav-stacked" role="tablist">
					<c:set var="categoryCounter" value="${0}" />
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="categoryCounter" value="${categoryCounter + 1}" />

						<c:choose>
							<c:when test="${categoryCounter eq 1}">
								<li role="presentation" class="brand-nav active"><a
									href="#tab${categoryCounter}"
									aria-controls="tab${categoryCounter}" role="tab"
									data-toggle="tab">${item.key}</a></li>
							</c:when>
							<c:otherwise>
								<li role="presentation" class="brand-nav"><a
									href="#tab${categoryCounter}"
									aria-controls="tab${categoryCounter}" role="tab"
									data-toggle="tab">${item.key}</a></li>
							</c:otherwise>
						</c:choose>

					</c:forEach>
				</ul>


			</div>






			<div class="col-sm-6">
				<div class="tab-content">


					<c:set var="itemsCounter" value="${0}" />
					<c:set var="tabsCounter" value="${0}" />
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="tabsCounter" value="${tabsCounter + 1}" />

						<c:choose>
							<c:when test="${tabsCounter eq 1}">
								<div role="tabpanel" class="tab-pane active"
									id="tab${tabsCounter}">
							</c:when>
							<c:otherwise>
								<div role="tabpanel" class="tab-pane" id="tab${tabsCounter}">
							</c:otherwise>
						</c:choose>







						<div class="pb-2 mt-4 mb-2 border-bottom">
							<h4>${item.key}</h4>
						</div>
						<c:forEach var="subItem" items="${item.value}" varStatus="loop">
							<c:set var="itemsCounter" value="${itemsCounter + 1}" />

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
											<h4 class="card-text">${nameParts[0]}
												${nameParts[1]} ${nameParts[2]}<br> ${nameParts[3]}
											</h4>

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
		</div>
		<div class="col-sm-3">Cart Empty</div>
	</div>
</div>
</div>
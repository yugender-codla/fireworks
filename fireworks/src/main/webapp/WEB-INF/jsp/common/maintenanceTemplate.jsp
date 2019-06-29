<!doctype html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
 <meta name="viewport" content="width=device-width, initial-scale=1">
<%-- <script type="text/javascript" src='<c:url value="/scripts/jquery-1.12.4.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/scripts/bootstrap.min.js"/>'></script>
<link rel="stylesheet" href="/css/bootstrap.min.css"> --%>
  <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"> -->
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script> -->
<!--   <link rel="stylesheet" href="/assets/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="/assets/fonts/font-awesome.min.css"> -->


  <script src="/scripts/jquery.js"></script>
  <script src="/scripts/popper.js"></script>
  <script src="/scripts/bootstrap.min.js"></script>
  

 <link rel="stylesheet" href="/assets/fonts/font-awesome.min.css"> 
 <link rel="stylesheet" href="/assets/bootstrap/css/bootstrap.min.css">
 <link rel="stylesheet" href="/css/style.css">
    
 <link rel="stylesheet" href="/assets/css/styles.css">

</head>
<body>

	 	 <nav class="navbar navbar-light navbar-expand-md sticky-top navigation-clean-button" id="mainNav" style="background-color: #3655a4;color:#ffffff">
		<div class="container-fluid">
			<a class="navbar-brand" href="/fireworks" style="color:#ffffff;"><i class="fa fa-shopping-bag"></i> &nbsp;4Alphas</a>
	<!-- 		<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation">
				<i class="fas fa-bars"></i>
			</button> -->
			 <button data-toggle="collapse" class="navbar-toggler" data-target="#navbarResponsive" ><span class="sr-only" >Toggle navigation</span><span class="navbar-toggler-icon" style="color:#ffffff;"></span></button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/stock" style="color:#ffffff;"><i class="fa fa-suitcase"></i>&nbsp;Inventory</a></li>
						
				<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/firesupport/order/search" style="color:#ffffff;"><i class="fa fa-star"></i>&nbsp;Orders</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/add" style="color:#ffffff;"><i class="fa fa-home"></i>&nbsp;Add Product</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/list" style="color:#ffffff;"><i class="fa fa-first-order"></i>&nbsp;Products</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/add" style="color:#ffffff;"><i class="fa fa-wpexplorer"></i>&nbsp;Add Invoice</a></li>
							
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/search/display" style="color:#ffffff;"><i class="fa fa-bullhorn"></i>&nbsp;Invoices</a></li>
				</ul>
			</div>
		</div>
	</nav> 

    <jsp:include page="../${pageView}.jsp"/>

</body>
</html>
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
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css">
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script> -->
  
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.css">
  <script src="/scripts/jquery.js"></script>
  <script src="/scripts/fontawesome.js"></script>
  <script src="/scripts/popper.js"></script>
  <script src="/scripts/bootstrap.min.js"></script>
  
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top" id="mainNav">
		<div class="container-fluid">
			<a class="navbar-brand js-scroll-trigger" href="#page-top" >
				<div>
					<div class="float-left" >
						
							<img src="/images/logo.png" class="float-left" style="height: 20px">
						<div class="align-middle">
						<h6 class="float-middle"> <span class="text-dark align-middle">4alphas Deepavali Services </span></h6></div>
						</div>
				</div> 
			</a>
			<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation">
				<i class="fas fa-bars"></i>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
	<!-- 				<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="#about">Home</a></li>
	 -->				<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks">Order</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks/showTrack">Track Order</a></li>
							
<!-- 					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/add">Add Product</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/list">Products List</a></li>
					
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/add">Add Invoice</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/search/display">Invoices</a></li>
 -->				</ul>
			</div>
		</div>
	</nav>
  
     
    <jsp:include page="../${pageView}.jsp"/>

</body>
</html>
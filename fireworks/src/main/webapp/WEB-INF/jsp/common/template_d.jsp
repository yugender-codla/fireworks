<!doctype html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
 <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0">
<%-- <script type="text/javascript" src='<c:url value="/scripts/jquery-1.12.4.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/scripts/bootstrap.min.js"/>'></script>
<link rel="stylesheet" href="/css/bootstrap.min.css"> --%>
  <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"> -->
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script> -->
  
  
  
  
  <script src="/scripts/jquery.js"></script>
  <script src="/scripts/popper.js"></script>
  <script src="/scripts/bootstrap.min.js"></script> 
  

 <link rel="stylesheet" href="/assets/fonts/font-awesome.min.css"> 
  <link rel="stylesheet" href="/assets/bootstrap/css/bootstrap.min.css"> 
  <link rel="stylesheet" href="/css/style.css">
  
  <script>
  
  function showSpinButton(){
	  if(document.getElementById("spinButton")){
	  document.getElementById("spinButton").style.visibility = "visible";
  	}
  }
  
  function checkLoad()
	 {
	    if(document.getElementById("bottom"))
	    {
	 	document.getElementById("preLoaderDiv").style.visibility = "hidden";
	    }
	 }
	 
	 setInterval("checkLoad()",100);
  </script>
  
</head>

<body>
<div id="preLoaderDiv">
	<img id="preloaderAnimation" src="/images/loading.gif" width="50px" height="50px"/>
</div>

	 <!-- <nav class="navbar navbar-light navbar-expand-md sticky-top navigation-clean-button" id="mainNav" style="background-color: #3655a4;color:#ffffff"> -->
	 <nav class="navbar navbar-light navbar-expand-md fixed-top" id="mainNav" style="background-color: #3655a4;color:#ffffff;float: right;" >
		<div class="container" >
			<a class="navbar-brand" href="/fireworks" style="color:#ffffff;"><i class="fa fa-shopping-bag"></i> &nbsp;4Alphas</a> 
	<!-- 		<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation">
				<i class="fas fa-bars"></i>
			</button> -->
			 <button data-toggle="collapse" class="navbar-toggler" data-target="#navbarResponsive" ><span class="sr-only" >Toggle navigation</span><span class="navbar-toggler-icon" style="color:#ffffff;"></span></button>
			<div class="" id="navbarResponsive" style="float: right;">
				<ul class="nav navbar-nav ml-auto navbar-right" >
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="#about" style="color:#ffffff;"><i class="fa fa-home"></i>&nbsp;Home</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks" style="color:#ffffff;"><i class="fa fa-first-order"></i>&nbsp;Order</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks/order/trackview" style="color:#ffffff;"><i class="fa fa-wpexplorer"></i>&nbsp;Track Order</a></li>
							
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks/contactUs" style="color:#ffffff;"><i class="fa fa-bullhorn"></i>&nbsp;Contact Us</a></li>
					<!-- <li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/add">Add Product</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/list">Products List</a></li>
					
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/add">Add Invoice</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/search/display">Invoices</a></li> -->
				</ul>
			</div>
		</div>
	</nav> 
  
  
      
      <!-- <div>
        <nav class="navbar navbar-light navbar-expand-md sticky-top navigation-clean-button" style="height: 65px;background-color: #3655a4;">
            <div class="container-fluid"><a class="navbar-brand" href="#"><i class="fa fa-shopping-bag"></i> &nbsp;4Alphas</a>
            <button data-toggle="collapse" class="navbar-toggler" data-target="#navcol-1"><span class="sr-only">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            
                <div
                    class="collapse navbar-collapse" id="navcol-1" >
                    <ul class="nav navbar-nav ml-auto">
						<li class="nav-item" ><a class="nav-link " style="color:#ffffff;" href="#about"><i class="fa fa-home"></i>&nbsp;Home</a></li>
                        <li class="nav-item"><a class="nav-link " style="color:#ffffff;" href="/fireworks"><i class="fa fa-first-order"></i>&nbsp;Order</a></li>
                        <li class="nav-item" ><a class="nav-link " style="color:#ffffff;" href="/fireworks/showTrack"><i class="fa fa-wpexplorer"></i>&nbsp;Track Order</a></li>
                    </ul>
            </div>
            
            		<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation">
				<i class="fas fa-bars"></i>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="#about">Home</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks">Order</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/fireworks/showTrack">Track Order</a></li>
							
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/add">Add Product</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/product/list">Products List</a></li>
					
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/add">Add Invoice</a></li>
					<li class="nav-item"><a class="nav-link js-scroll-trigger"
						href="/invoice/search/display">Invoices</a></li>
				</ul>
			</div>
    </div>
    </nav>
    </div> -->
     
    <jsp:include page="../${pageView}.jsp"/>
<div id="bottom"></div>
</body>
</html>
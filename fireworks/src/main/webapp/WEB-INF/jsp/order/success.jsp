<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>4aplhas</title>
 <link rel="stylesheet" href="/assets/css/styles.css">
</head>

<body style="background-color: #ffffff">
<div class="container" >
    <div style="padding: 20px;"></div>
    <div class="border rounded border-success shadow" style="padding: 8px;margin: 11px;background-color: #ffffff">
    	 
        <h1 style="padding: 20px;padding-top: 20px;padding-left: 20px;font-size: 32px;color: rgb(18,136,37);padding-bottom: 4px;"><i class="fa fa-check-square-o" style="font-size: 32px;width: 31px;"></i>&nbsp;Thank you for shopping with us.</h1>
        
        <p style="padding: 20px;padding-bottom: 0px;">Your Order number is: <label style="color: rgb(13,46,222);font-size: 18px;">${orderNumber}</label>&nbsp;</p>
      
        <hr>
        <p style="padding: 20px;padding-top: 0px;">We will reach you shortly.! Your order number has been e-mailed to you. <br>
         Track your order status under 'Track Order' menu.
      		 <div style="text-align: center">
      		 <!-- <img width="150px" src="/images/animatedBomb.gif"> -->
      		 </div>    
        </p>
          
      
    </div>
    </div>
   
</body>

</html>
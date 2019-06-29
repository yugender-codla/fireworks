<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>4aplhas</title>
     <link rel="stylesheet" href="/assets/css/Contact-Form-Clean.css">
    
</head>

<body>
    <div class="contact-clean">
          <form:form method="post" action="/firesupport/contactUs" modelAttribute="contactForm">
            <h2 class="text-center">Contact us</h2>
            <div class="form-group"><input class="form-control" type="text" name="name" placeholder="Name" value="${contactForm.name}"><form:errors path="name" cssClass="error"/> </div>
            <div class="form-group"><input class="form-control" type="email" name="userEmail" placeholder="Email" value="${contactForm.userEmail}">
            <form:errors path="userEmail" cssClass="error"/> 
            <!-- <small class="form-text text-danger">Please enter a correct email address.</small> --></div>
            <div class="form-group"><textarea class="form-control" name="message" placeholder="Message" rows="14" value="${contactForm.message}"></textarea><form:errors path="message" cssClass="error"/> </div>
            <div class="form-group"><button class="btn btn-primary" type="submit">send </button>
                <hr>
            </div>
            <div class="form-row" style="padding: 0px;">
                <div class="col-2 align-self-center"><i class="fa fa-phone-square" style="font-size: 32px;color: rgb(61,134,220);"></i></div>
                <div class="col text-left align-self-center" style="padding: 0px;">
                    <p style="font-size: 16px;">9841008735<br>9841363614<br></p>
                </div>
            </div>
            <h5 style="font-size: 15px;color:green">${msg}</h5>
        </form:form>
    </div>
</body>

</html>
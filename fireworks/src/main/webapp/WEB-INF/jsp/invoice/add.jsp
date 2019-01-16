<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<title>jQuery Add / Remove Table Rows</title>
<style type="text/css">
    table{
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }
    table, th, td{
        border: 1px solid #cdcdcd;
    }
    table th, table td{
        padding: 5px;
        text-align: left;
    }
</style>

<script type="text/javascript">

    $(document).ready(function(){
    	
    	//if the records in the table is empty then the lineItemsCount = -1. already there is one <tr> in this table.  To balance it even with Edit functionality (-2 i set up). 
    	var lineItemsCount = $('#listInvoicesTable tr').length - 2;
        $(".add-row").click(function(){
        	lineItemsCount ++;
            var productId = $("#productName").val();
            var productName = $("#productName option:selected").text();
            var quantity = $("#quantity").val();
            var price = $("#price").val();

            var markup = "<tr><td><input type='checkbox' name='record'><input type = 'hidden' name='invoiceLineItems["+lineItemsCount+"].productId' value="+productId+" /> <input type = 'hidden' name='invoiceLineItems["+lineItemsCount+"].quantity' value="+quantity+" /><input type = 'hidden' name='invoiceLineItems["+lineItemsCount+"].price' value="+price+" /></td>"+
            "<td>" + productName + "</td><td>" + quantity + "</td><td>"+price+"</td> </tr>";
            
            $("table tbody").append(markup);
            calculateColumn(3);
        });
        
        // Find and remove selected table rows
        $(".delete-row").click(function(){
            $("table tbody").find('input[name="record"]').each(function(){
                if($(this).is(":checked")){
                    $(this).parents("tr").remove();
                }
            });
            calculateColumn(3);
        });
        
    });   
    
    function calculateColumn(index)
    {
    var total = 0;
    $('table tr').each(function()
    {
    var value = parseFloat($('td', this).eq(index).text());
    if (!isNaN(value))
    {
    total += value;
    }
    }); 
    $('#totalPrice').val(total);
    }
</script>
</head>
<body>
<div class="container">
<h1>Add Invoice</h1>
		<h4>${msg}</h4>
		<h4>${error}</h4>
		<spring:url value="/invoice/save" var="saveUrl" />
		
    <form:form method="post" action="${saveUrl}" modelAttribute="invoice">
    	<label for="bill date">Bill Date : </label><input name = "billDate"  type="date" value="2019-01-01">
    	<label for="bill date">Bill No : </label> <input type="text" name = "billNo">  
    	
    	<br><br>
    	
  
  	<label for="Product Name">Product Name : </label>
		<select id ="productName" >
		<option value = "NONE" label = "Select"/>
		<c:forEach var="item" items="${productList}">
			<option value ="${item.id}">${item.name}</option>
		</c:forEach>
		</select>
    	
    	<label for="Quantity">Quantity : </label>
        <input type="text" id="quantity" placeholder="Quantity">
        
        <label for="Price">Price : </label>
        <input type="text" id="price" placeholder="Price">
        
        <input type="button" class="add-row" value="Add Row"> 
                
    
    <table width="100" id ="listInvoicesTable">
        <thead>
            <tr>
                <th>Select</th>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>
    <label for="Total">Total : </label> <input type="text" name = "totalPrice" readonly="readonly" id="totalPrice">
    <label for="ActualPrice">Buying Price: </label> <input type="text" name = "buyPrice">
    <br>
    <br>
    
      
    <button type="button" class="delete-row">Delete Row</button> <input type = "submit" value = "Generate Invoice"/>
    </form:form>
    </div>
</body> 
</html>
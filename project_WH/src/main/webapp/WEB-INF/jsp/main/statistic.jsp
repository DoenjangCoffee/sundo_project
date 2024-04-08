<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Swal -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<!--Load the AJAX API-->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
	$(function(){
		google.charts.load('current', {'packages':['bar']});
		google.charts.setOnLoadCallback(drawChart);

		function drawChart() {
		  var data = google.visualization.arrayToDataTable([
		    ['Year', 'Sales', 'Expenses', 'Profit'],
		    ['2014', 1000, 400, 200],
		    ['2015', 1170, 460, 250],
		    ['2016', 660, 1120, 300],
		    ['2017', 1030, 540, 350]
		  ]);

		  var options = {
		    chart: {
		      title: 'Company Performance',
		      subtitle: 'Sales, Expenses, and Profit: 2014-2017',
		    },
		    bars: 'horizontal' // Required for Material Bar Charts.
		  };

		  var chart = new google.charts.Bar(document.getElementById('barchart_material'));

		  chart.draw(data, google.charts.Bar.convertOptions(options));
		}
		$("#search").click(function(){
			let sd = $("#sido").val();
			if (sd == "시/도 선택") {
				Swal.fire({
					title: '시/도를 선택해주세요.',
					icon: 'warning'
				}); // swal end
				}else{
					Swal.fire({
						title: '시/도 코드 : '+sd,
						icon: 'success'
					}); // swal end
				}
			});  
		});
</script>
<body>
   	 <select id="sido" name="sido" class="form-select mb-2">
   			<option>시/도 선택</option>
   		<c:forEach items="${si }" var="e">
			<option id="si" value="${e.sd_cd }">${e.sd_nm}</option>
		</c:forEach>
	</select>
	<button class="btn btn-primary" type="button" style="width:100% " id="search">검색</button>
<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">검색</button>




<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<div id="barchart_material" style="width: 200px; height: 300px;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</body>
</html>
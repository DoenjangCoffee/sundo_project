<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.springframework.core.io.support.PropertiesLoaderUtils" %>
<%@ page import="java.util.Properties" %>
<%
   // 프로퍼티 파일에서 API 키를 읽어옴
   Properties properties = PropertiesLoaderUtils.loadAllProperties("property/globals.properties");
   String apiKey = properties.getProperty("Globals.apiKey");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>메인 파일</title>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 지도 -->
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<!-- bootstarp -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<style type="text/css">
#menu:hover {
background-color: burlywood; /* 배경색 변경 */
color: #333; /* 글자색 변경 */
}
#menu{
cursor:pointer;
}
a{
	color:black;
	text-decoration: none;
}
</style>

<script type="text/javascript">
let map;

$(document).ready(function(){

    	map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
        target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
        layers: [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
            new ol.layer.Tile({
                source: new ol.source.OSM({
                    url: 'http://api.vworld.kr/req/wmts/1.0.0/<%=apiKey%>/Base/{z}/{y}/{x}.png' 
                        // vworld의 지도를 가져온다.
                })
            })
        ],
        view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
            center: ol.proj.fromLonLat([128, 36]),
            zoom: 8
        })
    });
    	
		$("#upLoad").click(function(e){
			e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
			
			$.ajax({
				type:'get',
				url : '/upLoad.do',
				dataType:'html',
				success:function(response){
					$("#views").html(response);
				},
				error:function(error){
					alert("업로드 페이지 불러오기 오류");
				}
			});
		});
		
		$("#statistic").click(function(e){
			e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
			
			$.ajax({
				type:'get',
				url : '/statistic.do',
				dataType:'html',
				success:function(response){
					$("#views").html(response);
				},
				error:function(error){
					alert("통계 페이지 불러오기 오류");
				}
		});
	});
		
		$("#cMap").click(function(e){
			e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
			
			$.ajax({
				type:'get',
				url : '/cMap.do',
				dataType:'html',
				success:function(response){
					$("#views").html(response);
				},
				error:function(error){
					alert("탄소지도 페이지 불러오기 오류");
				}
			});
		});	
});

function updateSido(sido){
	wms.getSource().updateParams({'CQL_Filter': "sd_cd='" + sido + "'"});
}
</script>
</head>
<body>
<header class="bg-primary text-light py-3 ">
  <div class="container text-center">
    Header
  </div>
</header>
<div class="container-fluid d-flex flex-column m-3" style="height: 100%;">
    <div class="row flex-grow-1">
        <div class="col-md-4 d-flex flex-column">
            <div class="row">
                <div class="col-md-12 border border-dark">
                    <div class="text-center bold fs-4" style="height: 50px;">탄소 공간지도 시스템</div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 border border-dark border-end-0 border-top-0 p-0">
                    <div>
                        <div class="align-middle border-bottom border-dark py-2" id="menu">
                            <a id="cMap" class="m-3 p-2"><i class="bi bi-geo-alt fs-5 pe-1"></i>탄소지도</a>
                        </div>
                        <div class="align-middle border-bottom border-dark py-2" id="menu">
                            <a id="upLoad" class="m-3 p-1"><i class="bi bi-upload fs-5 pe-1"></i>데이터 삽입</a>
                        </div>
                        <div class="align-middle border-bottom border-dark py-2" id="menu">
                            <a id="statistic" class="m-3 p-2"><i class="bi bi-bar-chart-line fs-5 pe-1"></i>통계</a>
                        </div>
                    </div>
                </div>
                <div id = "views" class="col-md-9 p-3 fs-4 bold border border-dark border-top-0" style="height: 915.5px;">
					메뉴를 선택해주세요
                </div>
            </div>
        </div>
        <div class="col-md-8 p-0">
            <div id="map" style="height: 966px"></div>
        </div>
    </div>
</div>

<footer class="footer mt-auto py-2 bg-dark text-light">
  <div class="container text-center">
    <p>&copy; 2024 Your Website</p>
  </div>
</footer>
</body>
</html>
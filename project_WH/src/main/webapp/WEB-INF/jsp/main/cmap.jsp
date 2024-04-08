<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- bootstarp -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<!-- Swal -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<!-- ol.-ext 라이브러리 추가 -->
<link rel="stylesheet" href="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.css" />
<script src="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.js"></script>
<style type="text/css">
a{
	color:black;
	text-decoration: none;
}
#legendImg {
    display: block;
    margin: auto;
    border: 1px solid #ccc;
    padding: 5px;
    position: absolute;
    top: 10px; /* 적절한 위치로 조정하세요 */
    left: 10px; /* 적절한 위치로 조정하세요 */
    z-index: 1000; /* 맵 위에 올려서 다른 요소보다 앞에 표시됩니다 */
}

.legend-container {
    position: absolute;
    top: 100px; /* 맵 상단으로부터의 거리를 조절합니다. */
    left: 700px; /* 맵 왼쪽으로부터의 거리를 조절합니다. */
    z-index: 1000; /* 다른 요소 위에 표시되도록 z-index 설정합니다. */
    opacity : 0.8;
}
</style>
</head>
<script type="text/javascript">
var wms;
var sgg;
var sido;
var gu;
var xgeom;
var ygeom;
var sidoCenter;
var index;
var legendUrl;
$(document).ready(function(){
	
	
    $("#sido").change(function(){
        var datas = $(this).val(); //value값 가져오기
        var values = datas.split(",");
        sido = values[0]; // 시 코드
        xgeom = values[1]; // x좌표
        ygeom = values[2]; // y좌표
        gu=null; // 시/군/구 코드 초기화
        index=null;
        
        $("#index").val("범례 선택");
        
        $.ajax({
            type: 'POST',//데이터 전송 타입,
            url : '/ggTest.do',//데이터를 주고받을 파일 주소 입력,
            data: {'sido':sido},//보내는 데이터,
            dataType:'text',//문자형식으로 받기 ,
            success:function(data){
                    var sgg = JSON.parse(data);
                    //alert(JSON.stringify(sgg));
                    var sggSelect = $("#gugun");
                    sggSelect.html("<option>시/군/구 선택</option>");
                    for(var i = 0; i < sgg.length; i++) {
                        var item = sgg[i];
                        
                        sggSelect.append("<option value='" + item.sgg_cd + "'>" + item.sgg_nm + "</option>");
                    }
            },
            error:function(request,status,error){  
                alert(("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error));
            }
        });
    });
    
    $("#gugun").change(function(){
        gu = $(this).val();
        removeLegend();
        
        index = null;
        $("#index").val("범례 선택");

        $.ajax({
            type: 'POST',//데이터 전송 타입,
            url : '/bjdTest.do',//데이터를 주고받을 파일 주소 입력,
            data: {'gu':gu},//보내는 데이터,
            dataType:'json',//문자형식으로 받기 ,
            success:function(data){
                //alert(data);
                var bjdSelect = $("#dong");
                bjdSelect.html("<option>--덩 선택해주세요--</option>");
                for (var i = 0; i < data.length; i++) {
                    var bb = data[i];
                    bjdSelect.append("<option>"+bb.bjd_nm+"</option>");
                }
            },
            error:function(error){
                alert("동 통신 오류");
            }
        });
    });
    
    $("#index").change(function(){
    	index = $(this).val();
    });
    
    $("#search").click(function(){
    	
    	map.removeLayer(wms); // 시도 레이어 제거
        map.removeLayer(sgg); // 시군구 레이어 제거
         	
        if (sido == "시/도 선택" || sido == null) {
			Swal.fire({
				   title: '시/도를 선택해주세요.',
				   icon: 'error',
			}); // swal end
			return; // 함수 종료.
		} // if end

 		if (index == "범례 선택" || index == null) {
			Swal.fire({
				   title: '범례를 선택해주세요.',
				   icon: 'error',
			}); // swal end
			return; // 함수 종료.
		} // if end
		
		
         if (index == "ei") { // 범례 등간격 선택 시 

        	 // 좌표 이동        	 
     		sidoCenter = ol.proj.fromLonLat([xgeom, ygeom]);
            map.getView().setCenter(sidoCenter);
            if (sido == 42 || sido == 46) {
           	map.getView().setZoom(9);
    		} else {
    			map.getView().setZoom(10);
    		}   
			
            // 등간격 범례 레이어 추가하기
            
             // 시/군 레이어 [등간격]
             wms = new ol.layer.Tile({
                 source : new ol.source.TileWMS({
                     url : 'http://localhost:8080/geoserver/cite/wms', // 1. 레이어 URL
                     params : {
                         'VERSION' : '1.1.0', // 2. 버전
                         'LAYERS' : 'cite :eq_sggview', // 3. 작업공간:레이어 명
                         'CQL_Filter': "sgg_cd LIKE'" +sido + "%'",
                         'BBOX' : ['13868720', '3906626.5', '14428071', '4670269.5'], 
                         'SRS' : 'EPSG:3857', // SRID
                         'FORMAT' : 'image/png' // 포맷
                     },
                     serverType : 'geoserver',
                 })
             });
             map.addLayer(wms);
             
              // 시/군/구 레이어 [등간격]
              if (gu != null) {
            	map.removeLayer(wms);
            	
        		wms = new ol.layer.Tile({
                    visible:true,
                    source : new ol.source.TileWMS({
                      url : 'http://localhost:8080/geoserver/cite/wms',
                      params : {
                        'version' : '1.1.0',
                        'request' : 'GetMap',
                        'layers' : 'cite:empty_sd',
                        'CQL_Filter': "sd_cd='" +sido + "'",
                        'bbox' : ['1.3867446E7', '3906626.5', '1.4684055E7', '4670269.5'],
                        'srs' : 'EPSG:3857',
                        'format' : 'image/png'
                      },
                      serverType : 'geoserver',
                    })
                  });

            	map.addLayer(wms);
            	
        		sgg = new ol.layer.Tile({
                 visible:true,
                 source : new ol.source.TileWMS({
                   url : 'http://localhost:8080/geoserver/cite/wms',
                   params : {
                     'version' : '1.1.0',
                     'request' : 'GetMap',
                     'layers' : 'cite:eq_bjdview',
                     'CQL_Filter' : "bjd_cd LIKE'"+gu+"%'",
                     'bbox' : ['1.386872', '3906626.5', '1.4428071', '4670269.5'],
                     'width' : '562',
                     'height' : '768',
                     'srs' : 'EPSG:3857',
                     'format' : 'image/png'
                   },
                   serverType : 'geoserver',
                 })
               });
              map.addLayer(sgg);
			}
		}
        
        if (index == "nb") { // natrual break 범례 선택 시
        	removeLegend();
        	// 좌표 이동 
        	sidoCenter = ol.proj.fromLonLat([xgeom, ygeom]);
            map.getView().setCenter(sidoCenter);
            
            if (sido == 42 || sido == 46) {
           	map.getView().setZoom(9);
    		} else {
    			map.getView().setZoom(10);
    		}
            
        	// natural break 범례 레이어 추가하기
        	wms = new ol.layer.Tile({
                source : new ol.source.TileWMS({
                    url : 'http://localhost:8080/geoserver/cite/wms', // 1. 레이어 URL
                    params : {
                        'VERSION' : '1.1.0', // 2. 버전
                        'LAYERS' : 'cite :nb_sggview', // 3. 작업공간:레이어 명
                        'CQL_Filter': "sgg_cd LIKE'" +sido + "%'",
                        'BBOX' : ['1.386872E7', '3906626.5', '1.4428071E7', '4670269.5'], 
                        'SRS' : 'EPSG:3857', // SRID
                        'FORMAT' : 'image/png' // 포맷
                    },
                    serverType : 'geoserver',
                })
            });
        	 map.addLayer(wms);
             legendUrl = 'http://localhost:8080/geoserver/cite/wms?' +
 			'service=WMS' +
 			'&VERSION=1.0.0' +
 			'&REQUEST=GetLegendGraphic' +
 			'&LAYER=cite:nb_sggview' +
 			'&FORMAT=image/png' +
 			'&WIDTH=80' +
 			'&HEIGHT=20';
 			addLegend(legendUrl);
 			
        	if (gu != null || gu == "시/군/구 선택") {
         	map.removeLayer(wms);
         	removeLegend();
         	
    		wms = new ol.layer.Tile({
                visible:true,
                source : new ol.source.TileWMS({
                  url : 'http://localhost:8080/geoserver/cite/wms',
                  params : {
                    'version' : '1.1.0',
                    'request' : 'GetMap',
                    'layers' : 'cite:empty_sd',
                    'CQL_Filter': "sd_cd='" +sido + "'",
                    'bbox' : ['1.3867446E7', '3906626.5', '1.4684055E7', '4670269.5'],
                    'srs' : 'EPSG:3857',
                    'format' : 'image/png'
                  },
                  serverType : 'geoserver',
                })
              });

        	map.addLayer(wms);
        	
    		sgg = new ol.layer.Tile({
             visible:true,
             source : new ol.source.TileWMS({
               url : 'http://localhost:8080/geoserver/cite/wms',
               params : {
                 'version' : '1.1.0',
                 'request' : 'GetMap',
                 'layers' : 'cite:nb_bjdview',
                 'CQL_Filter' : "bjd_cd LIKE'"+gu+"%'",
                 'bbox' : ['1.386872', '3906626.5', '1.4428071', '4670269.5'],
                 'width' : '562',
                 'height' : '768',
                 'srs' : 'EPSG:3857',
                 'format' : 'image/png'
               },
               serverType : 'geoserver',
             })
           });
          map.addLayer(sgg);
          legendUrl = 'http://localhost:8080/geoserver/cite/wms?' +
			'service=WMS' +
			'&VERSION=1.0.0' +
			'&REQUEST=GetLegendGraphic' +
			'&LAYER=cite:nb_bjdview' +
			'&FORMAT=image/png' +
			'&WIDTH=80' +
			'&HEIGHT=20';
			addLegend(legendUrl);
        }
       }
    });
});

//범례 테이블 만들어 주는 함수.
function addLegend(legendUrl){
    // 범례 컨테이너를 생성합니다.
    var legendContainer = document.createElement('div');
    legendContainer.className = 'legend-container';
    // 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
    map.getTargetElement().appendChild(legendContainer);

    // 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
    var legendImg = document.createElement('img');
    legendImg.src = legendUrl;
    // 범례 이미지를 범례 컨테이너에 추가합니다.
    legendContainer.appendChild(legendImg)
}

//범례 제거 함수 정의
function removeLegend() {
    var legendContainer = document.querySelector('.legend-container');
    if (legendContainer) {
        legendContainer.parentNode.removeChild(legendContainer);
    }
}
</script>
<body>
   	 <select id="sido" name="sido" class="form-select mb-2">
   			<option>시/도 선택</option>
   		<c:forEach items="${si }" var="e">
			<option id="si" value="${e.sd_cd},${e.xgeom},${e.ygeom}">${e.sd_nm}</option>
		</c:forEach>
	</select>
		
	<select id="gugun" name="gugun" class="form-select mb-2">
		<option>시/군/구 선택</option>
	</select>
	
	<select id="index" class="form-select mb-2">
		<option>범례 선택</option>
		<option id="ei" value="ei">등간격</option>
		<option id="nb" value="nb">Natural Break</option>
	</select>
	
	<button class="btn btn-primary" type="button" style="width:100% " id="search">검색</button>
</body>
</html>
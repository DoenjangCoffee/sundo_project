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
</head>
<script type="text/javascript">
let wms;
let sgg;
$(document).ready(function(){

    $("#sido").change(function(){
        map.removeLayer(wms);
        map.removeLayer(sgg);
        var datas = $(this).val(); //value값 가져오기
        var values = datas.split(",");
        var sido = values[0]; // 시 코드
        var xgeom = values[1]; // x좌표
        var ygeom = values[2]; // y좌표
        
		var sidoCenter = ol.proj.fromLonLat([xgeom, ygeom]);
        //alert(sido);
        map.getView().setCenter(sidoCenter);
          if (sido == 42 || sido == 46) {
        	map.getView().setZoom(9);
		} else {
			map.getView().setZoom(10);
		}      
         
        $.ajax({
            type: 'POST',//데이터 전송 타입,
            url : '/ggTest.do',//데이터를 주고받을 파일 주소 입력,
            data: {'sido':sido},//보내는 데이터,
            dataType:'text',//문자형식으로 받기 ,
            success:function(data){
                    var sgg = JSON.parse(data);
                    //alert(JSON.stringify(sgg));
                    var sggSelect = $("#gugun");
                    sggSelect.html("<option>--시/군/구를 선택하세요--</option>");
                    for(var i = 0; i < sgg.length; i++) {
                        var item = sgg[i];
                        
                        sggSelect.append("<option value='" + item.sgg_cd + "'>" + item.sgg_nm + "</option>");
                    }
            },
            error:function(request,status,error){  
                alert(("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error));
            }
        });
        
        wms = new ol.layer.Tile({
            source : new ol.source.TileWMS({
                url : 'http://localhost:8080/geoserver/cite/wms', // 1. 레이어 URL
                params : {
                    'VERSION' : '1.1.0', // 2. 버전
                    'LAYERS' : 'cite :tl_sd', // 3. 작업공간:레이어 명
                    'CQL_Filter': "sd_cd='" +sido + "'",
                    'BBOX' : ['1.3873946', '3906626.5', '1.4428045', '4670269.5'], 
                    'SRS' : 'EPSG:3857', // SRID
                    'FORMAT' : 'image/png' // 포맷
                },
                serverType : 'geoserver',
            })
        });
        
        map.addLayer(wms); // 레이어 추가하기  
    });
    
    $("#gugun").change(function(){
    	 map.removeLayer(sgg);
        var gu = $(this).val();
        //alert(gu);
        // tl_sgg layer추가
        sgg = new ol.layer.Tile({
        visible:true,
        source : new ol.source.TileWMS({
          url : 'http://localhost:8080/geoserver/cite/wms',
          params : {
            'version' : '1.1.0',
            'request' : 'GetMap',
            'layers' : 'cite :tl_sgg',
            'CQL_Filter' : "sgg_cd='"+gu+"'",
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
});
</script>
<body>
   	 <select id="sido" name="sido" class="form-select">
		<option>시/도 선택</option>
   		<c:forEach items="${si }" var="e">
			<option id="si" value="${e.sd_cd },${e.xgeom},${e.ygeom}">${e.sd_nm}</option>
		</c:forEach>
	</select>
		
	<select id="gugun" name="gugun" class="form-select">
		<option>--시/군/구를 선택하세요--</option>
	</select>
</body>
</html>
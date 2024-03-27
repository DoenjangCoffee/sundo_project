<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>테스트</title>
<link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
<script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</head>
<body>

<header class="bg-primary text-light py-3 ">
  <div class="container text-center">
    여기는 헤더 입니다.
  </div>
</header>

<div class="container-fluid d-flex flex-column" style="height: 100%;">
    <div class="row flex-grow-1">
        <div class="col-md-4 d-flex flex-column">
            <div class="row">
                <div class="col-md-12 bg-warning">
                    <div class="text-center" style="height: 50px;">탄소 공간지도 시스템</div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 bg-danger" style="height: 915.5px;">
                    <ul class="nav">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">탄소지도</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">업로드</a>
                        </li>
                        <li class="nav-item">
                        </li>
                        <li class="nav-item">
                            <a class="nav-link disabled" href="#">통계</a>
                        </li>
                    </ul>
                </div>
                <div class="col-md-9 bg-info">
                    메뉴 실행될 화면
                </div>
            </div>
        </div>
        <div class="col-md-8 p-0">
            <div id="map" style="height: 965.5px"></div>
        </div>
    </div>
</div>


<footer class="footer mt-auto py-2 bg-dark text-light">
  <div class="container text-center">
    <p>&copy; 2024 Your Website</p>
  </div>
</footer>




 
    <script>
      
      //tl_bjd layer추가
      var wmsLayer = new ol.layer.Tile({
        visible:true,
        source : new ol.source.TileWMS({
          url : 'http://localhost:8080/geoserver/cite/wms',
          params : {
            'version' : '1.1.0',
            'request' : 'GetMap',
            'layers' : 'cite :tl_bjd',
            'bbox' : ['1.3873946', '3906626.5', '1.4428045', '4670269.5'],
            'width' : '557',
            'height' : '768',
            'srs' : 'EPSG:3857',
            'format' : 'image/png'
          },
          serverType : 'geoserver',
        })
      });
      
      // tl_sgg layer추가
        var sggLayer = new ol.layer.Tile({
        visible:true,
        source : new ol.source.TileWMS({
          url : 'http://localhost:8080/geoserver/cite/wms',
          params : {
            'version' : '1.1.0',
            'request' : 'GetMap',
            'layers' : 'cite :tl_sgg',
            'bbox' : ['1.386872', '3906626.5', '1.4428071', '4670269.5'],
            'width' : '562',
            'height' : '768',
            'srs' : 'EPSG:3857',
            'format' : 'image/png'
          },
          serverType : 'geoserver',
        })
      });
      
      // tl_sd layer추가
        var sdLayer = new ol.layer.Tile({
        visible:true,
        source : new ol.source.TileWMS({
          url : 'http://localhost:8080/geoserver/cite/wms',
          params : {
            'version' : '1.1.0',
            'request' : 'GetMap',
            'layers' : 'cite :tl_sd',
            'bbox' : ['1.3871489341071218', '3910407.083927817', '1.4680011171788167', '4666488.829376997'],
            'width' : '768',
            'height' : '718',
            'srs' : 'EPSG:3857',
            'format' : 'image/png'
          },
          serverType : 'geoserver',
        })
      });
      //지도
      var map = new ol.Map({
          target: 'map',
          layers: [
            new ol.layer.Tile({source: new ol.source.OSM()}),
            
          ],
          view: new ol.View({
              projection: 'EPSG:900913',
              center: ol.proj.fromLonLat([127, 37.5]),
              zoom: 10
          })
      });
      map.addLayer(sdLayer);
      map.addLayer(sggLayer);	
      map.addLayer(wmsLayer);
    </script>
  </body>
</html>

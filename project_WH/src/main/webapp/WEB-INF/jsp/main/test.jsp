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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<link rel="stylesheet" href="node_modules/ol/ol.css">

<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<style>
      .map {
        width: 100%;
        height: 400px;
      }
      .ol-popup {
        position: absolute;
        background-color: white;
        box-shadow: 0 1px 4px rgba(0,0,0,0.2);
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #cccccc;
        bottom: 12px;
        left: -50px;
        min-width: 280px;
      }
      .ol-popup:after, .ol-popup:before {
        top: 100%;
        border: solid transparent;
        content: " ";
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
      }
      .ol-popup:after {
        border-top-color: white;
        border-width: 10px;
        left: 48px;
        margin-left: -10px;
      }
      .ol-popup:before {
        border-top-color: #cccccc;
        border-width: 11px;
        left: 48px;
        margin-left: -11px;
      }
      .ol-popup-closer {
        text-decoration: none;
        position: absolute;
        top: 2px;
        right: 8px;
      }
      .ol-popup-closer:after {
        content: "✖";
      }
</style>
</head>
<body>
<header class="bg-primary text-light py-3 ">
  <div class="container text-center">
    여기는 헤더 입니다.
  </div>
</header>

    <div id="map" class="map"></div>
    <button id="test">버튼</button>

<script type="text/javascript">
$(function(){

	const apiKey = '65E6A1CF-4AC0-3634-BE90-1B3D4EC69C81'; // 여기에 vworld에서 발급받은 API 키를 입력하세요.
	const attributions =
	  '<a href="http://vworld.kr/" target="_blank">© VWORLD</a>';

	/**
	 * Create the map.
	 */
	const map = new ol.Map({
	  layers: [
	    new ol.layer.Tile({
	      source: new ol.source.XYZ({
	        attributions: attributions,
	        url: 'https://api.vworld.kr/req/wmts/1.0.0/' + apiKey + '/default/gg/{z}/{y}/{x}.png'
	      }),
	    }),
	  ],
	  overlays: [overlay],
	  target: 'map',
	  view: new ol.View({
	    center: ol.proj.fromLonLat([126.978388, 37.566609]), // 서울 좌표로 지도 초기화
	    zoom: 10,
	  }),
	});
	
});
	
</script>

<footer class="footer mt-auto py-2 bg-dark text-light">
  <div class="container text-center">
    <p>&copy; 2024 Your Website</p>
  </div>
</footer>
</body>
</html>

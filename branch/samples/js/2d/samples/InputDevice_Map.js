(function()
{
	var Stage       = Laya.Stage;
	var Text        = Laya.Text;
	var Geolocation = Laya.Geolocation;
	var Position    = Laya.Position;
	var Browser     = Laya.Browser;
	var Handler     = Laya.Handler;

	// 百度地图
	var map;
	var marker;
	var BMap = Browser.window.BMap;
	var convertor = new BMap.Convertor();
	
	// Div
	var mapDiv;
	
	var infoText;
	(function()
	{
		Laya.init(Browser.width, 255);
		Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
		
		createDom();
		initMap();
		createInfoText();
		
		var successHandler = new Handler(this, updatePosition);
		var errorHandler = new Handler(this, onError);
		
		// 使用高精度位置
		Geolocation.enableHighAccuracy = true;
		Geolocation.watchPosition(successHandler, errorHandler);
		
		// 绑定作用域
		convertToBaiduCoord = convertToBaiduCoord.bind(this);
	 })();
	function createDom() 
	{
		mapDiv = Browser.createElement("div");

		var style = mapDiv.style;
		style.position = "absolute";
		style.top = Laya.stage.height / Browser.pixelRatio + "px";
		style.left = "0px";
		style.width = Browser.width / Browser.pixelRatio + "px";
		style.height = (Browser.height - Laya.stage.height) / Browser.pixelRatio + "px";
		
		Browser.document.body.appendChild(mapDiv);
	}
		
	function initMap() 
	{
		// 初始化地图
		map = new BMap.Map(mapDiv);
		
		// 禁用部分交互
		//map.disableDragging();
		map.disableKeyboard();
		map.disableScrollWheelZoom();
		map.disableDoubleClickZoom();
		map.disablePinchToZoom();
		// 初始地点北京，缩放系数15
		map.centerAndZoom(new BMap.Point(116.32715863448607, 39.990912172420714), 15); 
		
		// 创建标注物
		marker = new BMap.Marker(new BMap.Point(0,0));
		map.addOverlay(marker);
		var label = new BMap.Label("当前位置", { offset: new BMap.Size(-15, 30) });
		marker.setLabel(label);
	}
	function createInfoText()
	{
		infoText = new Text();
		Laya.stage.addChild(infoText);
		infoText.fontSize = 50;
		infoText.color = "#FFFFFF";
		infoText.size(Laya.stage.width, Laya.stage.height);
	}
		
	// 更新设备位置
	function updatePosition(p) 
	{
		// 转换为百度地图坐标
		var point = new BMap.Point(p.longitude, p.latitude);
		// 把原始坐标转换为百度坐标，部分设备可能获取到的是谷歌坐标，这时第三个参数改为3才是正确的。
		convertor.translate([point], 1, 5, convertToBaiduCoord);
		
		// 更新当前获取到的地理信息
		infoText.text = 
			"经度：" + p.longitude + 
			"\t纬度：" + p.latitude + 
			"\t精度：" + p.accuracy +
			
			"\n海拔：" + p.altitude +
			"\t海拔精度：" + p.altitudeAccuracy +
			
			"\n头：" + p.heading +
			"\n速度：" + p.speed +
			"\n时间戳：" + p.timestamp;
	}
		
	// 将原始坐标转换为百度坐标
	function convertToBaiduCoord(data)
	{
		if (data.status == 0)
		{
			var position = data.points[0];
			// 设置标注物位置
			marker.setPosition(position);
			
			map.panTo(position);
			map.setZoom(17);
		}
	}
		
	function onError(e) 
	{
		if (e.code == Geolocation.TIMEOUT)
			alert("获取位置超时");
		else if (e.code == Geolocation.POSITION_UNAVAILABLE)
			alert("位置不可用");
		else if (e.code == Geolocation.PERMISSION_DENIED)
			alert("无权限");
	}
})();
	
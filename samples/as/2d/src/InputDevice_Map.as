package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.device.geolocation.Geolocation;
	import laya.device.geolocation.GeolocationInfo;
	import laya.utils.Browser;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author Survivor
	 */
	public class InputDevice_Map 
	{
		// 百度地图
		private var map:*;
		private var marker:*;
		private var BMap:* = Browser.window.BMap;
		private var convertor:* = new BMap.Convertor();
		
		// Div
		private var mapDiv:*;
		
		private var infoText:Text;
		
		public function InputDevice_Map() 
		{
			Laya.init(Browser.width, 255);
			Laya.stage.scaleMode = Stage.SCALE_NOSCALE;
			
			createDom();
			initMap();
			createInfoText();
			
			var successHandler:Handler = new Handler(this, updatePosition);
			var errorHandler:Handler = new Handler(this, onError);
			
			// 使用高精度位置
			Geolocation.enableHighAccuracy = true;
			Geolocation.watchPosition(successHandler, errorHandler);
			
			// 绑定作用域
			__JS__("this.convertToBaiduCoord = this.convertToBaiduCoord.bind(this)");
		}
		
		private function createDom():void 
		{
			mapDiv = Browser.createElement("div");

			var style:* = mapDiv.style;
			style.position = "absolute";
			style.top = Laya.stage.height / Browser.pixelRatio + "px";
			style.left = "0px";
			style.width = Browser.width / Browser.pixelRatio + "px";
			style.height = (Browser.height - Laya.stage.height) / Browser.pixelRatio + "px";
			
			Browser.document.body.appendChild(mapDiv);
		}
		
		private function initMap():void 
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
			var label:* = new BMap.Label("当前位置", { offset: new BMap.Size(-15, 30) });
			marker.setLabel(label);
		}
		
		private function createInfoText():void
		{
			infoText = new Text();
			Laya.stage.addChild(infoText);
			infoText.fontSize = 50;
			infoText.color = "#FFFFFF";
			infoText.size(Laya.stage.width, Laya.stage.height);
		}
		
		// 更新设备位置
		private function updatePosition(p:GeolocationInfo):void 
		{
			// 转换为百度地图坐标
			var point:* = new BMap.Point(p.longitude, p.latitude);
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
		private function convertToBaiduCoord(data:*):void
		{
			if (data.status == 0)
			{
				var position:* = data.points[0];
				// 设置标注物位置
				marker.setPosition(position);
				
				map.panTo(position);
				map.setZoom(17);
			}
		}
		
		private function onError(e:*):void 
		{
			if (e.code == Geolocation.TIMEOUT)
				alert("获取位置超时");
			else if (e.code == Geolocation.POSITION_UNAVAILABLE)
				alert("位置不可用");
			else if (e.code == Geolocation.PERMISSION_DENIED)
				alert("无权限");
		}
		
	}

}
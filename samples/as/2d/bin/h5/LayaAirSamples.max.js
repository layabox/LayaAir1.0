
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Geolocation=laya.device.geolocation.Geolocation,GeolocationInfo=laya.device.geolocation.GeolocationInfo;
	var Handler=laya.utils.Handler,Stage=laya.display.Stage,Text=laya.display.Text;
	/**
	*...
	*@author Survivor
	*/
	//class InputDevice_Map
	var InputDevice_Map=(function(){
		function InputDevice_Map(){
			this.map=null;
			this.marker=null;
			this.mapDiv=null;
			this.infoText=null;
			this.BMap=Browser.window.BMap;
			this.convertor=new this.BMap.Convertor();
			Laya.init(Browser.width,255);
			Laya.stage.scaleMode="noscale";
			this.createDom();
			this.initMap();
			this.createInfoText();
			var successHandler=new Handler(this,this.updatePosition);
			var errorHandler=new Handler(this,this.onError);
			Geolocation.enableHighAccuracy=true;
			Geolocation.watchPosition(successHandler,errorHandler);
			this.convertToBaiduCoord=this.convertToBaiduCoord.bind(this);
		}

		__class(InputDevice_Map,'InputDevice_Map');
		var __proto=InputDevice_Map.prototype;
		__proto.createDom=function(){
			this.mapDiv=Browser.createElement("div");
			var style=this.mapDiv.style;
			style.position="absolute";
			style.top=Laya.stage.height / Browser.pixelRatio+"px";
			style.left="0px";
			style.width=Browser.width / Browser.pixelRatio+"px";
			style.height=(Browser.height-Laya.stage.height)/ Browser.pixelRatio+"px";
			Browser.document.body.appendChild(this.mapDiv);
		}

		__proto.initMap=function(){
			this.map=new this.BMap.Map(this.mapDiv);
			this.map.disableKeyboard();
			this.map.disableScrollWheelZoom();
			this.map.disableDoubleClickZoom();
			this.map.disablePinchToZoom();
			this.map.centerAndZoom(new this.BMap.Point(116.32715863448607,39.990912172420714),15);
			this.marker=new this.BMap.Marker(new this.BMap.Point(0,0));
			this.map.addOverlay(this.marker);
			var label=new this.BMap.Label("当前位置",{offset:new this.BMap.Size(-15,30)});
			this.marker.setLabel(label);
		}

		__proto.createInfoText=function(){
			this.infoText=new Text();
			Laya.stage.addChild(this.infoText);
			this.infoText.fontSize=50;
			this.infoText.color="#FFFFFF";
			this.infoText.size(Laya.stage.width,Laya.stage.height);
		}

		// 更新设备位置
		__proto.updatePosition=function(p){
			var point=new this.BMap.Point(p.longitude,p.latitude);
			this.convertor.translate([point],3,5,this.convertToBaiduCoord);
			this.infoText.text=
			"经度："+p.longitude+
			"\t纬度："+p.latitude+
			"\t精度："+p.accuracy+
			"\n海拔："+p.altitude+
			"\t海拔精度："+p.altitudeAccuracy+
			"\n头："+p.heading+
			"\n速度："+p.speed+
			"\n时间戳："+p.timestamp;
		}

		// 将原始坐标转换为百度坐标
		__proto.convertToBaiduCoord=function(data){
			if (data.status==0){
				var position=data.points[0];
				this.marker.setPosition(position);
				this.map.panTo(position);
				this.map.setZoom(17);
			}
		}

		__proto.onError=function(e){
			if (e.code==3)
				alert("获取位置超时");
			else if (e.code==2)
			alert("位置不可用");
			else if (e.code==1)
			alert("无权限");
		}

		return InputDevice_Map;
	})()



	new InputDevice_Map();

})(window,document,Laya);

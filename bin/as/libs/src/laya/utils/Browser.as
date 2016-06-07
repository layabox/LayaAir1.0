package laya.utils {
	import laya.media.h5audio.AudioSound;
	import laya.media.webaudio.WebAudioSound;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	
	/**
	 * <code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
	 */
	public class Browser {
		AudioSound;
		WebAudioSound;
		/** 浏览器原生 window 对象的引用。*/
		public static var window:* =/*[STATIC SAFE]*/ RunDriver.getWindow();
		/** 浏览器原生 document 对象的引用。*/
		public static var document:* = window.document;
		/** @private */
		private static var _container:*;
		
		__JS__("Browser.document.__createElement=Browser.document.createElement");
		__JS__("window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c, 1000 / 60);};})()");
		//强制修改body样式
		__JS__("var $BS=window.document.body.style;$BS.margin=0;$BS.overflow='hidden';");
		//强制修改meta标签
		__JS__("var metas=window.document.getElementsByTagName('meta');");
		__JS__("var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';");
		__JS__("while(i<metas.length){var meta = metas[i];if(meta.name == 'viewport'){meta.content = content;flag = true;break;}i++;}");
		__JS__("if(!flag){meta = document.createElement('meta');meta.name='viewport',meta.content = content;document.getElementsByTagName('head')[0].appendChild(meta);}");
		
		/** 浏览器代理信息。*/
		public static const userAgent:String = /*[STATIC SAFE]*/ window.navigator.userAgent;
		/** @private */
		private static const u:String = /*[STATIC SAFE]*/ userAgent;
		/** 表示是否在 ios 设备。*/
		public static const onIOS:Boolean = /*[STATIC SAFE]*/ !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
		/** 表示是否在移动设备。*/
		public static const onMobile:Boolean = /*[STATIC SAFE]*/ !!u.match(/AppleWebKit.*Mobile.*/);
		/** 表示是否在 iphone设备。*/
		public static const onIPhone:Boolean = /*[STATIC SAFE]*/ u.indexOf("iPhone") > -1;
		/** 表示是否在 ipad 设备。*/
		public static const onIPad:Boolean = /*[STATIC SAFE]*/ u.indexOf("iPad") > -1;
		/** 表示是否在 andriod设备。*/
		public static const onAndriod:Boolean = /*[STATIC SAFE]*/ u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
		/** 表示是否在 Windows Phone 设备。*/
		public static const onWP:Boolean = /*[STATIC SAFE]*/ u.indexOf("Windows Phone") > -1;
		/** 表示是否在 QQ 浏览器。*/
		public static const onQQBrowser:Boolean = /*[STATIC SAFE]*/ u.indexOf("QQBrowser") > -1;
		/** 表示是否在移动端 QQ 或 QQ 浏览器。*/
		public static const onMQQBrowser:Boolean = /*[STATIC SAFE]*/ u.indexOf("MQQBrowser") > -1;
		/** 微信内*/
		public static const onWeiXin:Boolean = /*[STATIC SAFE]*/ u.indexOf('MicroMessenger') > -1;
		/** 表示是否在 PC 端。*/
		public static const onPC:Boolean = /*[STATIC SAFE]*/ !onMobile;
		/** 表示是否是 HTTP 协议。*/
		public static const httpProtocol:Boolean =/*[STATIC SAFE]*/ window.location.protocol == "http:";
		
		/** @private */
		public static var webAudioOK:Boolean =/*[STATIC SAFE]*/ window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"] ? true : false;
		/** @private */
		public static var soundType:String =/*[STATIC SAFE]*/ webAudioOK ? "WEBAUDIOSOUND" : "AUDIOSOUND";
		
		__JS__("Sound = Browser.webAudioOK?WebAudioSound:AudioSound;");
		__JS__("if (Browser.webAudioOK) WebAudioSound.initWebAudio();");
		/** 全局画布实例（非主画布）。*/
		/*[IF-FLASH]*/
		public static var canvas:HTMLCanvas;
		/** 全局画布上绘图的环境（非主画布）。 */
		/*[IF-FLASH]*/
		public static var context:Context;
		//[IF-SCRIPT]public static var context:Context = canvas.getContext('2d');
		//[IF-SCRIPT]public static var canvas:HTMLCanvas = HTMLCanvas.create('2D');
		/** @private */
		private static var _pixelRatio:Number = -1;
		
		/**@private */
		public static function __init__():void {
			if (canvas) return;
			canvas = HTMLCanvas.create('2D');
			context = canvas.getContext('2d');
		}
		
		/**
		 * 创建浏览器原生节点。
		 * @param	type 节点类型。
		 * @return	创建的节点对象的引用。
		 */
		public static function createElement(type:String):* {
			return document.__createElement(type);
		}
		
		/**
		 * 返回对拥有指定 id 的第一个对象的引用。
		 * @param	type 节点id。
		 * @return	节点对象。
		 */
		public static function getElementById(type:String):* {
			return document.getElementById(type);
		}
		
		/**
		 * 移除浏览器原生节点对象。
		 * @param	type 节点对象。
		 */
		public static function removeElement(ele:*):void {
			if (ele && ele.parentNode) ele.parentNode.removeChild(ele);
		}
		
		/**
		 * 获取浏览器当前时间戳，单位为毫秒。
		 */
		public static function now():Number {
			return RunDriver.now();
		}
		
		/** 浏览器可视宽度。*/
		public static function get clientWidth():Number {
			return document.body.clientWidth;
		}
		
		/** 浏览器可视高度。*/
		public static function get clientHeight():Number {
			return document.body.clientHeight || document.documentElement.clientHeight;
		}
		
		/** 浏览器物理宽度，。*/
		public static function get width():Number {
			__init__();
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientHeight : clientWidth) * pixelRatio;
		}
		
		/** 浏览器物理高度。*/
		public static function get height():Number {
			__init__();
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientWidth : clientHeight) * pixelRatio;
		}
		
		/** 设备像素比。*/
		public static function get pixelRatio():Number {
			__init__();
			return RunDriver.getPixelRatio(_pixelRatio);
		}
		
		/**画布容器，用来盛放画布的容器。方便对画布进行控制*/
		public static function get container():* {
			/*[IF-FLASH-BEGIN]*/
			return document.body;
			/*[IF-FLASH-END]*/
			/*[IF-SCRIPT-BEGIN]
			if (!_container) {
				_container = createElement("div");
				_container.id = "layaContainer";
				_container.style.cssText = "width:100%;height:100%";
				document.body.appendChild(_container);
			}
			return _container;
			[IF-SCRIPT-END]*/
		}
		
		public static function set container(value:*):void {
			_container = value;
		}
	}
}
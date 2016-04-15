package laya.utils {
	import laya.media.h5audio.AudioSound;
	import laya.media.webaudio.WebAudioSound;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	
	/**
	 * 浏览器代理类，封装浏览器及原生js提供的一些功能
	 * @author yung
	 */
	public class Browser {
		AudioSound;
		WebAudioSound;
		
		/**浏览器原生window对象引用*/
		public static var window:*;
		/**浏览器原生document对象引用*/
		public static var document:*;
		__JS__("Browser.window=window");
		__JS__("Browser.document=window.document");
		__JS__("Browser.document.__createElement=Browser.document.createElement");
		__JS__("window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c, 1000 / 60);};})()");
		
		/**浏览器代理信息*/
		public static const userAgent:String = /*[STATIC SAFE]*/ __JS__("navigator.userAgent");
		/** @private */
		private static const u:String = /*[STATIC SAFE]*/ userAgent;
		/**ios设备*/
		public static const onIOS:Boolean = /*[STATIC SAFE]*/ !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
		/**移动设备*/
		public static const onMobile:Boolean = /*[STATIC SAFE]*/ !!u.match(/AppleWebKit.*Mobile.*/);
		/**iphone设备*/
		public static const onIPhone:Boolean = /*[STATIC SAFE]*/ u.indexOf("iPhone") > -1;
		/**ipad设备*/
		public static const onIPad:Boolean = /*[STATIC SAFE]*/ u.indexOf("iPad") > -1;
		/**andriod设备*/
		public static const onAndriod:Boolean = /*[STATIC SAFE]*/ u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
		/**Windows Phone设备*/
		public static const onWP:Boolean = /*[STATIC SAFE]*/ u.indexOf("Windows Phone") > -1;
		/**QQ浏览器*/
		public static const onQQBrowser:Boolean = /*[STATIC SAFE]*/ u.indexOf("QQBrowser") > -1;
		/**移动端QQ或QQ浏览器*/
		public static const onMQQBrowser:Boolean = /*[STATIC SAFE]*/ u.indexOf("MQQBrowser") > -1;
		/**微信内*/
		public static const onWeiXin:Boolean = /*[STATIC SAFE]*/ u.indexOf('MicroMessenger') > -1;
		/**PC端*/
		public static const onPC:Boolean = /*[STATIC SAFE]*/ !onMobile;
		
		/** @private */
		public static var webAudioOK:Boolean;
		/** @private */
		public static var soundType:String;
		webAudioOK = window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"] ? true : false;
		soundType = webAudioOK ? "WEBAUDIOSOUND" : "AUDIOSOUND";
		__JS__("Sound = Browser.webAudioOK?WebAudioSound:AudioSound;");
		
		/**全局画布实例。*/
		public static var canvas:HTMLCanvas = new HTMLCanvas('2D');
		/**全局画布上绘图的环境。 */
		public static var ctx:Context = canvas.getContext('2d');
		/** @private */
		private static var _pixelRatio:Number = -1;
		
		/**
		 * 创建浏览器原生节点
		 * @param	type 节点类型
		 * @return	创建的节点
		 */
		public static function createElement(type:String):* {
			return document.__createElement(type);
		}
		
		/**
		 * 获取浏览器原生节点
		 * @param	type 节点类型
		 * @return	节点
		 */
		public static function getElementById(type:String):* {
			return document.getElementById(type);
		}
		
		/**
		 * 移除浏览器原生节点
		 * @param	type 节点类型
		 */
		public static function removeElement(ele:*):void {
			//[IF-JS]if(ele&&ele.parentNode)ele.parentNode.removeChild(ele);
		}
		
		/**
		 * 获取浏览器当前时间
		 */
		public static function now():Number {
			//[IF-JS]return Date.now();
			/*[IF-FLASH]*/
			return 0;
		}
		
		/**浏览器可视宽度*/
		public static function get clientWidth():Number {
			return document.body.clientWidth;
		}
		
		/**浏览器可视高度*/
		public static function get clientHeight():Number {
			return document.body.clientHeight || document.documentElement.clientHeight;
		}
		
		/**浏览器物理宽度*/
		public static function get width():Number {
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientHeight : clientWidth) * pixelRatio;
		}
		
		/**浏览器物理高度*/
		public static function get height():Number {
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientWidth : clientHeight) * pixelRatio;
		}
		
		/**设备像素比*/
		public static function get pixelRatio():Number {
			if (_pixelRatio < 0) {
				var ctx:* = Browser.ctx;
				var backingStore:Number = ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
				_pixelRatio = (Browser.window.devicePixelRatio || 1) / backingStore;
			}
			return _pixelRatio; 
		}
	}
}
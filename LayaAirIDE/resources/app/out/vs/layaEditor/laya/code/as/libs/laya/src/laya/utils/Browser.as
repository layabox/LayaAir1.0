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
		public static var window:*;
		/** 浏览器原生 document 对象的引用。*/
		public static var document:*;
		__JS__("Browser.window=window");
		__JS__("Browser.document=window.document");
		__JS__("Browser.document.__createElement=Browser.document.createElement");
		__JS__("window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c, 1000 / 60);};})()");
		//强制修改body样式
		__JS__("var bs=window.document.body.style;bs.margin=0;bs.overflow='hidden';");
		//强制修改meta标签
		__JS__("var metas=window.document.getElementsByTagName('meta');");
		__JS__("if(metas){var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';");
		__JS__("while(i<metas.length){var meta = metas[i];if(meta.name == 'viewport'){meta.content = content;flag = true;break;}i++;}");
		__JS__("if(!flag){meta = document.createElement('meta');meta.name='viewport',meta.content = content;document.getElementsByTagName('head')[0].appendChild(meta);}}");
		
		/** 浏览器代理信息。*/
		public static const userAgent:String = /*[STATIC SAFE]*/ __JS__("navigator.userAgent");
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
		public static const httpProtocol:Boolean = /*[STATIC SAFE]*/ __JS__("window").location.protocol == "http:";
		
		/** @private */
		public static var webAudioOK:Boolean;
		/** @private */
		public static var soundType:String;
		webAudioOK = window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"] ? true : false;
		soundType = webAudioOK ? "WEBAUDIOSOUND" : "AUDIOSOUND";
		__JS__("Sound = Browser.webAudioOK?WebAudioSound:AudioSound;");
		
		/** 全局画布实例。*/
		public static var canvas:HTMLCanvas = new HTMLCanvas('2D');
		/** 全局画布上绘图的环境。 */
		public static var ctx:Context = canvas.getContext('2d');
		/** @private */
		private static var _pixelRatio:Number = -1;
		
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
			//[IF-JS]if(ele&&ele.parentNode)ele.parentNode.removeChild(ele);
		}
		
		/**
		 * 获取浏览器当前时间戳，单位为毫秒。
		 */
		public static function now():Number {
			//[IF-JS]return Date.now();
			/*[IF-FLASH]*/
			return 0;
		}
		
		/** 浏览器可视宽度。*/
		public static function get clientWidth():Number {
			return document.body.clientWidth;
		}
		
		/** 浏览器可视高度。*/
		public static function get clientHeight():Number {
			return document.body.clientHeight || document.documentElement.clientHeight;
		}
		
		/** 浏览器物理宽度。*/
		public static function get width():Number {
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientHeight : clientWidth) * pixelRatio;
		}
		
		/** 浏览器物理高度。*/
		public static function get height():Number {
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientWidth : clientHeight) * pixelRatio;
		}
		
		/** 设备像素比。*/
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
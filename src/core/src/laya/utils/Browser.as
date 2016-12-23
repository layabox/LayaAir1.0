package laya.utils {
	//[IF-JS]import laya.media.h5audio.AudioSound;
	//[IF-JS]import laya.media.webaudio.WebAudioSound;
	import laya.media.SoundManager;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.WXCanvas;
	
	SoundManager;
	
	/**
	 * <code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
	 */
	public class Browser {
		//[IF-JS]AudioSound;
		//[IF-JS]WebAudioSound;		
		/** @private */
		private static var _window:*;
		/** @private */
		private static var _document:*;
		/** @private */
		private static var _container:*;
		/** 浏览器代理信息。*/
		public static var userAgent:String;
		/** @private */
		private static var u:String;
		/** 表示是否在 ios 设备。*/
		public static var onIOS:Boolean;
		/** 表示是否在移动设备。*/
		public static var onMobile:Boolean;
		/** 表示是否在 iphone设备。*/
		public static var onIPhone:Boolean;
		/** 表示是否在 ipad 设备。*/
		public static var onIPad:Boolean;
		/** 表示是否在 andriod设备。*/
		public static var onAndriod:Boolean;
		/** 表示是否在 Windows Phone 设备。*/
		public static var onWP:Boolean;
		/** 表示是否在 QQ 浏览器。*/
		public static var onQQBrowser:Boolean;
		/** 表示是否在移动端 QQ 或 QQ 浏览器。*/
		public static var onMQQBrowser:Boolean;
		/** 表示是否在移动端 Safari。*/
		public static var onSafari:Boolean;
		/** 微信内*/
		public static var onWeiXin:Boolean;
		/** 表示是否在 PC 端。*/
		public static var onPC:Boolean;
		/** 表示是否是 HTTP 协议。*/
		public static var httpProtocol:Boolean;
		/** @private */
		public static var webAudioEnabled:Boolean;
		/** @private */
		public static var soundType:String;
		/** @private */
		public static var enableTouch:Boolean;
		/** 全局画布实例（非主画布）。*/
		public static var canvas:HTMLCanvas;
		/** 全局画布上绘图的环境（非主画布）。 */
		public static var context:Context;
		
		/** @private */
		//private static var _pixelRatio:Number = -1;
		
		/**@private */
		public static function __init__():void {
			SoundManager;
			if (_window) return;
			_window = RunDriver.getWindow();
			_document = window.document;
			
			_window.addEventListener('message', function(e:*):void{
				Browser._onMessage(e);
			}, false);
			
			__JS__("Browser.document.__createElement=Browser.document.createElement");
			//TODO:优化
			__JS__("window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c, 1000 / 60);};})()");
			//强制修改body样式
			__JS__("var $BS=window.document.body.style;$BS.margin=0;$BS.overflow='hidden';");
			//强制修改meta标签
			__JS__("var metas=window.document.getElementsByTagName('meta');");
			__JS__("var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';");
			__JS__("while(i<metas.length){var meta = metas[i];if(meta.name == 'viewport'){meta.content = content;flag = true;break;}i++;}");
			__JS__("if(!flag){meta = document.createElement('meta');meta.name='viewport',meta.content = content;document.getElementsByTagName('head')[0].appendChild(meta);}");
			
			userAgent = /*[STATIC SAFE]*/ window.navigator.userAgent;
			u = /*[STATIC SAFE]*/ userAgent;
			onIOS = /*[STATIC SAFE]*/ !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
			onMobile = /*[STATIC SAFE]*/ u.indexOf("Mobile") > -1;
			onIPhone = /*[STATIC SAFE]*/ u.indexOf("iPhone") > -1;
			onIPad = /*[STATIC SAFE]*/ u.indexOf("iPad") > -1;
			onAndriod = /*[STATIC SAFE]*/ u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
			onWP = /*[STATIC SAFE]*/ u.indexOf("Windows Phone") > -1;
			onQQBrowser = /*[STATIC SAFE]*/ u.indexOf("QQBrowser") > -1;
			onMQQBrowser = /*[STATIC SAFE]*/ u.indexOf("MQQBrowser") > -1;
			onWeiXin = /*[STATIC SAFE]*/ u.indexOf('MicroMessenger') > -1;
			onPC = /*[STATIC SAFE]*/ !onMobile;
			onSafari = /*[STATIC SAFE]*/ !!u.match(/Version\/\d+\.\d\x20Mobile\/\S+\x20Safari/);
			httpProtocol =/*[STATIC SAFE]*/ window.location.protocol == "http:";
			
			webAudioEnabled =/*[STATIC SAFE]*/ window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"] ? true : false;
			soundType =/*[STATIC SAFE]*/ webAudioEnabled ? "WEBAUDIOSOUND" : "AUDIOSOUND";
			
			__JS__("Sound = Browser.webAudioEnabled?WebAudioSound:AudioSound;");
			__JS__("if (Browser.webAudioEnabled) WebAudioSound.initWebAudio();");
			__JS__("Browser.enableTouch=(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)");
			__JS__("window.focus()");
			__JS__("SoundManager._soundClass=Sound;");
			
			var MainCanvas:* = null;
			
			if (window.MainCanvasID) {
				//为了支持微信小应用
				var _wx:* = __JS__("wx");
				if (_wx && !_wx.createContext) _wx = null;
				if ((WXCanvas.wx = _wx) != null) {
					MainCanvas = new WXCanvas(window.MainCanvasID);
					var from:* = Context.prototype;
					from.flush = null;
					
					window.Image = function():void {
						this.setSrc = function(url:*):void {
							this.__src = url;
							var _this:* = this;
							/*_wx.downloadFile({
							   url: url,
							   type: 'image',
							   success:function(res:*):void
							   {
							   debugger;
							   _this.success(res);
							   }
							   });*/
							this.success();
						}
						
						this.success = function(res:*):void {
							this.width = 200;
							this.height = 200;
							this.tempFilePath = res ? res.tempFilePath : this.__src;
							this.onload && this.onload();
						}
						
						this.getSrc = function():String {
							return this.__src;
						}
					
						//[IF-SCRIPT]Object.defineProperty(this, "src", { get:this.getSrc,set:this.setSrc, enumerable:false } );
					}
				} else {
					MainCanvas = document.getElementById(window.MainCanvasID);
				}
			}
			
			Render._mainCanvas = Render._mainCanvas || HTMLCanvas.create('2D', MainCanvas);
			if (canvas) return;
			canvas = HTMLCanvas.create('2D');
			context = canvas.getContext('2d');
		}
		
		//接收到其他网页发送的消息
		private static function _onMessage(e:*):void{
			if (!e.data) return;
			if (e.data.name=="size")
			{
				window.innerWidth = e.data.width;
				window.innerHeight = e.data.height;
				window.__innerHeight = e.data.clientHeight;
				if (!document.createEvent){
					trace("no document.createEvent");
					return;
				}
				var evt:* = document.createEvent("HTMLEvents");
				evt.initEvent("resize", false, false);
				window.dispatchEvent(evt);
				return;
			}
		}
		
		/**
		 * 创建浏览器原生节点。
		 * @param	type 节点类型。
		 * @return	创建的节点对象的引用。
		 */
		public static function createElement(type:String):* {
			__init__();
			return document.__createElement(type);
		}
		
		/**
		 * 返回对拥有指定 id 的第一个对象的引用。
		 * @param	type 节点id。
		 * @return	节点对象。
		 */
		public static function getElementById(type:String):* {
			__init__();
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
			__init__();
			return window.innerWidth || document.body.clientWidth;
		}
		
		/** 浏览器可视高度。*/
		public static function get clientHeight():Number {
			__init__();
			return window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
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
			return RunDriver.getPixelRatio();
		}
		
		/**画布容器，用来盛放画布的容器。方便对画布进行控制*/
		public static function get container():* {
			__init__();
			/*[IF-FLASH-BEGIN]*/
			return document.body;
		/*[IF-FLASH-END]*/
		/*[IF-SCRIPT-BEGIN]
		   if (!_container) {
		   _container = createElement("div");
		   _container.id = "layaContainer";
		   document.body.appendChild(_container);
		   }
		   return _container;
		   [IF-SCRIPT-END]*/
		}
		
		public static function set container(value:*):void {
			_container = value;
		}
		
		/** 浏览器原生 window 对象的引用。*/
		static public function get window():* {
			__init__();
			return _window;
		}
		
		/** 浏览器原生 document 对象的引用。*/
		static public function get document():* {
			__init__();
			return _document;
		}
	}
}
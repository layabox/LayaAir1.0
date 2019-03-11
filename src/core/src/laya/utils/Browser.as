package laya.utils {
	import laya.media.SoundManager;
	import laya.net.LocalStorage;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	
	/**
	 * <code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
	 */
	public class Browser {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** 浏览器代理信息。*/
		public static var userAgent:String;
		/** 表示是否在移动设备，包括IOS和安卓等设备内。*/
		public static var onMobile:Boolean;
		/** 表示是否在 IOS 设备内。*/
		public static var onIOS:Boolean;
		/** 表示是否在 Mac 设备。*/
		public static var onMac:Boolean;
		/** 表示是否在 IPhone 设备内。*/
		public static var onIPhone:Boolean;
		/** 表示是否在 IPad 设备内。*/
		public static var onIPad:Boolean;
		/** 表示是否在 Android 设备内。*/
		public static var onAndroid:Boolean;
		/** 表示是否在 Windows Phone 设备内。*/
		public static var onWP:Boolean;
		/** 表示是否在 QQ 浏览器内。*/
		public static var onQQBrowser:Boolean;
		/** 表示是否在移动端 QQ 或 QQ 浏览器内。*/
		public static var onMQQBrowser:Boolean;
		/** 表示是否在 Safari 内。*/
		public static var onSafari:Boolean;
		/** 表示是否在 IE 浏览器内*/
		public static var onIE:Boolean;
		/** 表示是否在 微信 内*/
		public static var onWeiXin:Boolean;
		/** 表示是否在 PC 端。*/
		public static var onPC:Boolean;
		/** @private */
		public static var onMiniGame:Boolean;
		/** @private */
		public static var onBDMiniGame:Boolean;
		/** @private */
		public static var onLimixiu:Boolean;
		/** @private */
		public static var onFirefox:Boolean;//TODO:求补充
		/** @private */
		public static var onEdge:Boolean;//TODO:求补充
		
		/** 表示是否支持WebAudio*/
		public static var supportWebAudio:Boolean;
		/** 表示是否支持LocalStorage*/
		public static var supportLocalStorage:Boolean;
		
		/** 全局离线画布（非主画布）。主要用来测量字体、获取image数据。*/
		public static var canvas:HTMLCanvas;
		/** 全局离线画布上绘图的环境（非主画布）。 */
		public static var context:Context;
		
		/** @private */
		private static var _window:*;
		/** @private */
		private static var _document:*;
		/** @private */
		private static var _container:*;
		/** @private */
		private static var _pixelRatio:Number = -1;
		/** @private */
		public static var _supportWebGL:Boolean = false;
		
		/**@private */
		public static function __init__():* {
			if (_window) return _window;
			var win:* = _window = __JS__("window");
			var doc:* = _document = win.document;
			var u:String = userAgent = win.navigator.userAgent;
			
			//初始化引擎库
			var libs:Array = win._layalibs;
			if (libs) {
				libs.sort(function(a:*, b:*):Boolean {
					return a.i > b.i;
				});
				for (var j:int = 0; j < libs.length; j++) {
					libs[j].f(win, doc, Laya);
				}
			}
			if (u.indexOf("MiniGame") > -1) {
				if (!Laya["MiniAdpter"]) {
					console.error("请先添加小游戏适配库,详细教程：https://ldc2.layabox.com/doc/?nav=zh-ts-5-0-0");
						//TODO 教程要改
				} else {
					Laya["MiniAdpter"].enable();
				}
			}
			
			if (u.indexOf("SwanGame") > -1) {
				if (!Laya["BMiniAdapter"]) {
					console.error("请先添加百度小游戏适配库,详细教程：https://ldc2.layabox.com/doc/?nav=zh-ts-5-0-0");
						//TODO 教程要改
				} else {
					Laya["BMiniAdapter"].enable();
				}
			}
			
			//新增trace的支持
			win.trace = console.log;
			
			//兼容requestAnimationFrame
			win.requestAnimationFrame = win.requestAnimationFrame || win.webkitRequestAnimationFrame || win.mozRequestAnimationFrame || win.oRequestAnimationFrame || win.msRequestAnimationFrame || function(fun:*):* {
				return win.setTimeout(fun, 1000 / 60);
			}
			
			//强制修改body样式
			var bodyStyle:* = doc.body.style;
			bodyStyle.margin = 0;
			bodyStyle.overflow = 'hidden';
			bodyStyle['-webkit-user-select'] = 'none';
			bodyStyle['-webkit-tap-highlight-color'] = 'rgba(200,200,200,0)';
			
			//强制修改meta标签，防止开发者写错
			var metas:Array = doc.getElementsByTagName('meta');
			var i:int = 0, flag:Boolean = false, content:* = 'width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';
			while (i < metas.length) {
				var meta:* = metas[i];
				if (meta.name == 'viewport') {
					meta.content = content;
					flag = true;
					break;
				}
				i++;
			}
			if (!flag) {
				meta = doc.createElement('meta');
				meta.name = 'viewport', meta.content = content;
				doc.getElementsByTagName('head')[0].appendChild(meta);
			}
			
			//处理兼容性			
			onMobile = u.indexOf("Mobile") > -1;
			onIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
			onIPhone = u.indexOf("iPhone") > -1;
			onMac = /*[STATIC SAFE]*/ u.indexOf("Mac OS X") > -1;
			onIPad = u.indexOf("iPad") > -1;
			onAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
			onWP = u.indexOf("Windows Phone") > -1;
			onQQBrowser = u.indexOf("QQBrowser") > -1;
			onMQQBrowser = u.indexOf("MQQBrowser") > -1 || (u.indexOf("Mobile") > -1 && u.indexOf("QQ") > -1);
			onIE = !!win.ActiveXObject || "ActiveXObject" in win;
			onWeiXin = u.indexOf('MicroMessenger') > -1;
			onSafari = /*[STATIC SAFE]*/ u.indexOf("Safari") > -1;
			onPC = !onMobile;
			onMiniGame = /*[STATIC SAFE]*/ u.indexOf('MiniGame') > -1;
			onBDMiniGame = /*[STATIC SAFE]*/ u.indexOf('SwanGame') > -1;
			onLimixiu = /*[STATIC SAFE]*/ u.indexOf('limixiu') > -1;
			//处理LocalStorage兼容
			supportLocalStorage = LocalStorage.__init__();
			//处理声音兼容性
			supportWebAudio = SoundManager.__init__();
			
			//这个其实在Render中感觉更合理，但是runtime要求第一个canvas是主画布，所以必须在下面的那个离线画布之前
			Render._mainCanvas = new HTMLCanvas(true);
			var style:* = Render._mainCanvas.source.style;
			style.position = 'absolute';
			style.top = style.left = "0px";
			style.background = "#000000";
			
			//创建离线画布
			canvas = new HTMLCanvas(true);
			context = canvas.getContext('2d');
			
			//测试是否支持webgl
			var tmpCanv:* = new HTMLCanvas(true);
			var names:Array = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
			var gl:* = null;
			for (i = 0; i < names.length; i++) {
				try {
					gl = tmpCanv.source.getContext(names[i]);
				} catch (e:*) {
				}
				if (gl) {
					_supportWebGL = true;
					break;
				}
			}
			return win;
		}
		
		/**
		 * 创建浏览器原生节点。
		 * @param	type 节点类型。
		 * @return	创建的节点对象的引用。
		 */
		public static function createElement(type:String):* {
			__init__();
			return _document.createElement(type);
		}
		
		/**
		 * 返回 Document 对象中拥有指定 id 的第一个对象的引用。
		 * @param	type 节点id。
		 * @return	节点对象。
		 */
		public static function getElementById(type:String):* {
			__init__();
			return _document.getElementById(type);
		}
		
		/**
		 * 移除指定的浏览器原生节点对象。
		 * @param	type 节点对象。
		 */
		public static function removeElement(ele:*):void {
			if (ele && ele.parentNode) ele.parentNode.removeChild(ele);
		}
		
		/**
		 * 获取浏览器当前时间戳，单位为毫秒。
		 */
		public static function now():Number {
			return __JS__("Date.now();");
		}
		
		/**
		 * 浏览器窗口可视宽度。
		 * 通过分析浏览器信息获得。浏览器多个属性值优先级为：window.innerWidth(包含滚动条宽度) > document.body.clientWidth(不包含滚动条宽度)，如果前者为0或为空，则选择后者。
		 */
		public static function get clientWidth():Number {
			__init__();
			return _window.innerWidth || _document.body.clientWidth;
		}
		
		/**
		 * 浏览器窗口可视高度。
		 * 通过分析浏览器信息获得。浏览器多个属性值优先级为：window.innerHeight(包含滚动条高度) > document.body.clientHeight(不包含滚动条高度) > document.documentElement.clientHeight(不包含滚动条高度)，如果前者为0或为空，则选择后者。
		 */
		public static function get clientHeight():Number {
			__init__();
			return _window.innerHeight || _document.body.clientHeight || _document.documentElement.clientHeight;
		}
		
		/** 浏览器窗口物理宽度。考虑了设备像素比。*/
		public static function get width():Number {
			__init__();
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientHeight : clientWidth) * pixelRatio;
		}
		
		/** 浏览器窗口物理高度。考虑了设备像素比。*/
		public static function get height():Number {
			__init__();
			return ((Laya.stage && Laya.stage.canvasRotation) ? clientWidth : clientHeight) * pixelRatio;
		}
		
		/** 获得设备像素比。*/
		public static function get pixelRatio():Number {
			if (_pixelRatio < 0) {
				__init__();
				if (userAgent.indexOf("Mozilla/6.0(Linux; Android 6.0; HUAWEI NXT-AL10 Build/HUAWEINXT-AL10)") > -1) _pixelRatio = 2;
				else {
					var ctx:* = context;
					var backingStore:Number = ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
					_pixelRatio = (_window.devicePixelRatio || 1) / backingStore;
					if (_pixelRatio < 1) _pixelRatio = 1;
				}
			}
			return _pixelRatio;
		}
		
		/**画布容器，用来盛放画布的容器。方便对画布进行控制*/
		public static function get container():* {
			if (!_container) {
				__init__();
				_container = createElement("div");
				_container.id = "layaContainer";
				_document.body.appendChild(_container);
			}
			return _container;
		}
		
		public static function set container(value:*):void {
			_container = value;
		}
		
		/**浏览器原生 window 对象的引用。*/
		public static function get window():* {
			return _window || __init__();
		}
		
		/**浏览器原生 document 对象的引用。*/
		public static function get document():* {
			__init__();
			return _document;
		}
	}
}
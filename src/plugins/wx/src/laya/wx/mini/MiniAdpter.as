package laya.wx.mini {
	import laya.display.Input;
	import laya.display.Stage;
	import laya.media.Sound;
	import laya.media.SoundManager;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.utils.Utils;
	
	public class MiniAdpter {
		public static var EnvConfig:Object;
		public static var window:*;
		private static var _preCreateElement:Function;
		private static var _inited:Boolean = false;
		private static var wxRequest:*;
		public static var systemInfo:Object;
		public static var version:String = "0.0.1";
		/**是否是子域，默认为false**/
		public static var isZiYu:Boolean;
		/**是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false**/
		public static var isPosMsgYu:Boolean;
		public static function getJson(data:String):Object {
			return JSON.parse(data);
		}
		
		/**
		 * 初始化回调
		 * @param isPostMessage 是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false
		 * @param isSon 是否是子域，默认为false
		 */
		public static function init(isPosMsg:Boolean = false,isSon:Boolean = false):void {
			if (_inited) return;
			window = __JS__('window');
			if(window.navigator.userAgent.indexOf('MiniGame') <0) return;
			_inited = true;
			isZiYu = isSon;
			isPosMsgYu = isPosMsg;			
			EnvConfig = {};
			
			//设置资源存储目录
			if(!isZiYu)
			{
				MiniFileMgr.setNativeFileDir("/layaairGame");
				MiniFileMgr.existDir(MiniFileMgr.fileNativeDir, Handler.create(MiniAdpter, onMkdirCallBack));
			}
			//所有原引擎中有适配代码
			//适配Browser中的window.focus()
			window.focus = function():void {
			};
			//清空路径设定
			Laya['getUrlPath'] = function():void {
			};
			//add---xiaosong--snowgame
			window.logtime = function(str):void {
			};
			window.alertTimeLog = function(str):void {
			};
			window.resetShareInfo = function():void {
			};
			//适配Context中的to对象
			window.CanvasRenderingContext2D = function():void {
			};
			window.CanvasRenderingContext2D.prototype = window.wx.createCanvas().getContext('2d').__proto__;
			//重写body的appendChild方法
			window.document.body.appendChild = function():void {
			};
			//获取手机的设备像素比
			EnvConfig.pixelRatioInt = 0;
			RunDriver.getPixelRatio = pixelRatio;
			//适配HTMLCanvas中的Browser.createElement("canvas")
			_preCreateElement = Browser.createElement;
			//获取小程序pixel值
			Browser["createElement"] = createElement;
			//适配RunDriver.createShaderCondition
			RunDriver.createShaderCondition = createShaderCondition;
			//适配XmlDom
			Utils.parseXMLFromString = parseXMLFromString;
			//文本输入框
			Input['_createInputElement'] = MiniInput['_createInputElement'];
			//修改文件加载
			EnvConfig.load = Loader.prototype.load;
			//文件加载处理
			Loader.prototype.load = MiniLoader.prototype.load;
			//文件清理处理
			//Loader.prototype.clearRes = MiniLoader.prototype.clearRes;
			//修改图片加载
			Loader.prototype._loadImage = MiniImage.prototype._loadImage;
			
			//接收主域透传的数据
			if(isZiYu && isPosMsg)
			{
				__JS__('wx').onMessage(function(message:Object):void{
					if(message['isLoad'])
					{
						MiniFileMgr.ziyuFileData[message.url] = message.data;
					}
				});
			}
		}
		
		private static function onMkdirCallBack(errorCode:int, data:*):void {
			if (!errorCode)
				MiniFileMgr.filesListObj = JSON.parse(data.data);
		}
		
		/** 设备像素比。*/
		public static function pixelRatio():Number {
			if (!EnvConfig.pixelRatioInt) {
				try {
					var systemInfo:Object = __JS__('wx.getSystemInfoSync()');
					EnvConfig.pixelRatioInt = systemInfo.pixelRatio;
					systemInfo = systemInfo;
					return systemInfo.pixelRatio;
				} catch (error:Error) {
				}
			}
			return EnvConfig.pixelRatioInt;
		}
		/**
		 * 将字符串解析成 XML 对象。
		 * @param value 需要解析的字符串。
		 * @return js原生的XML对象。
		 */
		public static var parseXMLFromString:Function = function(value:String):XmlDom {
			var rst:*;
			var Parser:*;
			value = value.replace(/>\s+</g, '><');
			try {
				__JS__("rst=(new window.Parser.DOMParser()).parseFromString(value,'text/xml')");
			} catch (error:Error) {
				throw "需要引入xml解析库文件";
			}
			return rst;
		}
		private static var idx:int = 1;
		
		public static function createElement(type:String):* {
			if (type == "canvas") {
				var _source:*;
				if (idx == 1) {
					if(isZiYu)
					{
						_source = __JS__('sharedCanvas');
						_source.style = {};
					}else
					{
						_source = __JS__("window.canvas");
					}
				} else {
					_source = __JS__("window.wx.createCanvas()");
				}
				idx++;
				return _source;
			} else if (type == "textarea" || type == "input") {
				return onCreateInput(type);
			} else if (type == "div") {
				var node:* = _preCreateElement(type);
				node.contains = function(value):* {
					return null
				};
				node.removeChild = function(value):void {
				};
				return node;
			} else {
				return _preCreateElement(type);
			}
		}
		
		private static function onCreateInput(type):Object {
			var node:* = _preCreateElement(type);
			node.focus = MiniInput.wxinputFocus;
			node.blur = MiniInput.wxinputblur;
			node.style = {};
			node.value = 0;//文本内容
			node.parentElement = {};
			node.placeholder = {};
			node.type = {};
			node.setColor = function(value):void {
			};
			node.setType = function(value):void {
			};
			node.setFontFace = function(value):void {
			};
			node.addEventListener = function(value):void {
			};
			node.contains = function(value):* {
				return null
			};
			node.removeChild = function(value):void {
			};
			return node;
		}
		
		public static function createShaderCondition(conditionScript:String):Function {
			var func:Function = function():* {
				var abc:String = conditionScript;
				return this[conditionScript.replace("this.", "")];
			}
			return func;
		}
	}
}
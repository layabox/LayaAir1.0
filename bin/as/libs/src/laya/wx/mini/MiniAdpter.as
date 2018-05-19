package laya.wx.mini {
	import laya.display.Input;
	import laya.net.Loader;
	import laya.net.LocalStorage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.utils.Utils;
	
	public class MiniAdpter {
		/**@private  包装对象**/
		public static var EnvConfig:Object;
		/**@private **/
		/**全局window对象**/
		public static var window:*;
		/**@private **/
		private static var _preCreateElement:Function;
		/**@private 适配库是否初始化**/
		private static var _inited:Boolean = false;
		/**@private 获取手机系统信息**/
		public static var systemInfo:Object;
		/**@private  是否是子域，默认为false**/
		public static var isZiYu:Boolean;
		/**@private 是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false**/
		public static var isPosMsgYu:Boolean;
		/**是否自动缓存下载的图片跟声音文件，默认为true**/
		public static var autoCacheFile:Boolean = true;
		/**50M缓存容量满时每次清理容量值,默认每次清理5M**/
		public static var minClearSize:int = (5 * 1024 * 1024); 
		/**本地资源列表**/
		public static var nativefiles:Array = ["layaNativeDir","wxlocal"];
		/**@private **/
		public static function getJson(data:String):Object {
			return JSON.parse(data);
		}
		
		/**
		 * 初始化回调
		 * @param isPosMsg 是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false
		 * @param isSon 是否是子域，默认为false
		 */
		public static function init(isPosMsg:Boolean = false,isSon:Boolean = false):void {
			if (_inited) return;
			_inited = true;
			window = __JS__('window');
			if(window.navigator.userAgent.indexOf('MiniGame') <0) return;
			isZiYu = isSon;
			isPosMsgYu = isPosMsg;
			EnvConfig = {};
			
			//设置资源存储目录
			if(!isZiYu)
			{
				MiniFileMgr.setNativeFileDir("/layaairGame");
				MiniFileMgr.existDir(MiniFileMgr.fileNativeDir, Handler.create(MiniAdpter, onMkdirCallBack));
			}
			systemInfo = __JS__('wx.getSystemInfoSync()');
			
			window.focus = function():void {
			};
			//清空路径设定
			Laya['getUrlPath'] = function():void {
			};
			//add---xiaosong--snowgame
			window.logtime = function(str:String):void {
			};
			window.alertTimeLog = function(str:String):void {
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
			Utils['parseXMLFromString'] = parseXMLFromString;
			//文本输入框
			Input['_createInputElement'] = MiniInput['_createInputElement'];
			
			//修改文件加载
			EnvConfig.load = Loader.prototype.load;
			//文件加载处理
			Loader.prototype.load = MiniLoader.prototype.load;
			//修改图片加载
			Loader.prototype._loadImage = MiniImage.prototype._loadImage;
			//本地缓存类
			MiniLocalStorage.__init__();
			LocalStorage._baseClass = MiniLocalStorage;
		}
		
		/**
		 * 获取url对应的encoding值 
		 * @param url 文件路径
		 * @param type 文件类型
		 * @return 
		 */		
		public static  function getUrlEncode(url:String,type:String):String
		{
			if(url.indexOf(".fnt") != -1)
				return "utf8";
			else if(type == "arraybuffer")
				return "";
			return "ascii";
		}
			
		/**
		 * 下载文件 
		 * @param fileUrl 文件地址(全路径)
		 * @param fileType 文件类型(image、text、json、xml、arraybuffer、sound、atlas、font)
		 * @param callBack 文件加载回调,回调内容[errorCode码(0成功,1失败,2加载进度)
		 * @param encoding 文件编码默认 ascill，非图片文件加载需要设置相应的编码，二进制编码为空字符串
		 */				
		public static function downLoadFile(fileUrl:String, fileType:String = "",callBack:Handler = null,encoding:String = "ascii"):void
		{
			var fileObj:Object = MiniFileMgr.getFileInfo(fileUrl);
			if(!fileObj)
				MiniFileMgr.downLoadFile(fileUrl,fileType,callBack,encoding);
			else
			{
				callBack != null && callBack.runWith([0]);
			}
		}
		
		/**
		 * 从本地删除文件
		 * @param fileUrl 文件地址(全路径)
		 * @param callBack 回调处理，在存储图片时用到
		 */
		public static function remove(fileUrl:String, callBack:Handler = null):void {
			MiniFileMgr.deleteFile("",fileUrl,callBack,"",0);
		}
		
		/**
		 * 清空缓存空间文件内容 
		 */		
		public static function removeAll():void
		{
			MiniFileMgr.deleteAll();
		}
		
		/**
		 * 判断是否是4M包文件
		 * @param fileUrl 文件地址(全路径)
		 * @return 
		 */		
		public static function  hasNativeFile(fileUrl:String):Boolean
		{
			return MiniFileMgr.isLocalNativeFile(fileUrl);
		}
		
		/**
		 * 判断缓存里是否存在文件
		 * @param fileUrl 文件地址(全路径)
		 * @return
		 */
		public static function getFileInfo(fileUrl:String):Object {
			return MiniFileMgr.getFileInfo(fileUrl);
		}
		
		/**
		 * 获取缓存文件列表
		 * @return
		 */
		public static function getFileList():Object
		{
			return MiniFileMgr.filesListObj;
		}
		
		/**@private 退出小游戏**/
		public static function exitMiniProgram():void
		{
			window["wx"].exitMiniProgram();
		}
		
		/**@private **/
		private static function onMkdirCallBack(errorCode:int, data:*):void {
			if (!errorCode)
				MiniFileMgr.filesListObj = JSON.parse(data.data);
		}
		
		/**@private 设备像素比。*/
		public static function pixelRatio():Number {
			if (!EnvConfig.pixelRatioInt) {
				try {
					EnvConfig.pixelRatioInt = systemInfo.pixelRatio;
					return systemInfo.pixelRatio;
				} catch (error:Error) {
				}
			}
			return EnvConfig.pixelRatioInt;
		}
		/**
		 * @private 
		 * 将字符串解析成 XML 对象。
		 * @param value 需要解析的字符串。
		 * @return js原生的XML对象。
		 */
		private static var parseXMLFromString:Function = function(value:String):XmlDom {
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
		/**@private **/
		private static var idx:int = 1;
		/**@private **/
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
				node.contains = function(value:String):* {
					return null
				};
				node.removeChild = function(value:String):void {
				};
				return node;
			} else {
				return _preCreateElement(type);
			}
		}
		/**@private **/
		private static function onCreateInput(type:*):Object {
			var node:* = _preCreateElement(type);
			node.focus = MiniInput.wxinputFocus;
			node.blur = MiniInput.wxinputblur;
			node.style = {};
			node.value = 0;//文本内容
			node.parentElement = {};
			node.placeholder = {};
			node.type = {};
			node.setColor = function(value:String):void {
			};
			node.setType = function(value:String):void {
			};
			node.setFontFace = function(value:String):void {
			};
			node.addEventListener = function(value:String):void {
			};
			node.contains = function(value:String):* {
				return null
			};
			node.removeChild = function(value:String):void {
			};
			return node;
		}
		
		/**@private **/
		public static function createShaderCondition(conditionScript:String):Function {
			var func:Function = function():* {
				var abc:String = conditionScript;
				return this[conditionScript.replace("this.", "")];
			}
			return func;
		}
	}
}
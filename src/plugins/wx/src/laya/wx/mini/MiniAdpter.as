package laya.wx.mini {
	import laya.display.Input;
	import laya.display.Stage;
	import laya.maths.Matrix;
	import laya.net.Loader;
	import laya.net.LocalStorage;
	import laya.net.URL;
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
		public static var nativefiles:Array = ["layaNativeDir", "wxlocal"];
		/**本地分包资源表**/
		public static var subNativeFiles:Object;
		/**本地分包文件目录数组**/
		public static var subNativeheads:Array = [];
		/**本地分包文件目录映射表**/
		public static var subMaps:Array = [];
		/**@private 是否自动缓存非图片声音文件(这里要确保文件编码最好一致)**/
		public static var AutoCacheDownFile:Boolean = false;
		
		/**@private **/
		public static function getJson(data:String):Object {
			return JSON.parse(data);
		}
		
		/**激活微信小游戏适配器*/
		public static function enable():void {
			init(Laya.isWXPosMsg, Laya.isWXOpenDataContext);
		}
		
		/**
		 * 初始化回调
		 * @param isPosMsg 是否需要在主域中自动将加载的文本数据自动传递到子域，默认 false
		 * @param isSon 是否是子域，默认为false
		 */
		public static function init(isPosMsg:Boolean = false, isSon:Boolean = false):void {
			if (_inited) return;
			_inited = true;
			window = __JS__('window');
			if (window.navigator.userAgent.indexOf('MiniGame') < 0) return;
			isZiYu = isSon;
			isPosMsgYu = isPosMsg;
			EnvConfig = {};
			
			//设置资源存储目录
			if (!isZiYu) {
				MiniFileMgr.setNativeFileDir("/layaairGame");
				MiniFileMgr.existDir(MiniFileMgr.fileNativeDir, Handler.create(MiniAdpter, onMkdirCallBack));
			}
			systemInfo = __JS__('wx.getSystemInfoSync()');
			
			window.focus = function():void {
			};
			//清空路径设定
			Laya['_getUrlPath'] = function():void {
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
			//			RunDriver.getPixelRatio = pixelRatio;
			Browser["_pixelRatio"] = pixelRatio();
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
			
			window.wx.onMessage(_onMessage);
		}
		
		private static function _onMessage(data:Object):void {
			switch (data.type) {
			case "changeMatrix": 
				Laya.stage.transform.identity();
				Laya.stage._width = data.w;
				Laya.stage._height = data.h;
				Laya.stage._canvasTransform = new Matrix(data.a, data.b, data.c, data.d, data.tx, data.ty);
				break;
			case "display": 
				Laya.stage.frameRate = data.rate || Stage.FRAME_FAST;
				break;
			case "undisplay": 
				Laya.stage.frameRate = Stage.FRAME_SLEEP;
				break;
			}
			if (data['isLoad'] == "opendatacontext") {
				if (data.url) {
					MiniFileMgr.ziyuFileData[data.url] = data.atlasdata;//图集配置数据
					MiniFileMgr.ziyuFileTextureData[data.imgReadyUrl] = data.imgNativeUrl;//imgNativeUrl 为本地磁盘地址;imgReadyUrl为外网路径
				}
			} else if (data['isLoad'] == "openJsondatacontext") {
				if (data.url) {
					MiniFileMgr.ziyuFileData[data.url] = data.atlasdata;//json配置数据信息
				}
			} else if (data['isLoad'] == "openJsondatacontextPic") {
				MiniFileMgr.ziyuFileTextureData[data.imgReadyUrl] = data.imgNativeUrl;//imgNativeUrl 为本地磁盘地址;imgReadyUrl为外网路径
			}
		}
		
		/**
		 * 获取url对应的encoding值
		 * @param url 文件路径
		 * @param type 文件类型
		 * @return
		 */
		public static function getUrlEncode(url:String, type:String):String {
			if (type == "arraybuffer")
				return "";
			return "utf8";
		}
		
		/**
		 * 下载文件
		 * @param fileUrl 文件地址(全路径)
		 * @param fileType 文件类型(image、text、json、xml、arraybuffer、sound、atlas、font)
		 * @param callBack 文件加载回调,回调内容[errorCode码(0成功,1失败,2加载进度)
		 * @param encoding 文件编码默认utf8，非图片文件加载需要设置相应的编码，二进制编码为空字符串
		 */
		public static function downLoadFile(fileUrl:String, fileType:String = "", callBack:Handler = null, encoding:String = "utf8"):void {
			var fileObj:Object = MiniFileMgr.getFileInfo(fileUrl);
			if (!fileObj)
				MiniFileMgr.downLoadFile(fileUrl, fileType, callBack, encoding);
			else {
				callBack != null && callBack.runWith([0]);
			}
		}
		
		/**
		 * 从本地删除文件
		 * @param fileUrl 文件地址(全路径)
		 * @param callBack 回调处理，在存储图片时用到
		 */
		public static function remove(fileUrl:String, callBack:Handler = null):void {
			MiniFileMgr.deleteFile("", fileUrl, callBack, "", 0);
		}
		
		/**
		 * 清空缓存空间文件内容
		 */
		public static function removeAll():void {
			MiniFileMgr.deleteAll();
		}
		
		/**
		 * 判断是否是4M包文件
		 * @param fileUrl 文件地址(全路径)
		 * @return
		 */
		public static function hasNativeFile(fileUrl:String):Boolean {
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
		public static function getFileList():Object {
			return MiniFileMgr.filesListObj;
		}
		
		/**@private 退出小游戏**/
		public static function exitMiniProgram():void {
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
					if (isZiYu) {
						_source = __JS__('sharedCanvas');
						_source.style = {};
					} else {
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
		
		/**
		 * 传递图集url地址到
		 * @param url 为绝对地址
		 */
		public static function sendAtlasToOpenDataContext(url:String):void {
			if (!MiniAdpter.isZiYu) {
				var atlasJson:Object = Loader.getRes(URL.formatURL(url));
				if (atlasJson) {
					var textureArr:Array = (atlasJson.meta.image as String).split(",");
					
					//构造加载图片信息
					if (atlasJson.meta && atlasJson.meta.image) {
						//带图片信息的类型
						var toloadPics:Array = atlasJson.meta.image.split(",");
						var split:String = url.indexOf("/") >= 0 ? "/" : "\\";
						var idx:int = url.lastIndexOf(split);
						var folderPath:String = idx >= 0 ? url.substr(0, idx + 1) : "";
						for (var i:int = 0, len:int = toloadPics.length; i < len; i++) {
							toloadPics[i] = folderPath + toloadPics[i];
						}
					} else {
						//不带图片信息
						toloadPics = [url.replace(".json", ".png")];
					}
					for (i = 0; i < toloadPics.length; i++) {
						var tempAtlasPngUrl:String = toloadPics[i];
						postInfoToContext(url, tempAtlasPngUrl, atlasJson);
					}
				} else {
					throw "传递的url没有获取到对应的图集数据信息，请确保图集已经过！";
				}
			}
		}
		
		private static function postInfoToContext(url:String, atlaspngUrl:String, atlasJson:Object):void {
			var postData:Object = {"frames": atlasJson.frames, "meta": atlasJson.meta};
			var textureUrl:String = atlaspngUrl;
			var fileObj:Object = MiniFileMgr.getFileInfo(URL.formatURL(atlaspngUrl));
			if (fileObj) {
				var fileMd5Name:String = fileObj.md5;
				var fileNativeUrl:String = MiniFileMgr.getFileNativePath(fileMd5Name);
			} else {
				fileNativeUrl = textureUrl;//4M包使用
			}
			if (fileNativeUrl) {
				__JS__('wx').postMessage({url: url, atlasdata: postData, imgNativeUrl: fileNativeUrl, imgReadyUrl: textureUrl, isLoad: "opendatacontext"});
			} else {
				throw "获取图集的磁盘url路径不存在！";
			}
		}
		
		/**
		 * 发送单张图片到开放数据域
		 * @param url
		 */
		public static function sendSinglePicToOpenDataContext(url:String):void {
			var tempTextureUrl:String = URL.formatURL(url);
			var fileObj:Object = MiniFileMgr.getFileInfo(tempTextureUrl);
			if (fileObj) {
				var fileMd5Name:String = fileObj.md5;
				var fileNativeUrl:String = MiniFileMgr.getFileNativePath(fileMd5Name);
				url = tempTextureUrl;
			} else {
				fileNativeUrl = url;//4M包使用
			}
			if (fileNativeUrl) {
				__JS__('wx').postMessage({url: url, imgNativeUrl: fileNativeUrl, imgReadyUrl: url, isLoad: "openJsondatacontextPic"});
			} else {
				throw "获取图集的磁盘url路径不存在！";
			}
		}
		
		/**
		 * 传递json配置数据到开放数据域
		 * @param url 为绝对地址
		 */
		public static function sendJsonDataToDataContext(url:String):void {
			if (!MiniAdpter.isZiYu) {
				var atlasJson:Object = Loader.getRes(url);
				if (atlasJson) {
					__JS__('wx').postMessage({url: url, atlasdata: atlasJson, isLoad: "openJsondatacontext"});
				} else {
					throw "传递的url没有获取到对应的图集数据信息，请确保图集已经过！";
				}
			}
		}
	}
}
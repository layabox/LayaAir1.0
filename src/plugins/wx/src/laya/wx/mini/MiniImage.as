package laya.wx.mini {
	import laya.events.Event;
	import laya.net.URL;
	import laya.resource.HTMLImage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	public class MiniImage {
		
		protected function _loadImage(url:String):void {
			var thisLoader:* = this;
			//这里要预处理磁盘文件的读取,带layanative目录标识的视为本地磁盘文件，不进行路径转换操作
			var isTransformUrl:Boolean;
			if (url.indexOf("layaNativeDir/") == -1) {
				isTransformUrl = true;
				url = URL.formatURL(url);
			}
			if (!MiniFileMgr.getFileInfo(url)) {
				if (url.indexOf("http://") != -1 || url.indexOf("https://") != -1)
					MiniFileMgr.downImg(url, new Handler(MiniImage, onDownImgCallBack, [url, thisLoader]), url);
				else
					onCreateImage(url, thisLoader, true);//直接读取本地文件，非加载缓存的图片
			} else {
				onCreateImage(url, thisLoader, !isTransformUrl);//外网图片加载
			}
		}
		
		/**
		 * 下载图片文件回调处理
		 * @param sourceUrl
		 * @param thisLoader
		 * @param errorCode
		 */
		private static function onDownImgCallBack(sourceUrl:String, thisLoader:*, errorCode:int):void {
			if (!errorCode)
				onCreateImage(sourceUrl, thisLoader);
			else {
				thisLoader.onError(null);
			}
		}
		
		/**
		 * 创建图片对象
		 * @param sourceUrl
		 * @param thisLoader
		 * @param isLocal 本地图片(没有经过存储的,实际存在的图片，需要开发者自己管理更新)
		 */
		private static function onCreateImage(sourceUrl:String, thisLoader:*, isLocal:Boolean = false):void {
			var fileNativeUrl:String;
			if (!isLocal) {
				var fileObj:Object = MiniFileMgr.getFileInfo(sourceUrl);
				var fileMd5Name:String = fileObj.md5;
				fileNativeUrl = MiniFileMgr.getFileNativePath(fileMd5Name);
			} else {
				fileNativeUrl = sourceUrl;
			}
			if (thisLoader.imgCache == null)
				thisLoader.imgCache = {};
			var image:*;
			function clear():void {
				image.onload = null;
				image.onerror = null;
				delete thisLoader.imgCache[sourceUrl]
			}
			var onload:Function = function():void {
				clear();
				thisLoader.onLoaded(image);
			};
			var onerror:Function = function():void {
				clear();
				thisLoader.event(Event.ERROR, "Load image failed");
			}
			if (thisLoader._type == "nativeimage") {
				image = new Browser.window.Image();
				image.crossOrigin = "";
				image.onload = onload;
				image.onerror = onerror;
				image.src = fileNativeUrl;
				//增加引用，防止垃圾回收
				thisLoader.imgCache[sourceUrl] = image;
			} else {
				new HTMLImage.create(fileNativeUrl, {onload: onload, onerror: onerror, onCreate: function(img:*):void {
					image = img;
					//增加引用，防止垃圾回收
					thisLoader.imgCache[sourceUrl] = img;
				}});
			}
		}
	}
}


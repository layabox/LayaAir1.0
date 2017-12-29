package laya.wx.mini {
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	public class MiniLoader {
		/**加载文件列表**/
		private static var _fileTypeArr:Array = ['png', 'jpg', 'bmp', 'jpeg', 'gif'];
		
		public function MiniLoader() {
		}
		
		/**
		 *
		 * @param url
		 * @param type
		 * @param cache
		 * @param group
		 * @param ignoreCache
		 */
		private function load(url:String, type:String = null, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false):void {
			var thisLoader:* = this;
			thisLoader._url = url;
			if (url.indexOf("data:image") === 0) thisLoader._type = type = Loader.IMAGE;
			else {
				thisLoader._type = type || (type = thisLoader.getTypeFromUrl(url));
			}
			thisLoader._cache = cache;
			thisLoader._data = null;
			
			var encoding:String = "ascii";
			if (url.indexOf(".fnt") != -1) {
				encoding = "utf8";
			} else if (type == "arraybuffer") {
				encoding = "";
			}
			var urlType:String = Utils.getFileExtension(url);
			if ((_fileTypeArr.indexOf(urlType) != -1)) {
				//远端文件加载走xmlhttprequest
				MiniAdpter.EnvConfig.load.call(this, url, type, cache, group, ignoreCache);
			} else {
				if (!MiniFileMgr.getFileInfo(url)) {
					if (url.indexOf("layaNativeDir/") != -1) {
						//直接读取本地，非网络加载缓存的资源
						if(MiniAdpter.isZiYu)
						{
							//从minifile里读取数据内容，然后直接返回
							var fileData:Object = MiniFileMgr.ziyuFileData[url];
							thisLoader.onLoaded(fileData);
							return;
						}else
						{
							MiniFileMgr.read(url,encoding,new Handler(MiniLoader, onReadNativeCallBack, [encoding, url, type, cache, group, ignoreCache, thisLoader]));
							return;
						}
					}
					if (URL.rootPath == "")
						var fileNativeUrl:String = url;
					else
						fileNativeUrl = url.split(URL.rootPath)[0];
						
					if (url.indexOf("http://") != -1 || url.indexOf("https://") != -1) {
						//远端文件加载走xmlhttprequest
						MiniAdpter.EnvConfig.load.call(thisLoader, url, type, cache, group, ignoreCache);
					} else {
						//读取本地磁盘非写入的文件，只是检测文件是否需要本地读取还是外围加载
						MiniFileMgr.readFile(fileNativeUrl, encoding, new Handler(MiniLoader, onReadNativeCallBack, [encoding, url, type, cache, group, ignoreCache, thisLoader]), url);
					}
				} else {
					//远端文件加载走xmlhttprequest
					MiniAdpter.EnvConfig.load.call(this, url, type, cache, group, ignoreCache);
				}
			}
		}
		
		/**
		 *
		 * @param url
		 * @param thisLoader
		 * @param errorCode
		 * @param data
		 *
		 */
		private static function onReadNativeCallBack(encoding:String, url:String, type:String = null, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false, thisLoader:* = null, errorCode:int = 0, data:Object = null):void {
			if (!errorCode) {
				//文本文件读取本地存在
				var tempData:Object;
				if (type == Loader.JSON || type == Loader.ATLAS) {
					tempData = MiniAdpter.getJson(data.data);
				} else if (type == Loader.XML) {
					tempData = Utils.parseXMLFromString(data.data);
				} else {
					tempData = data.data;
				}
				thisLoader.onLoaded(tempData);
				if(!MiniAdpter.isZiYu &&MiniAdpter.isPosMsgYu && type  != Loader.BUFFER)
				{
					__JS__('wx').postMessage({url:url,data:tempData,isLoad:true});
				}
			} else if (errorCode == 1) {
				//远端文件加载走xmlhttprequest
				MiniAdpter.EnvConfig.load.call(thisLoader, url, type, cache, group, ignoreCache);
			}
		}
		
		/**
		 * 清理资源
		 * @param url
		 * @param forceDispose
		 */
		public function clearRes(url:String, forceDispose:Boolean = false):void {
			var thisLoader:* = this;
			thisLoader.clearRes(url, forceDispose);
			var fileObj:Object = MiniFileMgr.getFileInfo(url);
			if (fileObj && (url.indexOf("http://") != -1 || url.indexOf("https://") != -1)) {
				var fileMd5Name:String = fileObj.md5;
				var fileNativeUrl:String = MiniFileMgr.getFileNativePath(fileMd5Name);
				MiniFileMgr.remove(fileNativeUrl);
			}
		}
	}
}
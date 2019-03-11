package laya.net {
	import laya.utils.Handler;
	
	/**
	 * @private
	 */
	public class AtlasInfoManager {
		
		private static var _fileLoadDic:Object = {};
		
		public static function enable(infoFile:String, callback:Handler = null):void {
			Laya.loader.load(infoFile, Handler.create(null, _onInfoLoaded, [callback]), null, Loader.JSON);
		}
		
		/**@private */
		private static function _onInfoLoaded(callback:Handler, data:Object):void {
			var tKey:String;
			var tPrefix:String;
			var tArr:Array;
			var i:int, len:int;
			
			for (tKey in data) {
				tArr = data[tKey];
				tPrefix = tArr[0];
				tArr = tArr[1];
				len = tArr.length;
				for (i = 0; i < len; i++) {
					_fileLoadDic[tPrefix + tArr[i]] = tKey;
				}
			}
			callback && callback.run();
		}
		
		public static function getFileLoadPath(file:String):String {
			return _fileLoadDic[file] || file;
		}
	}

}
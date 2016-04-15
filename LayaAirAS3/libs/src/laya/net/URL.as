package laya.net {
	
	/**
	 * <p> <code>URL</code> 类用于定义地址信息。</p>
	 * @author laya
	 */
	public class URL {
		/**
		 * 版本号。
		 */
		public static var version:Object = {};
		private var _url:String;
		private var _path:String;
		
		/**
		 * 创建一个新的 <code>URL</code> 实例。
		 */
		public function URL(url:String) {
			_url = formatURL(url);
			_path = getPath(url);
		}
		
		public function get url():String {
			return _url;
		}
		
		public function get path():String {
			return _path;
		}
		
		public static var basePath:String = "";
		public static var rootPath:String = "";
		/**自定义url格式化，比如customFormat = function(url:String,basePath:String):String{}*/
		public static var customFormat:Function;
		
		public static function formatURL(url:String, _basePath:String = null):String {
			if (customFormat != null) url = customFormat(url, _basePath); 
			if (!url) return "null path";
			version[url] && (url += "?v=" + version[url]);
			if(url.indexOf(":")>0||url.charAt(0) == '/') return url;
			return (_basePath || rootPath) + url;
		}
		
		//url获取路径，末尾有/
		public static function getPath(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(0, ofs + 1) : "";
		}
		
		//url获取文件名
		public static function getName(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(ofs + 1) : url;
		}
	}
}
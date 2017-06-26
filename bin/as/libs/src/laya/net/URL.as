package laya.net {
	import laya.renders.Render;
	
	/**
	 * <p> <code>URL</code> 类用于定义地址信息。</p>
	 */
	public class URL {
		/**版本号。*/
		public static var version:Object = {};
		/**@private */
		private var _url:String;
		/**@private */
		private var _path:String;
		
		/**创建一个新的 <code>URL</code> 实例。*/
		public function URL(url:String) {
			_url = formatURL(url);
			_path = getPath(url);
		}
		
		/**格式化后的地址。*/
		public function get url():String {
			return _url;
		}
		
		/**地址的路径。*/
		public function get path():String {
			return _path;
		}
		
		/**基础路径。*/
		public static var basePath:String = "";
		/**根路径。*/
		public static var rootPath:String = "";
		/** 自定义url格式化。例如： customFormat = function(url:String):String{} */
		public static var customFormat:Function = function(url:String):String {
			var newUrl:String = version[url];
			if (!Render.isConchApp && newUrl) url += "?v=" + newUrl;
			return url;
		}
		
		/**
		 * 格式化指定的地址并	返回。
		 * @param	url 地址。
		 * @param	base 路径。
		 * @return 格式化处理后的地址。
		 */
		public static function formatURL(url:String, base:String = null):String {
			if (!url) return "null path";
			
			//如果是全路径，直接返回，提高性能
			if (url.indexOf(":") > 0) return url;
			//自定义路径格式化
			if (customFormat != null) url = customFormat(url, base);
			
			var char1:String = url.charAt(0);
			if (char1 === ".") {
				return formatRelativePath((base || basePath) + url);
			} else if (char1 === '~') {
				return rootPath + url.substring(1);
			} else if (char1 === "d") {
				if (url.indexOf("data:image") === 0) return url;
			} else if (char1 === "/") {
				return url;
			}
			return (base || basePath) + url;
		}
		
		/**
		 * 格式化相对路径。
		 * @param	value
		 * @return
		 */
		private static function formatRelativePath(value:String):String {
			var parts:Array = value.split("/");
			for (var i:int = 0, len:int = parts.length; i < len; i++) {
				if (parts[i] == '..') {
					parts.splice(i - 1, 2);
					i -= 2;
				}
			}
			return parts.join('/');
		}
		
		/**
		 * 检测指定 URL 是否是绝对地址。
		 * @param	url 地址。
		 * @return 一个 Boolean 值表示指定的 url 是否是绝对地址。如果是绝对地址则返回 true ,否则返回 false 。
		 */
		private static function isAbsolute(url:String):Boolean {
			return url.indexOf(":") > 0 || url.charAt(0) == '/';
		}
		
		/**
		 * @private
		 * 获取指定 URL 的路径。
		 * <p><b>注意：</b>末尾有斜杠（/）。</p>
		 * @param	url 地址。
		 * @return  url 的路径。
		 */
		public static function getPath(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(0, ofs + 1) : "";
		}
		
		/**
		 * 获取指定 URL 的文件名。
		 * @param	url 地址。
		 * @return url 的文件名。
		 */
		public static function getFileName(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(ofs + 1) : url;
		}
	}
}
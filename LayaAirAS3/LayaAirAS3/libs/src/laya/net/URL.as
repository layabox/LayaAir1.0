package laya.net {
	import laya.renders.Render;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
	/**
	 * <p> <code>URL</code> 类用于定义地址信息。</p>
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
		
		/**
		 * 格式化后的地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 地址的路径。
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * 基础路径。
		 */
		public static var basePath:String = "";
		/**
		 * 根路径。
		 */
		public static var rootPath:String = "";
		/** 自定义url格式化。例如： customFormat = function(url:String,basePath:String):String{} */
		public static var customFormat:Function;
		
		/**
		 * 格式化指定的地址并	返回。
		 * @param	url 地址。
		 * @param	_basePath 路径。
		 * @return 格式化处理后的地址。
		 */	
		public static function formatURL(url:String, _basePath:String = null):String {
			if (customFormat != null) url = customFormat(url, _basePath);
			if (!url) return "null path";
			if ( Render.isConchApp == false)
			{
				version[url] && (url += "?v=" + version[url]);
			}
			if (url.charAt(0) == '~')
				return rootPath + url.substring(1);
			
			if (isAbsolute(url))
				return url;
				
			return (_basePath || basePath) + url;
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
		public static function getName(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(ofs + 1) : url;
		}
	}
}
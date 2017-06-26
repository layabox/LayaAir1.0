package laya.net {
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/**
	 * <p>资源版本的生成由layacmd或IDE完成，使用 <code>ResourceVersion</code> 简化使用过程。</p>
	 * <p>调用 <code>enable</code> 启用资源版本管理。</p>
	 */
	public class ResourceVersion {
		public static var manifest:Object;
		
		/**
		 * <p>启用资源版本管理。</p>
		 * <p>由于只有发布版本需要资源管理。因此没有资源管理文件时，可以设置manifestFile为null或者不存在的路径。</p>
		 * @param	manifestFile	清单（json）文件的路径。
		 * @param   callback		清单（json）文件加载完成后执行。
		 */
		public static function enable(manifestFile:String, callback:Handler):void {
			Laya.loader.load(manifestFile, Handler.create(null, onManifestLoaded, [callback]), null, Loader.JSON);
			URL.customFormat = addVersionPrefix;
		}
		
		private static function onManifestLoaded(callback:Handler, data:Object):void {
			manifest = data;
			callback.run();
			
			if (!data) {
				console.warn("资源版本清单文件不存在，不使用资源版本管理。忽略ERR_FILE_NOT_FOUND错误。");
			}
		}
		
		/**
		 * 为加载路径添加版本前缀。
		 * @param	originURL	源路径。
		 * @return 格式化后的新路径。
		 */
		public static function addVersionPrefix(originURL:String):String {
			if (manifest && manifest[originURL])
				return manifest[originURL] + "/" + originURL;
			return originURL;
		}
	}
}
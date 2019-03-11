package laya.components {
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.SceneUtils;
	
	/**
	 * 模板，预制件
	 */
	public class Prefab {
		/**@private */
		public var json:Object;
		
		/**
		 * 通过预制创建实例
		 */
		public function create():* {
			if (json) return SceneUtils.createByData(null,json);
			return null;
		}
	}
}
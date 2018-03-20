package laya.utils {
	
	/**
	 * 封装弱引用WeakMap
	 * 如果支持WeakMap，则使用WeakMap，如果不支持，则用Object代替
	 * 注意：如果采用Object，为了防止内存泄漏，则采用定时清理缓存策略
	 */
	public class WeakObject {
		/**是否支持WeakMap*/
		public static var supportWeakMap:Boolean;
		/**如果不支持WeakMap，则多少时间清理一次缓存，默认5分钟清理一次*/
		public static var delInterval:int = 5 * 60 * 1000;
		/**全局WeakObject单例*/
		public static var I:WeakObject = new WeakObject();
		/**@private */
		private static var _keys:Object = {};
		/**@private */
		private static var _maps:Array = [];
		/**@private */
		public var _obj:*;
		
		/**@private */
		public static function __init__():void {
			supportWeakMap = Browser.window.WeakMap != null;
			//如果不支持，5分钟回收一次
			if (!supportWeakMap) Laya.timer.loop(delInterval, null, clearCache);
		}
		
		/**清理缓存，回收内存*/
		public static function clearCache():void {
			for (var i:int = 0, n:int = _maps.length; i < n; i++) {
				var obj:WeakObject = _maps[i];
				obj._obj = {};
			}
		}
		
		public function WeakObject() {
			_obj = supportWeakMap ? new Browser.window.WeakMap() : {};
			if (!supportWeakMap) _maps.push(this);
		}
		
		/**
		 * 设置缓存
		 * @param	key kye对象，可被回收
		 * @param	value object对象，可被回收
		 */
		public function set(key:Object, value:Object):void {
			if (key == null) return;
			if (supportWeakMap) {
				var objKey:Object = key;
				if (key is String || key is Number) {
					objKey = _keys[key];
					if (!objKey) objKey = _keys[key] = {k: key};
				}
				_obj.set(objKey, value);
			} else {
				if (key is String || key is Number) {
					_obj[key] = value;
				} else {
					key.$_GID || (key.$_GID = Utils.getGID());
					_obj[key.$_GID] = value;
				}
			}
		}
		
		/**
		 * 获取缓存
		 * @param	key kye对象，可被回收
		 */
		public function get(key:Object):* {
			if (key == null) return null;
			if (supportWeakMap) {
				var objKey:Object = (key is String || key is Number) ? _keys[key] : key;
				if (!objKey) return null;
				return _obj.get(objKey);
			} else {
				if (key is String || key is Number) return _obj[key];
				return _obj[key.$_GID];
			}
		}
		
		/**
		 * 删除缓存
		 */
		public function del(key:Object):void {
			if (key == null) return;
			if (supportWeakMap) {
				var objKey:Object = (key is String || key is Number) ? _keys[key] : key;
				if (!objKey) return;
				__JS__("this._obj.delete(objKey)");
			} else {
				if (key is String || key is Number) delete _obj[key];
				else delete _obj[_obj.$_GID];
			}
		}
		
		/**
		 * 是否有缓存
		 */
		public function has(key:Object):Boolean {
			if (key == null) return false;
			if (supportWeakMap) {
				var objKey:Object = (key is String || key is Number) ? _keys[key] : key;
				return _obj.has(objKey);
			} else {
				if (key is String || key is Number) return _obj[key] != null;
				return _obj[_obj.$_GID] != null;
			}
		}
	}
}
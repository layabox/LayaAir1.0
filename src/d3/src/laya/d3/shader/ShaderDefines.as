package laya.d3.shader {
	
	/**
	 * @private
	 */
	public class ShaderDefines {
		/**@private */
		private var _counter:int;
		/**@private [只读]*/
		public var defines:Array;
		
		/**
		 * @private
		 */
		public function ShaderDefines(superDefines:ShaderDefines = null) {
			if (superDefines) {
				_counter = superDefines._counter;
				defines = superDefines.defines.slice();
			} else {
				_counter = 0;
				defines = [];
			}
		}
		
		/**
		 * @private
		 */
		public function registerDefine(name:String):int {
			var value:int = Math.pow(2, _counter++);//TODO:超界处理
			defines[value] = name;
			return value;
		}
	}

}
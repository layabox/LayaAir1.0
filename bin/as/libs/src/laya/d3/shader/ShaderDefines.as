package laya.d3.shader {
	
	/**
	 * @private
	 */
	public class ShaderDefines {
		/**@private [只读]*/
		public var defineCounter:int;
		/**@private [只读]*/
		public var defines:Array;
		
		/**
		 * @private
		 */
		public function ShaderDefines(shaderdefines:ShaderDefines=null) {
			if (shaderdefines) {
				defineCounter = shaderdefines.defineCounter;
				defines = shaderdefines.defines.slice();
			} else {
				defineCounter = 0;
				defines = [];
			}
		}
		
		/**
		 * @private
		 */
		public function registerDefine(name:String):int {
			var value:int = Math.pow(2, defineCounter++);//TODO:超界处理
			defines[value] = name;
			return value;
		}
	}

}
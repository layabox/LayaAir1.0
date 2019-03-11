package laya.d3.shader {
	
	/**
	 * @private
	 *  <code>shaderVariable</code> 类用于保存shader变量上传相关信息。
	 */
	public class ShaderVariable {
		/**@private */
		public var name:String;
		/**@private */
		public var type:int;
		/**@private */
		public var location:int;
		/**@private */
		public var isArray:Boolean;
		/**@private */
		public var textureID:int;
		/**@private */
		public var dataOffset:int;
		
		/**@private */
		public var caller:*;
		/**@private */
		public var fun:*;
		/**@private */
		public var uploadedValue:Array;
		
		/**
		 * 创建一个 <code>shaderVariable</code> 实例。
		 */
		public function ShaderVariable() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			textureID = -1;
		}
	
	}

}
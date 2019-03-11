package laya.d3.shader {
	import laya.d3.core.IClone;
	
	/**
	 * <code>DefineDatas</code> 类用于创建宏定义数据。
	 */
	public class DefineDatas implements IClone {
		/** @private [只读]*/
		public var value:int;
		
		/**
		 * 创建一个 <code>DefineDatas</code> 实例。
		 */
		public function DefineDatas() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			value = 0;
		}
		
		/**
		 * 增加Shader宏定义。
		 * @param value 宏定义。
		 */
		public function add(define:int):void {
			value |= define;
		}
		
		/**
		 * 移除Shader宏定义。
		 * @param value 宏定义。
		 */
		public function remove(define:int):void {
			value &= ~define;
		}
		
		/**
		 * 是否包含Shader宏定义。
		 * @param value 宏定义。
		 */
		public function has(define:int):Boolean {
			return (value & define) > 0;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destDefineData:DefineDatas = destObject as DefineDatas;
			destDefineData.value = value;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:DefineDatas = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	}

}
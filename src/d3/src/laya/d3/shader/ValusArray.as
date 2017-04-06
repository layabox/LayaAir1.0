package laya.d3.shader {
	
	/**
	 * @private
	 * <code>Shader3D</code> 主要用数组的方式保存shader变量定义，后期合并ShaderValue不使用for in，性能较高。
	 */
	public class ValusArray {
		private var _data:Array;
		
		public function ValusArray() {
			_data = [];
		}
		
		public function setValue(name:int, value:*):void {
			_data[name] = value;
		}
		
		public function get data():Array {
			return _data;
		}
	}

}
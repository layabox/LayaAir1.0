package laya.webgl.utils {
	
	/**
	 * @private
	 * <code>Shader3D</code> 主要用数组的方式保存shader变量定义，后期合并ShaderValue不使用for in，性能较高。
	 */
	public class ValusArray {
		private var _data:Array = [];
		private var _length:int;
		
		public function ValusArray() {
			_data._length = 0;
		}
		
		public function pushValue(name:String, value:*):void {
			setValue(_length, name, value);
			_length += 2;
		}
		
		public function setValue(index:int, name:String, value:*):void {
			_data[index++] = name;
			_data[index] = value;
		}
		
		public function pushArray(value:ValusArray):void {
			var data:Array = _data;
			var len:int = _length;
			var inData:Array = value._data;
			var dec:Array;
			for (var i:int = 0, n:int = value.length; i < n; i++, len++) {
				data[len++] = inData[i++];
				data[len] = inData[i];
			}
			_length = len;
		}
		
		public function get length():int {
			return _length;
		}
		
		public function set length(value:int):void {
			_length = value;
		}
		
		public function get data():Array {
			return _data;
		}
		
		public function copyTo(dec:ValusArray):ValusArray {
			dec || (dec = new ValusArray());
			var values:Array = _data;
			var decData:Array = dec._data;
			for (var i:int = 0; i < _length; i++) {
				//if (values[i] is Array) {
					//debugger;//TODO:
					//var valueArray:Array = values[i];
					//var decDataArray:Array = decData[i] = [];
					//decDataArray.length = valueArray.length;
					//for (var j:int = 0; j < valueArray.length; j++)
						//decDataArray[j] = valueArray[j];
				//} else {
					decData[i] = values[i];
				//}
			}
			dec.length = _length;
			return dec;
		}
	}

}
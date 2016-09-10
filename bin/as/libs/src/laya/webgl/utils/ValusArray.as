package laya.webgl.utils 
{
	
	

	
	 /**
	 * @private
	 * <code>Shader3D</code> 主要用数组的方式保存shader变量定义，后期合并ShaderValue不使用for in，性能较高。
	 */
	public class ValusArray 
	{
		private var _data:Array = [];
		private var _length:int;
		
		public function ValusArray() 
		{
			_data._length = 0;
		}
		
		public function pushValue(name:String,value:*,id:Number):void
		{
			setValue(_length, name, value, id);
			_length += 2;
		}
		
		public function setValue(index:int,name:String,value:*,id:Number):void
		{
			_data[index++ ] = name;
			var d:Array = _data[index];
			d || (d = _data[index] = [value,0]);
			d[0] = value;
			d[1] = id;
		}
		

		public function pushArray(value:ValusArray):void
		{
			var data:Array = _data;
			var len:int = _length;
			var inData:Array = value._data;
			var dec:Array,src:Array;
			for (var i:int = 0, n:int = value.length; i < n; i ++,len++)
			{
				 data[len++] = inData[i++];
				 src = inData[i];
				 (dec=data[len])?(dec[0]=src[0],dec[1]=src[1]):(data[len] = [src[0], src[1]]);
			}
			_length = len;
		}
		
		public function get length():int
		{
			return _length;
		}
		
		public function set length(value:int):void
		{
			_length = value;
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		public function copyTo(dec:ValusArray):ValusArray
		{
			dec || (dec = new ValusArray());
			var values:Array = _data;
			var decData:Array = dec._data;
			for (var i:int = 0; i < _length; i++) {
				if (values[i] is Array) {
					var valueArray:Array = values[i];
					var decDataArray:Array = decData[i] = [];
					decDataArray.length = valueArray.length;
					for (var j:int = 0; j<valueArray.length;j++ )
					decDataArray[j] = valueArray[j];
				}
				else {
					decData[i] = values[i];
				}
			}
			dec.length = _length;
			return dec;
		}
	}

}
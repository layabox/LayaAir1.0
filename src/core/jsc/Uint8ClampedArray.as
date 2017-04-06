/*[IF-FLASH]*/package {
	import flash.utils.ByteArray;	
	/**
	 * @private
	 */
	public class Uint8ClampedArray extends ArrayBuffer{		
		/* 如下几种方式的初始化要实现:
		Uint8Array(length);//创建初始化为0的，包含length个元素的无符号整型数组
		Uint8Array(typedArray);
		Uint8Array(object);
		Uint8Array(buffer [, byteOffset [, length]]);
		*/
		
		/**
		 * 
		 * @param	...args
		 */
		public function Uint8ClampedArray(...args) {
			if ( args.length == 1 ) {
				if ( args[0] is int ) {
					super( args[0] );
				}
				if ( args[0] is ByteArray ) {
					(args[0] as ByteArray).endian = "littleEndian";
					this.length = (args[0] as ByteArray).length;
					setarr( (args[0] as ByteArray) );
					this.endian = "littleEndian";
				}
				if ( args[0] is Object ) {
					
				}
			}
			
		}
		
		/**
		 * 获取此数组引用的 ArrayBuffer。
		 */
		public function get buffer() : ArrayBuffer {
			return (this as ArrayBuffer);
		}
		
		//this.byteLength//只读,此数组距离其ArrayBuffer 开始处的长度（以字节为单位），在构造时已固定。
		//this.length 数组的长度。
		/**
		 * 只读。此数组与其 ArrayBuffer 开始处的偏移量（以字节为单位），在构造时已固定。
		 */
		public function get byteOffset():int{
			return this.position;
		}
		
		
		
		/**
		 * 为此数组获取 ArrayBuffer 存储的新 Uint8Array 视图。
		 * @param	begin
		 * @param	end
		 * @return
		 */
		public function subarray( begin : int, end : int = -1 ) : Uint8Array {
			if ( end == -1 ) end = this.length;
			var tu : Uint8Array = new Uint8Array( end - begin );
			tu.writeBytes( this, begin, end - begin );
			return tu;
		}
		
		
		//uint8Array.set(index, value);
		//uint8Array.set(array, offset);
		/**
		 * 设置值或值数组。
		 */
		public function set(...args):void
		{
			if (args.length == 2){
				if (args[0] is int)
				{
					//(index,value)
					//this[index] = value;
				}else {
					this.position = args[1];
					this.writeBytes(args[0]);
				}
			}
		}
		
	}
}
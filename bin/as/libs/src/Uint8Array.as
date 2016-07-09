/*[IF-FLASH]*/package {
	import flash.utils.ByteArray;	
	/**
	 * @private
	 */
	public class Uint8Array extends ArrayBuffer{		
		/* 如下几种方式的初始化要实现:
		new Uint8Array(length);
		new Uint8Array(typedArray);
		new Uint8Array(object);
		new Uint8Array(buffer [, byteOffset [, length]]);
		*/
		/**
		 * 
		 * @param	...args
		 */
		public function Uint8Array(...args) {
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
				
		public function get buffer() : ArrayBuffer {
			return (this as ArrayBuffer);
		}
		
		public function subarray( begin : int, end : int = -1 ) : Uint8Array {
			if ( end == -1 ) end = this.length;
			var tu : Uint8Array = new Uint8Array( end - begin );
			tu.writeBytes( this, begin, end - begin );
			return tu;
		}
		
	}
}
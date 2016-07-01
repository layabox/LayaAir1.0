/*[IF-FLASH]*/package{
	import flash.utils.ByteArray;	
	/**
	 * @private
	 */
	public class ArrayBuffer extends ByteArray {
		public var byteLength:int;
		public function ArrayBuffer(...args) { 
			if ( args.length == 1 ) {
				if ( args[0] is int ) {
					this.length = args[0];

				}
				if ( args[0] is ByteArray ) {
					var vs : ByteArray = (args[0] as ByteArray);
					this.length = vs.length;
					this.writeBytes( vs, 0, byteLength );
				}			
			}
			
			byteLength = this.length;
		}
				
		/**
		 * ArrayBuffer的数据Copy.
		 * @param	uarr
		 */
		public function setarr( uarr : ByteArray, offset : int = 0 ) : void {
			var max : int = uarr.length < (this.length - offset)?uarr.length:(length - offset);
			this.writeBytes( uarr, offset, max );
		}
		
		/**
		 * 根据传入的位置和长度生成新的ArrayBuffer.
		 * @param	begin
		 * @param	end
		 * @return
		 */
		public function slice( begin: int, end : int = -1 ) : ArrayBuffer {
			if ( end == -1 ) end = this.length;
			var len : int = end - begin;
			var tr : ArrayBuffer = new ArrayBuffer( len );
			tr.writeBytes( this, begin, len );			
			return tr;
		}
		
	}
}
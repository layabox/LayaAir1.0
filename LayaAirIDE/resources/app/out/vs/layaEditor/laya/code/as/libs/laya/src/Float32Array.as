/*[IF-FLASH]*/package
{
	/**
	 * @private
	 */
	public dynamic class Float32Array extends Array {
		public static const BYTES_PER_ELEMENT:int = 32;
		
		public function Float32Array(...arg) { }
		
		public var buffer:*;
		
		public function subarray(start:int, end:int = -1):Float32Array { return null; };
		
		public function set(src:Array, ofs:int):void
		{
			for (var i:int = 0, n:int = src.length; i < n; i++)
			{
				this[i + ofs] = src[i];
			}
		}
		
	}
}
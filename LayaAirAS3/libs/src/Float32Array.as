/*[IF-FLASH]*/package
{
	public dynamic class Float32Array {
		public function Float32Array(...arg) { }
		public var length:int;
		public var buffer:*;
		public function subarray(start:int, end:int = -1):Float32Array { return null; };
		public function set(src:Float32Array, ofs:int):void{};
		
	}
}
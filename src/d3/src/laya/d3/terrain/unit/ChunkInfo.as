package laya.d3.terrain.unit {
	

	/**
	 * <code>DetailTextureInfo</code> 类用于描述地形细节纹理。
	 */
	public class ChunkInfo {
		public var alphaMap:Vector.<String>;
		public var detailID:Vector.<Uint8Array>;
		public var normalMap:String;
		public function ChunkInfo() 
		{
			super();
		}
	}
}
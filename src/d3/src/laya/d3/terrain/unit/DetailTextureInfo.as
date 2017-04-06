package laya.d3.terrain.unit {
	import laya.d3.math.Vector2;

	/**
	 * <code>DetailTextureInfo</code> 类用于描述地形细节纹理。
	 */
	public class DetailTextureInfo{
		public var diffuseTexture:String;
		public var normalTexture:String;
		public var scale:Vector2;
		public var offset:Vector2;
		public function DetailTextureInfo() 
		{	
			super();
		}
	}
}
package laya.d3.terrain.unit {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;

	/**
	 * <code>MaterialInfo</code> 类用于描述地形材质信息。
	 */
	public class MaterialInfo {
		public var ambientColor:Vector3;
		public var diffuseColor:Vector3;
		public var specularColor:Vector4;
		public function MaterialInfo() 
		{	
			super();
		}
	}
}
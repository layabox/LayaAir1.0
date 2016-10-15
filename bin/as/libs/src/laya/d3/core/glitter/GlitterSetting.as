package laya.d3.core.glitter {
	import laya.d3.math.Vector4;
	
	/**
	 * <code>Glitter</code> 类用于创建闪光配置信息。
	 */
	public class GlitterSetting {
		/** 纹理。 */
		public var texturePath:String;
		/** 声明周期。 */
		public var lifeTime:Number = 0.5;
		/** 最小分段距离。 */
		public var minSegmentDistance:Number = 0.1;//小于抛弃不生成分段
		/** 最小插值距离。 */
		public var minInterpDistance:Number = 0.6;//超过则插值
		/** 最大插值数量。 */
		public var maxSlerpCount:int = 128;
		/** 颜色。 */
		public var color:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		/** 最大段数。 */
		public var maxSegments:int = 200;
		
		/**
		 * 创建一个 <code>GlitterSettings</code> 实例。
		 */
		public function GlitterSetting() {
		}
	
	}

}
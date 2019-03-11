package laya.d3.core {
	
	/**
	 * <code>FloatArrayKeyframe</code> 类用于创建浮点数组关键帧实例。
	 */
	public class FloatArrayKeyframe extends Keyframe {
		public var data:Float32Array;//包含inTangent、outTangent、value,合并可降低Float32Array对象数量过多带来的基础内存消耗
		
		/**
		 * 创建一个 <code>FloatArrayKeyFrame</code> 实例。
		 */
		public function FloatArrayKeyframe() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destKeyFrame:FloatArrayKeyframe = destObject as FloatArrayKeyframe;
			destKeyFrame.data = data.slice() as Float32Array;
		}
	}

}
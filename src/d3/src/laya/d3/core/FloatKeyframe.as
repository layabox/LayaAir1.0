package laya.d3.core {
	
	/**
	 * <code>FloatKeyFrame</code> 类用于创建浮点关键帧实例。
	 */
	public class FloatKeyframe extends Keyframe {
		public var inTangent:Number;
		public var outTangent:Number;
		public var value:Number;
		
		/**
		 * 创建一个 <code>FloatKeyFrame</code> 实例。
		 */
		public function FloatKeyframe() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destKeyFrame:FloatKeyframe = destObject as FloatKeyframe;
			destKeyFrame.inTangent = inTangent;
			destKeyFrame.outTangent = outTangent;
			destKeyFrame.value = value;
		}
	
	}

}
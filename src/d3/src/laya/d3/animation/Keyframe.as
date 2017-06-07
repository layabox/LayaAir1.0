package laya.d3.animation {
	
	/**
	 * @private
	 */
	public class Keyframe {
		public var startTime:Number;
		public var inTangent:Number;
		public var outTangent:Number;
		public var data:Float32Array;
		public var duration:Number;
		public var next:Keyframe;
	}
}
package laya.d3.animation {
	
	/**
	 * @private
	 */
	public class KeyframeNode {
		public var path:Vector.<String>;
		public var componentType:String;//TODO:是否去掉
		public var propertyNameID:int;
		public var keyFrameWidth:int;
		public var keyFrames:Vector.<Keyframe>;
		public var isTransformproperty:Boolean;
	}
}
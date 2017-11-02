package laya.d3.animation {
	
	/**
	 * @private
	 */
	public class KeyframeNode {
		public var _cacheProperty:Boolean;
		
		public var path:Vector.<String>;
		public var componentType:String;//TODO:是否去掉
		public var propertyNameID:int;
		public var keyFrameWidth:int;
		public var defaultData:Float32Array;
		public var keyFrames:Vector.<Keyframe>;
	}
}
package laya.d3.animation {
	import laya.d3.core.Keyframe;
	
	/**
	 * @private
	 */
	public class KeyframeNode {
		/**@private */
		private var _ownerPath:Vector.<String> = new Vector.<String>();
		/**@private */
		private var _propertys:Vector.<String> = new Vector.<String>();
		
		/**@private */
		public var _keyFrames:Vector.<Keyframe> = new Vector.<Keyframe>();
		/**@private */
		public var _indexInList:int;
		
		/**@private */
		public var type:int;
		/**@private */
		public var fullPath:String;
		/**@private */
		public var propertyOwner:String;
		
		/**@private */
		public var data:*;
		
		/**
		 * 获取精灵路径个数。
		 * @return 精灵路径个数。
		 */
		public function get ownerPathCount():int {
			return _ownerPath.length;
		}
		
		/**
		 * 获取属性路径个数。
		 * @return 数量路径个数。
		 */
		public function get propertyCount():int {
			return _propertys.length;
		}
		
		/**
		 * 获取帧个数。
		 * 帧个数。
		 */
		public function get keyFramesCount():int {
			return _keyFrames.length;
		}
		
		/**
		 * @private
		 */
		public function _setOwnerPathCount(value:int):void {
			_ownerPath.length = value;
		}
		
		/**
		 * @private
		 */
		public function _setOwnerPathByIndex(index:int, value:String):void {
			_ownerPath[index] = value;
		}
		
		/**
		 * @private
		 */
		public function _joinOwnerPath(sep:String):String {
			return _ownerPath.join(sep);
		}
		
		/**
		 * @private
		 */
		public function _setPropertyCount(value:int):void {
			_propertys.length = value;
		}
		
		/**
		 * @private
		 */
		public function _setPropertyByIndex(index:int, value:String):void {
			_propertys[index] = value;
		}
		
		/**
		 * @private
		 */
		public function _joinProperty(sep:String):String {
			return _propertys.join(sep);
		}
		
		/**
		 * @private
		 */
		public function _setKeyframeCount(value:int):void {
			_keyFrames.length = value;
		}
		
		/**
		 * @private
		 */
		public function _setKeyframeByIndex(index:int, value:Keyframe):void {
			_keyFrames[index] = value;
		}
		
		/**
		 * 通过索引获取精灵路径。
		 * @param index 索引。
		 */
		public function getOwnerPathByIndex(index:int):String {
			return _ownerPath[index];
		}
		
		/**
		 * 通过索引获取属性路径。
		 * @param index 索引。
		 */
		public function getPropertyByIndex(index:int):String {
			return _propertys[index];
		}
		
		/**
		 * 通过索引获取帧。
		 * @param index 索引。
		 */
		public function getKeyframeByIndex(index:int):Keyframe {
			return _keyFrames[index];
		}
	}
}
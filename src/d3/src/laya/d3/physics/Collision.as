package laya.d3.physics {
	import laya.d3.physics.PhysicsComponent;
	
	/**
	 * <code>Collision</code> 类用于创建物理碰撞信息。
	 */
	public class Collision {
		/**@private */
		public var _lastUpdateFrame:int = -2147483648/*int.MIN_VALUE*/;
		/**@private */
		public var _updateFrame:int = -2147483648/*int.MIN_VALUE*/;
		/**@private */
		public var _isTrigger:Boolean = false;
		
		/**@private */
		public var _colliderA:PhysicsComponent;
		/**@private */
		public var _colliderB:PhysicsComponent;
		
		/**@private [只读]*/
		public var contacts:Vector.<ContactPoint> = new Vector.<ContactPoint>();
		/**@private [只读]*/
		public var other:PhysicsComponent;
		
		/**
		 * 创建一个 <code>Collision</code> 实例。
		 */
		public function Collision() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function _setUpdateFrame(farme:int):void {
			_lastUpdateFrame = _updateFrame;//TODO:为啥整两个
			_updateFrame = farme;
		}
	
	}

}
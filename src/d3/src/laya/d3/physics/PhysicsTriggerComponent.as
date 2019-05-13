package laya.d3.physics {
	import laya.components.Component;
	import laya.d3.physics.PhysicsComponent;
	
	/**
	 * <code>PhysicsTriggerComponent</code> 类用于创建物理触发器组件。
	 */
	public class PhysicsTriggerComponent extends PhysicsComponent {
		/** @private */
		private var _isTrigger:Boolean = false;
		
		/**
		 * 获取是否为触发器。
		 * @return 是否为触发器。
		 */
		public function get isTrigger():Boolean {
			return _isTrigger;
		}
		
		/**
		 * 设置是否为触发器。
		 * @param value 是否为触发器。
		 */
		public function set isTrigger(value:Boolean):void {
			_isTrigger = value;
			if (_nativeColliderObject) {
				var flags:int = _nativeColliderObject.getCollisionFlags();
				if (value) {
					if ((flags & COLLISIONFLAGS_NO_CONTACT_RESPONSE) === 0)
						_nativeColliderObject.setCollisionFlags(flags | COLLISIONFLAGS_NO_CONTACT_RESPONSE);
				} else {
					if ((flags & COLLISIONFLAGS_NO_CONTACT_RESPONSE) !== 0)
						_nativeColliderObject.setCollisionFlags(flags ^ COLLISIONFLAGS_NO_CONTACT_RESPONSE);
				}
			}
		}
		
		/**
		 * 创建一个 <code>PhysicsTriggerComponent</code> 实例。
		 * @param collisionGroup 所属碰撞组。
		 * @param canCollideWith 可产生碰撞的碰撞组。
		 */
		public function PhysicsTriggerComponent(collisionGroup:int, canCollideWith:int) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(collisionGroup, canCollideWith);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			super._onAdded();
			isTrigger = _isTrigger;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component):void {
			super._cloneTo(dest);
			(dest as PhysicsTriggerComponent).isTrigger = _isTrigger;
		}
	}
}
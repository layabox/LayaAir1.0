package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.math.Ray;
	import laya.d3.utils.RaycastHit;
	
	/**
	 * <code>Collider</code> 类用于创建碰撞器的父类，抽象类，不允许实例。
	 */
	public class Collider extends Component3D {
		/** @private */
		private static var _isSingleton:Boolean = false;
		
		/** @private */
		protected var _needUpdate:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function get isSingleton():Boolean {
			return _isSingleton;
		}
		
		public function Collider() {
		}
		
		public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = Number.MAX_VALUE):Boolean {
			throw new Error("Must override it.");
		}
	
	}

}
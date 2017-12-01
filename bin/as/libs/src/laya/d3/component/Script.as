package laya.d3.component {
	import laya.d3.component.physics.Collider;
	
	/**
	 * <code>Script</code> 类用于创建脚本的父类。
	 */
	public class Script extends Component3D {
		/** @private */
		private static var _isSingleton:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function get isSingleton():Boolean {
			return _isSingleton;
		}
		
		/**
		 * 创建一个新的 <code>Script</code> 实例。
		 */
		public function Script() {
		}
		
		/**
		 *当其他碰撞器进入时触发。
		 */
		public function onTriggerEnter(other:Collider):void {
		
		}
		
		/**
		 *当其他碰撞器退出时触发。
		 */
		public function onTriggerExit(other:Collider):void {
		
		}
		
		/**
		 *当其他碰撞器保持进入状态时逐帧触发。
		 */
		public function onTriggerStay(other:Collider):void {
		
		}
	
		///**重置默认值*/
		//public function reset():void
		//{
		//
		//}
	}
}
package laya.d3.component {
	
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
	
		///**重置默认值*/
		//public function reset():void
		//{
		//
		//}
	}
}
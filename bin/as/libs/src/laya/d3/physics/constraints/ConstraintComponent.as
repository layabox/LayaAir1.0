package laya.d3.physics.constraints {
	import laya.components.Component;
	import laya.d3.physics.Rigidbody3D;
	
	/**
	 * <code>ConstraintComponent</code> 类用于创建约束的父类。
	 */
	public class ConstraintComponent extends Component {
		/**@private */
		private var _nativeConstraint:*;
		/**@private */
		private var _breakingImpulseThreshold:Number;
		/**@private */
		private var _connectedBody:Rigidbody3D;
		/**@private */
		private var _feedbackEnabled:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function get enabled():Boolean {
			return super.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void {
			_nativeConstraint.IsEnabled = value;
			super.enabled = value;
		}
		
		/**
		 * 获取打破冲力阈值。
		 * @return 打破冲力阈值。
		 */
		public function get breakingImpulseThreshold():Number {
			return _breakingImpulseThreshold;
		}
		
		/**
		 * 设置打破冲力阈值。
		 * @param value 打破冲力阈值。
		 */
		public function set breakingImpulseThreshold(value:Number):void {
			_nativeConstraint.BreakingImpulseThreshold = value;
			_breakingImpulseThreshold = value;
		}
		
		/**
		 * 获取应用的冲力。
		 */
		public function get appliedImpulse():Number {
			if (!_feedbackEnabled) {
				_nativeConstraint.EnableFeedback(true);
				_feedbackEnabled = true;
			}
			return _nativeConstraint.AppliedImpulse;
		}
		
		/**
		 * 获取已连接的刚体。
		 * @return 已连接刚体。
		 */
		public function get connectedBody():Rigidbody3D {
			return _connectedBody;
		}
		
		/**
		 * 设置已连接刚体。
		 * @param value 已连接刚体。
		 */
		public function set connectedBody(value:Rigidbody3D):void {
			_connectedBody = value;
		}
		
		/**
		 * 创建一个 <code>ConstraintComponent</code> 实例。
		 */
		public function ConstraintComponent() {
		
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			var physics3D:* = Laya3D._physics3D;
			physics3D.destroy(_nativeConstraint);
			_nativeConstraint = null;
		}
	}
}
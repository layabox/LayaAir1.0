package laya.physics.joint {
	import laya.components.Component;
	import laya.physics.Physics;
	
	/**
	 * 关节基类
	 */
	public class JointBase extends Component {
		/**原生关节对象*/
		protected var _joint:*;
		
		/**[只读]原生关节对象*/
		public function get joint():* {
			if (!_joint) this._createJoint();
			return _joint;
		}
		
		override protected function _onEnable():void {
			_createJoint();
		}
		
		override protected function _onAwake():void {
			_createJoint();
		}
		
		protected function _createJoint():void {
		}
		
		override protected function _onDisable():void {
			if (_joint) {
				Physics.I._removeJoint(_joint);
				_joint = null;
			}
		}
	}
}
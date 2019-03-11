package laya.physics.joint {
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 齿轮关节：用来模拟两个齿轮间的约束关系，齿轮旋转时，产生的动量有两种输出方式，一种是齿轮本身的角速度，另一种是齿轮表面的线速度
	 */
	public class GearJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]要绑定的第1个关节，类型可以是RevoluteJoint或者PrismaticJoint*/
		public var joint1:*;
		/**[首次设置有效]要绑定的第2个关节，类型可以是RevoluteJoint或者PrismaticJoint*/
		public var joint2:*;
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		/**两个齿轮角速度比例，默认1*/
		private var _ratio:Number = 1;
		
		override protected function _createJoint():void {
			if (!_joint) {
				if (!joint1) throw "Joint1 can not be empty";
				if (!joint2) throw "Joint2 can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2GearJointDef());
				def.bodyA = joint1.owner.getComponent(RigidBody).getBody();
				def.bodyB = joint2.owner.getComponent(RigidBody).getBody();
				def.joint1 = joint1.joint;
				def.joint2 = joint2.joint;
				def.ratio = _ratio;
				def.collideConnected = collideConnected;
				_joint = Physics.I._createJoint(def);
			}
		}
		
		/**两个齿轮角速度比例，默认1*/
		public function get ratio():Number {
			return _ratio;
		}
		
		public function set ratio(value:Number):void {
			_ratio = value;
			if (_joint) _joint.SetRatio(value);
		}
	}
}
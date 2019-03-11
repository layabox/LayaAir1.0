package laya.physics.joint {
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 距离关节：两个物体上面各自有一点，两点之间的距离固定不变
	 */
	public class DistanceJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体，可不设置，默认为左上角空刚体*/
		public var otherBody:RigidBody;
		/**[首次设置有效]自身刚体链接点，是相对于自身刚体的左上角位置偏移*/
		public var selfAnchor:Array = [0, 0];
		/**[首次设置有效]链接刚体链接点，是相对于otherBody的左上角位置偏移*/
		public var otherAnchor:Array = [0, 0];
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		/**约束的目标静止长度*/
		private var _length:Number = 0;
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		private var _frequency:Number = 0;
		/**刚体在回归到节点过程中受到的阻尼，建议取值0~1*/
		private var _damping:Number = 0;
		
		override protected function _createJoint():void {
			if (!_joint) {
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2DistanceJointDef());
				def.bodyA = otherBody ? otherBody.getBody() : Physics.I._emptyBody;
				def.bodyB = selfBody.getBody();
				def.localAnchorA.Set(otherAnchor[0] / Physics.PIXEL_RATIO, otherAnchor[1] / Physics.PIXEL_RATIO);
				def.localAnchorB.Set(selfAnchor[0] / Physics.PIXEL_RATIO, selfAnchor[1] / Physics.PIXEL_RATIO);
				def.frequencyHz = _frequency;
				def.dampingRatio = _damping;
				def.collideConnected = collideConnected;
				var p1:* = def.bodyA.GetWorldPoint(def.localAnchorA, new box2d.b2Vec2());
				var p2:* = def.bodyB.GetWorldPoint(def.localAnchorB, new box2d.b2Vec2());
				def.length = _length / Physics.PIXEL_RATIO || box2d.b2Vec2.SubVV(p2, p1, new box2d.b2Vec2()).Length();
				
				_joint = Physics.I._createJoint(def);
			}
		}
		
		/**约束的目标静止长度*/
		public function get length():Number {
			return _length;
		}
		
		public function set length(value:Number):void {
			_length = value;
			if (_joint) _joint.SetLength(value / Physics.PIXEL_RATIO);
		}
		
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		public function get frequency():Number {
			return _frequency;
		}
		
		public function set frequency(value:Number):void {
			_frequency = value;
			if (_joint) _joint.SetFrequency(value);
		}
		
		/**刚体在回归到节点过程中受到的阻尼，建议取值0~1*/
		public function get damping():Number {
			return _damping;
		}
		
		public function set damping(value:Number):void {
			_damping = value;
			if (_joint) _joint.SetDampingRatio(value);
		}
	}
}
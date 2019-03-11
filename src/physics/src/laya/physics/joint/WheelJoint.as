package laya.physics.joint {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 轮子关节：围绕节点旋转，包含弹性属性，使得刚体在节点位置发生弹性偏移
	 */
	public class WheelJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体*/
		public var otherBody:RigidBody;
		/**[首次设置有效]关节的链接点，是相对于自身刚体的左上角位置偏移*/
		public var anchor:Array = [0, 0];
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		/**[首次设置有效]一个向量值，描述运动方向，比如1,0是沿X轴向右*/
		public var axis:Array = [1, 0];
		
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		private var _frequency:Number = 5;
		/**刚体在回归到节点过程中受到的阻尼，取值0~1*/
		private var _damping:Number = 0.7;
		
		/**是否开启马达，开启马达可使目标刚体运动*/
		private var _enableMotor:Boolean = false;
		/**启用马达后，可以达到的最大旋转速度*/
		private var _motorSpeed:Number = 0;
		/**启用马达后，可以施加的最大扭距，如果最大扭矩太小，会导致不旋转*/
		private var _maxMotorTorque:Number = 10000;
		
		override protected function _createJoint():void {
			if (!_joint) {
				if (!otherBody) throw "otherBody can not be empty";
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2WheelJointDef());
				var anchorPos:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(anchor[0], anchor[1]), false, Physics.I.worldRoot);
				var anchorVec:* = new box2d.b2Vec2(anchorPos.x / Physics.PIXEL_RATIO, anchorPos.y / Physics.PIXEL_RATIO);
				def.Initialize(otherBody.getBody(), selfBody.getBody(), anchorVec, new box2d.b2Vec2(axis[0], axis[1]));
				def.enableMotor = _enableMotor;
				def.motorSpeed = _motorSpeed;
				def.maxMotorTorque = _maxMotorTorque;
				def.frequencyHz = _frequency;
				def.dampingRatio = _damping;
				def.collideConnected = collideConnected;
				
				_joint = Physics.I._createJoint(def);
			}
		}
		
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		public function get frequency():Number {
			return _frequency;
		}
		
		public function set frequency(value:Number):void {
			_frequency = value;
			if (_joint) _joint.SetSpringFrequencyHz(value);
		}
		
		/**刚体在回归到节点过程中受到的阻尼，取值0~1*/
		public function get damping():Number {
			return _damping;
		}
		
		public function set damping(value:Number):void {
			_damping = value;
			if (_joint) _joint.SetSpringDampingRatio(value);
		}
		
		/**是否开启马达，开启马达可使目标刚体运动*/
		public function get enableMotor():Boolean {
			return _enableMotor;
		}
		
		public function set enableMotor(value:Boolean):void {
			_enableMotor = value;
			if (_joint) _joint.EnableMotor(value);
		}
		
		/**启用马达后，可以达到的最大旋转速度*/
		public function get motorSpeed():Number {
			return _motorSpeed;
		}
		
		public function set motorSpeed(value:Number):void {
			_motorSpeed = value;
			if (_joint) _joint.SetMotorSpeed(value);
		}
		
		/**启用马达后，可以施加的最大扭距，如果最大扭矩太小，会导致不旋转*/
		public function get maxMotorTorque():Number {
			return _maxMotorTorque;
		}
		
		public function set maxMotorTorque(value:Number):void {
			_maxMotorTorque = value;
			if (_joint) _joint.SetMaxMotorTorque(value);
		}
	}
}
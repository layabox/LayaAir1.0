package laya.physics.joint {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 旋转关节强制两个物体共享一个锚点，两个物体相对旋转
	 */
	public class RevoluteJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体，可不设置*/
		public var otherBody:RigidBody;
		/**[首次设置有效]关节的链接点，是相对于自身刚体的左上角位置偏移*/
		public var anchor:Array = [0, 0];
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		/**是否开启马达，开启马达可使目标刚体运动*/
		private var _enableMotor:Boolean = false;
		/**启用马达后，可以达到的最大旋转速度*/
		private var _motorSpeed:Number = 0;
		/**启用马达后，可以施加的最大扭距，如果最大扭矩太小，会导致不旋转*/
		private var _maxMotorTorque:Number = 10000;
		
		/**是否对刚体的旋转范围加以约束*/
		private var _enableLimit:Boolean = false;
		/**启用约束后，刚体旋转范围的下限弧度*/
		private var _lowerAngle:Number = 0;
		/**启用约束后，刚体旋转范围的上限弧度*/
		private var _upperAngle:Number = 0;
		
		override protected function _createJoint():void {
			if (!_joint) {
				//if (!otherBody) throw "otherBody can not be empty";
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2RevoluteJointDef());
				var anchorPos:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(anchor[0], anchor[1]), false, Physics.I.worldRoot);
				var anchorVec:* = new box2d.b2Vec2(anchorPos.x / Physics.PIXEL_RATIO, anchorPos.y / Physics.PIXEL_RATIO);
				def.Initialize(otherBody ? otherBody.getBody() : Physics.I._emptyBody, selfBody.getBody(), anchorVec);
				def.enableMotor = _enableMotor;
				def.motorSpeed = _motorSpeed;
				def.maxMotorTorque = _maxMotorTorque;
				def.enableLimit = _enableLimit;
				def.lowerAngle = _lowerAngle;
				def.upperAngle = _upperAngle;
				def.collideConnected = collideConnected;
				
				_joint = Physics.I._createJoint(def);
			}
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
		
		/**是否对刚体的旋转范围加以约束*/
		public function get enableLimit():Boolean {
			return _enableLimit;
		}
		
		public function set enableLimit(value:Boolean):void {
			_enableLimit = value;
			if (_joint) _joint.EnableLimit(value);
		}
		
		/**启用约束后，刚体旋转范围的下限弧度*/
		public function get lowerAngle():Number {
			return _lowerAngle;
		}
		
		public function set lowerAngle(value:Number):void {
			_lowerAngle = value;
			if (_joint) _joint.SetLimits(value, _upperAngle);
		}
		
		/**启用约束后，刚体旋转范围的上限弧度*/
		public function get upperAngle():Number {
			return _upperAngle;
		}
		
		public function set upperAngle(value:Number):void {
			_upperAngle = value;
			if (_joint) _joint.SetLimits(_lowerAngle, value);
		}
	}
}
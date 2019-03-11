package laya.physics.joint {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 平移关节：移动关节允许两个物体沿指定轴相对移动，它会阻止相对旋转
	 */
	public class PrismaticJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体，可不设置，默认为左上角空刚体*/
		public var otherBody:RigidBody;
		/**[首次设置有效]关节的控制点，是相对于自身刚体的左上角位置偏移*/
		public var anchor:Array = [0, 0];
		/**[首次设置有效]一个向量值，描述运动方向，比如1,0是沿X轴向右*/
		public var axis:Array = [1, 0];
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		/**是否开启马达，开启马达可使目标刚体运动*/
		private var _enableMotor:Boolean = false;
		/**启用马达后，在axis坐标轴上移动可以达到的最大速度*/
		private var _motorSpeed:Number = 0;
		/**启用马达后，可以施加的最大作用力*/
		private var _maxMotorForce:Number = 10000;
		
		/**是否对刚体的移动范围加以约束*/
		private var _enableLimit:Boolean = false;
		/**启用约束后，刚体移动范围的下限，是距离anchor的偏移量*/
		private var _lowerTranslation:Number = 0;
		/**启用约束后，刚体移动范围的上限，是距离anchor的偏移量*/
		private var _upperTranslation:Number = 0;
		
		override protected function _createJoint():void {
			if (!_joint) {
				//if (!otherBody) throw "otherBody can not be empty";
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2PrismaticJointDef());
				var anchorPos:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(anchor[0], anchor[1]), false, Physics.I.worldRoot);
				var anchorVec:* = new box2d.b2Vec2(anchorPos.x / Physics.PIXEL_RATIO, anchorPos.y / Physics.PIXEL_RATIO);
				def.Initialize(otherBody ? otherBody.getBody() : Physics.I._emptyBody, selfBody.getBody(), anchorVec, new box2d.b2Vec2(axis[0], axis[1]));
				def.enableMotor = _enableMotor;
				def.motorSpeed = _motorSpeed;
				def.maxMotorForce = _maxMotorForce;
				def.enableLimit = _enableLimit;
				def.lowerTranslation = _lowerTranslation / Physics.PIXEL_RATIO;
				def.upperTranslation = _upperTranslation / Physics.PIXEL_RATIO;
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
		
		/**启用马达后，在axis坐标轴上移动可以达到的最大速度*/
		public function get motorSpeed():Number {
			return _motorSpeed;
		}
		
		public function set motorSpeed(value:Number):void {
			_motorSpeed = value;
			if (_joint) _joint.SetMotorSpeed(value);
		}
		
		/**启用马达后，可以施加的最大作用力*/
		public function get maxMotorForce():Number {
			return _maxMotorForce;
		}
		
		public function set maxMotorForce(value:Number):void {
			_maxMotorForce = value;
			if (_joint) _joint.SetMaxMotorForce(value);
		}
		
		/**是否对刚体的移动范围加以约束*/
		public function get enableLimit():Boolean {
			return _enableLimit;
		}
		
		public function set enableLimit(value:Boolean):void {
			_enableLimit = value;
			if (_joint) _joint.EnableLimit(value);
		}
		
		/**启用约束后，刚体移动范围的下限，是距离anchor的偏移量*/
		public function get lowerTranslation():Number {
			return _lowerTranslation;
		}
		
		public function set lowerTranslation(value:Number):void {
			_lowerTranslation = value;
			if (_joint) _joint.SetLimits(value, _upperTranslation);
		}
		
		/**启用约束后，刚体移动范围的上限，是距离anchor的偏移量*/
		public function get upperTranslation():Number {
			return _upperTranslation;
		}
		
		public function set upperTranslation(value:Number):void {
			_upperTranslation = value;
			if (_joint) _joint.SetLimits(_lowerTranslation, value);
		}
	}
}
package laya.physics.joint {
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 马达关节：用来限制两个刚体，使其相对位置和角度保持不变
	 */
	public class MotorJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体*/
		public var otherBody:RigidBody;
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		/**基于otherBody坐标位置的偏移量，也是selfBody的目标位置*/
		private var _linearOffset:Array = [0, 0];
		/**基于otherBody的角度偏移量，也是selfBody的目标角度*/
		private var _angularOffset:Number = 0;
		/**当selfBody偏离目标位置时，为使其恢复到目标位置，马达关节所施加的最大作用力*/
		private var _maxForce:Number = 1000;
		/**当selfBody角度与目标角度不同时，为使其达到目标角度，马达关节施加的最大扭力*/
		private var _maxTorque:Number = 1000;
		/**selfBody向目标位置移动时的缓动因子，取值0~1，值越大速度越快*/
		private var _correctionFactor:Number = 0.3;
		
		override protected function _createJoint():void {
			if (!_joint) {
				if (!otherBody) throw "otherBody can not be empty";
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2MotorJointDef());
				def.Initialize(otherBody.getBody(), selfBody.getBody());
				def.linearOffset = new box2d.b2Vec2(_linearOffset[0] / Physics.PIXEL_RATIO, _linearOffset[1] / Physics.PIXEL_RATIO);
				def.angularOffset = _angularOffset;
				def.maxForce = _maxForce;
				def.maxTorque = _maxTorque;
				def.correctionFactor = _correctionFactor;
				def.collideConnected = collideConnected;
				
				_joint = Physics.I._createJoint(def);
			}
		}
		
		/**基于otherBody坐标位置的偏移量，也是selfBody的目标位置*/
		public function get linearOffset():Array {
			return _linearOffset;
		}
		
		public function set linearOffset(value:Array):void {
			_linearOffset = value;
			if (_joint) _joint.SetLinearOffset(new window.box2d.b2Vec2(value[0] / Physics.PIXEL_RATIO, value[1] / Physics.PIXEL_RATIO));
		}
		
		/**基于otherBody的角度偏移量，也是selfBody的目标角度*/
		public function get angularOffset():Number {
			return _angularOffset;
		}
		
		public function set angularOffset(value:Number):void {
			_angularOffset = value;
			if (_joint) _joint.SetAngularOffset(value);
		}
		
		/**当selfBody偏离目标位置时，为使其恢复到目标位置，马达关节所施加的最大作用力*/
		public function get maxForce():Number {
			return _maxForce;
		}
		
		public function set maxForce(value:Number):void {
			_maxForce = value;
			if (_joint) _joint.SetMaxForce(value);
		}
		
		/**当selfBody角度与目标角度不同时，为使其达到目标角度，马达关节施加的最大扭力*/
		public function get maxTorque():Number {
			return _maxTorque;
		}
		
		public function set maxTorque(value:Number):void {
			_maxTorque = value;
			if (_joint) _joint.SetMaxTorque(value);
		}
		
		/**selfBody向目标位置移动时的缓动因子，取值0~1，值越大速度越快*/
		public function get correctionFactor():Number {
			return _correctionFactor;
		}
		
		public function set correctionFactor(value:Number):void {
			_correctionFactor = value;
			if (_joint) _joint.SetCorrectionFactor(value);
		}
	}
}
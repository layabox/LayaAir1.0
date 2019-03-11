package laya.physics.joint {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 鼠标关节：鼠标关节用于通过鼠标来操控物体。它试图将物体拖向当前鼠标光标的位置。而在旋转方面就没有限制。
	 */
	public class MouseJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的链接点，是相对于自身刚体的左上角位置偏移，如果不设置，则根据鼠标点击点作为连接点*/
		public var anchor:Array;
		
		/**鼠标关节在拖曳刚体bodyB时施加的最大作用力*/
		private var _maxForce:Number = 10000;
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		private var _frequency:Number = 5;
		/**刚体在回归到节点过程中受到的阻尼，取值0~1*/
		private var _damping:Number = 0.7;
		
		override protected function _onEnable():void {
			//super._onEnable();
			Sprite(owner).on(Event.MOUSE_DOWN, this, onMouseDown);
		}
		
		override protected function _onAwake():void {
		}
		
		private function onMouseDown():void {
			_createJoint();
			Laya.stage.on(Event.MOUSE_MOVE, this, onMouseMove);
			Laya.stage.once(Event.MOUSE_UP, this, onStageMouseUp);
		}
		
		override protected function _createJoint():void {
			if (!_joint) {
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2MouseJointDef());
				if (anchor) {
					var anchorPos:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(anchor[0], anchor[1]), false, Physics.I.worldRoot);
				} else {
					anchorPos = Physics.I.worldRoot.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
				}
				var anchorVec:* = new box2d.b2Vec2(anchorPos.x / Physics.PIXEL_RATIO, anchorPos.y / Physics.PIXEL_RATIO);
				def.bodyA = Physics.I._emptyBody;
				def.bodyB = selfBody.getBody();
				def.target = anchorVec;
				def.frequencyHz = _frequency;
				def.damping = _damping;
				def.maxForce = _maxForce;
				_joint = Physics.I._createJoint(def);
			}
		}
		
		private function onStageMouseUp():void {
			Laya.stage.off(Event.MOUSE_MOVE, this, onMouseMove);
			super._onDisable();
		}
		
		private function onMouseMove():void {
			_joint.SetTarget(new window.box2d.b2Vec2(Physics.I.worldRoot.mouseX / Physics.PIXEL_RATIO, Physics.I.worldRoot.mouseY / Physics.PIXEL_RATIO));
		}
		
		override protected function _onDisable():void {
			Sprite(owner).off(Event.MOUSE_DOWN, this, onMouseDown);
			super._onDisable();
		}
		
		/**鼠标关节在拖曳刚体bodyB时施加的最大作用力*/
		public function get maxForce():Number {
			return _maxForce;
		}
		
		public function set maxForce(value:Number):void {
			_maxForce = value;
			if (_joint) _joint.SetMaxForce(value);
		}
		
		/**弹簧系统的震动频率，可以视为弹簧的弹性系数*/
		public function get frequency():Number {
			return _frequency;
		}
		
		public function set frequency(value:Number):void {
			_frequency = value;
			if (_joint) _joint.SetFrequency(value);
		}
		
		/**刚体在回归到节点过程中受到的阻尼，取值0~1*/
		public function get damping():Number {
			return _damping;
		}
		
		public function set damping(value:Number):void {
			_damping = value;
			if (_joint) _joint.SetDampingRatio(value);
		}
	}
}
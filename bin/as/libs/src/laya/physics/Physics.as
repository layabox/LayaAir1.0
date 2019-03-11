package laya.physics {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.maths.Point;
	import laya.physics.joint.DistanceJoint;
	import laya.physics.joint.GearJoint;
	import laya.physics.joint.MotorJoint;
	import laya.physics.joint.MouseJoint;
	import laya.physics.joint.PrismaticJoint;
	import laya.physics.joint.PulleyJoint;
	import laya.physics.joint.RevoluteJoint;
	import laya.physics.joint.RopeJoint;
	import laya.physics.joint.WeldJoint;
	import laya.physics.joint.WheelJoint;
	import laya.utils.ClassUtils;
	
	/**
	 * 2D物理引擎，使用Box2d驱动
	 */
	public class Physics extends EventDispatcher {
		/**2D游戏默认单位为像素，物理默认单位为米，此值设置了像素和米的转换比率，默认50像素=1米*/
		public static var PIXEL_RATIO:int = 50;
		/**@private */
		private static var _I:Physics;
		
		/**Box2d引擎的全局引用，更多属性和api请参考 http://box2d.org */
		public var box2d:* = window.box2d;
		/**[只读]物理世界引用，更多属性请参考官网 */
		public var world:*;
		/**旋转迭代次数，增大数字会提高精度，但是会降低性能*/
		public var velocityIterations:int = 8;
		/**位置迭代次数，增大数字会提高精度，但是会降低性能*/
		public var positionIterations:int = 3;
		
		/**@private 是否已经激活*/
		private var _enabled:Boolean;
		/**@private 根容器*/
		private var _worldRoot:Sprite;
		/**@private 空的body节点，给一些不需要节点的关节使用*/
		public var _emptyBody:*;
		/**@private */
		public var _eventList:Array = [];
		
		/**全局物理单例*/
		public static function get I():Physics {
			return _I || (_I = new Physics());
		}
		
		public function Physics():void {
			ClassUtils.regShortClassName([BoxCollider, ChainCollider, CircleCollider, PolygonCollider, RigidBody, DistanceJoint, GearJoint, MotorJoint, MouseJoint, PrismaticJoint, PulleyJoint, RevoluteJoint, RopeJoint, WeldJoint, WheelJoint, PhysicsDebugDraw]);
		}
		
		/**
		 * 开启物理世界
		 * options值参考如下：
		   allowSleeping:true,
		   gravity:10,
		   customUpdate:false 自己控制物理更新时机，自己调用Physics.update
		 */
		public static function enable(options:Object = null):void {
			I.start(options);
		}
		
		/**
		 * 开启物理世界
		 * options值参考如下：
		   allowSleeping:true,
		   gravity:10,
		   customUpdate:false 自己控制物理更新时机，自己调用Physics.update
		 */
		public function start(options:Object = null):void {
			if (!_enabled) {
				_enabled = true;
				
				options || (options = {});
				var box2d:* = window.box2d;
				if (box2d == null) {
					console.error("Can not find box2d libs, you should reuqest box2d.js first.");
					return;
				}
				
				var gravity:* = new box2d.b2Vec2(0, options.gravity || 500 / PIXEL_RATIO);
				this.world = new box2d.b2World(gravity);
				this.world.SetContactListener(new ContactListener());
				this.allowSleeping = options.allowSleeping == null ? true : options.allowSleeping;
				if (!options.customUpdate) Laya.physicsTimer.frameLoop(1, this, _update);
				_emptyBody = _createBody(new window.box2d.b2BodyDef());
			}
		}
		
		private function _update():void {
			world.Step(1 / 60, velocityIterations, positionIterations, 3);
			var len:int = _eventList.length;
			if (len > 0) {
				for (var i:int = 0; i < len; i += 2) {
					_sendEvent(_eventList[i], _eventList[i + 1]);
				}
				_eventList.length = 0;
			}
		}
		
		private function _sendEvent(type:int, contact:*):void {
			var colliderA:* = contact.GetFixtureA().collider;
			var colliderB:* = contact.GetFixtureB().collider;
			var ownerA:* = colliderA.owner;
			var ownerB:* = colliderB.owner;
			contact.getHitInfo = function():Object {
				var manifold:* = new box2d.b2WorldManifold();
				this.GetWorldManifold(manifold);
				//第一点？
				var p:* = manifold.points[0];
				p.x *= Physics.PIXEL_RATIO;
				p.y *= Physics.PIXEL_RATIO;
				return manifold;
			}
			if (ownerA) {
				var args:Array = [colliderB, colliderA, contact];
				if (type === 0) {
					ownerA.event(Event.TRIGGER_ENTER, args);
					if (!ownerA["_triggered"]) {
						ownerA["_triggered"] = true;
					} else {
						ownerA.event(Event.TRIGGER_STAY, args);
					}
				} else {
					ownerA["_triggered"] = false;
					ownerA.event(Event.TRIGGER_EXIT, args);
				}
			}
			if (ownerB) {
				args = [colliderA, colliderB, contact];
				if (type === 0) {
					ownerB.event(Event.TRIGGER_ENTER, args);
					if (!ownerB["_triggered"]) {
						ownerB["_triggered"] = true;
					} else {
						ownerB.event(Event.TRIGGER_STAY, args);
					}
				} else {
					ownerB["_triggered"] = false;
					ownerB.event(Event.TRIGGER_EXIT, args);
				}
			}
		}
		
		/**@private */
		public function _createBody(def:*):* {
			if (this.world) {
				return this.world.CreateBody(def);
			} else {
				console.error('The physical engine should be initialized first.use "Physics.enable()"');
				return null;
			}
		}
		
		/**@private */
		public function _removeBody(body:*):void {
			if (this.world) {
				this.world.DestroyBody(body);
			} else {
				console.error('The physical engine should be initialized first.use "Physics.enable()"');
			}
		}
		
		/**@private */
		public function _createJoint(def:*):* {
			if (this.world) {
				return this.world.CreateJoint(def);
			} else {
				console.error('The physical engine should be initialized first.use "Physics.enable()"');
				return null;
			}
		}
		
		/**@private */
		public function _removeJoint(joint:*):void {
			if (this.world) {
				this.world.DestroyJoint(joint);
			} else {
				console.error('The physical engine should be initialized first.use "Physics.enable()"');
			}
		}
		
		/**
		 * 停止物理世界
		 */
		public function stop():void {
			Laya.physicsTimer.clear(this, _update);
		}
		
		/**
		 * 设置是否允许休眠，休眠可以提高稳定性和性能，但通常会牺牲准确性
		 */
		public function get allowSleeping():Boolean {
			return this.world.GetAllowSleeping();
		}
		
		public function set allowSleeping(value:Boolean):void {
			this.world.SetAllowSleeping(value);
		}
		
		/**
		 * 物理世界重力环境，默认值为{x:0,y:1}
		 * 如果修改y方向重力方向向上，可以直接设置gravity.y=-1;
		 */
		public function get gravity():Object {
			return this.world.GetGravity();
		}
		
		public function set gravity(value:Object):void {
			this.world.SetGravity(value);
		}
		
		/**获得刚体总数量*/
		public function getBodyCount():int {
			return this.world.GetBodyCount();
		}
		
		/**获得碰撞总数量*/
		public function getContactCount():int {
			return this.world.GetContactCount();
		}
		
		/**获得关节总数量*/
		public function getJointCount():int {
			return this.world.GetJointCount();
		}
		
		/**物理世界根容器，将根据此容器作为物理世界坐标世界，进行坐标变换，默认值为stage
		 * 设置特定容器后，就可整体位移物理对象，保持物理世界不变*/
		public function get worldRoot():Sprite {
			return _worldRoot || Laya.stage;
		}
		
		public function set worldRoot(value:Sprite):void {
			_worldRoot = value;
			if (value) {
				//TODO：
				var p:Point = value.localToGlobal(Point.TEMP.setTo(0, 0));
				world.ShiftOrigin({x: p.x / PIXEL_RATIO, y: p.y / PIXEL_RATIO});
			}
		}
	}
}
import laya.physics.Physics;

/**@private */
class ContactListener {
	public function BeginContact(contact:*):void {
		Physics.I._eventList.push(0, contact);
		//console.log("BeginContact", contact);	
	}
	
	public function EndContact(contact:*):void {
		Physics.I._eventList.push(1, contact);
		//console.log("EndContact", contact);
	}
	
	public function PreSolve(contact:*, oldManifold:*):void {
		//console.log("PreSolve", contact);
	}
	
	public function PostSolve(contact:*, impulse:*):void {
		//console.log("PostSolve", contact);
	}
}
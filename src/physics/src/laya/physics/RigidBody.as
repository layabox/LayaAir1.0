package laya.physics {
	import laya.components.Component;
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.utils.Utils;
	
	/**
	 * 2D刚体，显示对象通过RigidBody和物理世界进行绑定，保持物理和显示对象之间的位置同步
	 * 物理世界的位置变化会自动同步到显示对象，显示对象本身的位移，旋转（父对象位移无效）也会自动同步到物理世界
	 * 由于引擎限制，暂时不支持以下情形：
	 * 1.不支持绑定节点缩放
	 * 2.不支持绑定节点的父节点缩放和旋转
	 * 3.不支持实时控制父对象位移，IDE内父对象位移是可以的
	 * 如果想整体位移物理世界，可以Physics.I.worldRoot=场景，然后移动场景即可
	 * 可以通过IDE-"项目设置" 开启物理辅助线显示，或者通过代码PhysicsDebugDraw.enable();
	 */
	public class RigidBody extends Component {
		/**
		 * 刚体类型，支持三种类型static，dynamic和kinematic类型，默认为dynamic类型
		 * static为静态类型，静止不动，不受重力影响，质量无限大，可以通过节点移动，旋转，缩放进行控制
		 * dynamic为动态类型，受重力影响
		 * kinematic为运动类型，不受重力影响，可以通过施加速度或者力的方式使其运动
		 */
		protected var _type:String = "dynamic";
		/**是否允许休眠，允许休眠能提高性能*/
		protected var _allowSleep:Boolean = true;
		/**角速度，设置会导致旋转*/
		protected var _angularVelocity:Number = 0;
		/**旋转速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		protected var _angularDamping:Number = 0;
		/**线性运动速度，比如{x:10,y:10}*/
		protected var _linearVelocity:Object = {x: 0, y: 0};
		/**线性速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		protected var _linearDamping:Number = 0;
		/**是否高速移动的物体，设置为true，可以防止高速穿透*/
		protected var _bullet:Boolean = false;
		/**是否允许旋转，如果不希望刚体旋转，这设置为false*/
		protected var _allowRotation:Boolean = true;
		/**重力缩放系数，设置为0为没有重力*/
		protected var _gravityScale:Number = 1;
		
		/**[只读] 指定了该主体所属的碰撞组，默认为0，碰撞规则如下：
		 * 1.如果两个对象group相等
		 * 		group值大于零，它们将始终发生碰撞
		 * 		group值小于零，它们将永远不会发生碰撞
		 * 		group值等于0，则使用规则3
		 * 2.如果group值不相等，则使用规则3
		 * 3.每个刚体都有一个category类别，此属性接收位字段，范围为[1,2^31]范围内的2的幂
		 * 每个刚体也都有一个mask类别，指定与其碰撞的类别值之和（值是所有category按位AND的值）
		 */
		public var group:int = 0;
		/**[只读]碰撞类别，使用2的幂次方值指定，有32种不同的碰撞类别可用*/
		public var category:int = 1;
		/**[只读]指定冲突位掩码碰撞的类别，category位操作的结果*/
		public var mask:int = -1;
		/**[只读]自定义标签*/
		public var label:String = "RigidBody";
		/**[只读]原始刚体*/
		protected var _body:*;
		
		private function _createBody():void {
			if (_body) return;
			var sp:Sprite = owner as Sprite;
			var box2d:* = window.box2d;
			var def:* = new box2d.b2BodyDef();
			var point:Point = Sprite(owner).localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			def.position.Set(point.x / Physics.PIXEL_RATIO, point.y / Physics.PIXEL_RATIO);
			def.angle = Utils.toRadian(sp.rotation);
			def.allowSleep = _allowSleep;
			def.angularDamping = _angularDamping;
			def.angularVelocity = _angularVelocity;
			def.bullet = _bullet;
			def.fixedRotation = !_allowRotation;
			def.gravityScale = _gravityScale;
			def.linearDamping = _linearDamping;
			var obj:Object = _linearVelocity;
			if (obj && obj.x != 0 || obj.y != 0) {
				def.linearVelocity = new box2d.b2Vec2(obj.x, obj.y);
			}
			def.type = box2d.b2BodyType["b2_" + _type + "Body"];
			//def.userData = label;
			
			_body = Physics.I._createBody(def);
			//trace(body);
			
			//查找碰撞体
			resetCollider(false);
		}
		
		override protected function _onAwake():void {
			this._createBody();
		}
		
		override protected function _onEnable():void {
			this._createBody();
			//实时同步物理到节点
			Laya.physicsTimer.frameLoop(1, this, _sysPhysicToNode);
			
			//监听节点变化，同步到物理世界
			var sp:* = owner as Sprite;
			//如果节点发生变化，则同步到物理世界（仅限节点本身，父节点发生变化不会自动同步）
			if (sp._$set_x && !sp._changeByRigidBody) {
				sp._changeByRigidBody = true;
				function setX(value:*):void {
					sp._$set_x(value);
					_sysPosToPhysic();
				}
				_overSet(sp, "x", setX);
				
				function setY(value:*):void {
					sp._$set_y(value);
					_sysPosToPhysic();
				};
				_overSet(sp, "y", setY);
				
				function setRotation(value:*):void {
					sp._$set_rotation(value);
					_sysNodeToPhysic();
				};
				_overSet(sp, "rotation", setRotation);
				
				function setScaleX(value:*):void {
					sp._$set_scaleX(value);
					resetCollider(true);
				};
				_overSet(sp, "scaleX", setScaleX);
				
				function setScaleY(value:*):void {
					sp._$set_scaleY(value);
					resetCollider(true);
				};
				_overSet(sp, "scaleY", setScaleY);
			}
		}
		
		/**
		 * 重置Collider
		 * @param	resetShape 是否先重置形状，比如缩放导致碰撞体变化
		 */
		private function resetCollider(resetShape:Boolean):void {
			//查找碰撞体
			var comps:Array = owner.getComponents(ColliderBase);
			if (comps) {
				for (var i:int = 0, n:int = comps.length; i < n; i++) {
					var collider:ColliderBase = comps[i];
					collider.rigidBody = this;
					if (resetShape) collider.resetShape();
					else collider.refresh();
				}
			}
		}
		
		/**@private 同步物理坐标到游戏坐标*/
		private function _sysPhysicToNode():void {
			if (type != "static" && _body.IsAwake()) {
				var pos:* = _body.GetPosition();
				var ang:* = _body.GetAngle();
				var sp:* = owner as Sprite;
				
				//if (label == "tank") console.log("get",ang);
				sp._$set_rotation(Utils.toAngle(ang) - Sprite(sp.parent).globalRotation);
				
				if (ang == 0) {
					var point:Point = sp.parent.globalToLocal(Point.TEMP.setTo(pos.x * Physics.PIXEL_RATIO + sp.pivotX, pos.y * Physics.PIXEL_RATIO + sp.pivotY), false, Physics.I.worldRoot);
					sp._$set_x(point.x);
					sp._$set_y(point.y);
				} else {
					point = sp.globalToLocal(Point.TEMP.setTo(pos.x * Physics.PIXEL_RATIO, pos.y * Physics.PIXEL_RATIO), false, Physics.I.worldRoot);
					point.x += sp.pivotX;
					point.y += sp.pivotY;
					point = sp.toParentPoint(point);
					sp._$set_x(point.x);
					sp._$set_y(point.y);
				}
			}
		}
		
		/**@private 同步节点坐标及旋转到物理世界*/
		private function _sysNodeToPhysic():void {
			var sp:Sprite = Sprite(owner);
			this._body.SetAngle(Utils.toRadian(sp.rotation));
			var p:Point = sp.localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			this._body.SetPositionXY(p.x / Physics.PIXEL_RATIO, p.y / Physics.PIXEL_RATIO);
		}
		
		/**@private 同步节点坐标到物理世界*/
		private function _sysPosToPhysic():void {
			var sp:Sprite = Sprite(owner);
			var p:Point = sp.localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			this._body.SetPositionXY(p.x / Physics.PIXEL_RATIO, p.y / Physics.PIXEL_RATIO);
		}
		
		/**@private */
		private function _overSet(sp:Sprite, prop:String, getfun:Function):void {
			__JS__('Object.defineProperty(sp, prop, {get: sp["_$get_" + prop], set: getfun, enumerable: false, configurable: true});');
		}
		
		override protected function _onDisable():void {
			//添加到物理世界
			Laya.physicsTimer.clear(this, _sysPhysicToNode);
			Physics.I._removeBody(_body);
			_body = null;
			
			var owner:* = this.owner;
			if (owner._changeByRigidBody) {
				_overSet(owner, "x", owner._$set_x);
				_overSet(owner, "y", owner._$set_y);
				_overSet(owner, "rotation", owner._$set_rotation);
				_overSet(owner, "scaleX", owner._$set_scaleX);
				_overSet(owner, "scaleY", owner._$set_scaleY);
				owner._changeByRigidBody = false;
			}
		}
		
		/**获得原始body对象 */
		public function getBody():* {
			if (!_body) _onAwake();
			return _body;
		}
		
		/**[只读]获得原始body对象 */
		public function get body():* {
			if (!_body) _onAwake();
			return _body;
		}
		
		/**
		 * 对刚体施加力
		 * @param	position 施加力的点，如{x:100,y:100}，全局坐标
		 * @param	force	施加的力，如{x:0.1,y:0.1}
		 */
		public function applyForce(position:Object, force:Object):void {
			if (!_body) _onAwake();
			_body.ApplyForce(force, position);
		}
		
		/**
		 * 从中心点对刚体施加力，防止对象旋转
		 * @param	force	施加的力，如{x:0.1,y:0.1}
		 */
		public function applyForceToCenter(force:Object):void {
			if (!_body) _onAwake();
			_body.ApplyForceToCenter(force);
		}
		
		/**
		 * 施加速度冲量，添加的速度冲量会与刚体原有的速度叠加，产生新的速度
		 * @param	position 施加力的点，如{x:100,y:100}，全局坐标
		 * @param	impulse	施加的速度冲量，如{x:0.1,y:0.1}
		 */
		public function applyLinearImpulse(position:Object, impulse:Object):void {
			if (!_body) _onAwake();
			_body.ApplyLinearImpulse(impulse, position);
		}
		
		/**
		 * 施加速度冲量，添加的速度冲量会与刚体原有的速度叠加，产生新的速度
		 * @param	impulse	施加的速度冲量，如{x:0.1,y:0.1}
		 */
		public function applyLinearImpulseToCenter(impulse:Object):void {
			if (!_body) _onAwake();
			_body.ApplyLinearImpulseToCenter(impulse);
		}
		
		/**
		 * 对刚体施加扭矩，使其旋转
		 * @param	torque	施加的扭矩
		 */
		public function applyTorque(torque:Number):void {
			if (!_body) _onAwake();
			_body.ApplyTorque(torque);
		}
		
		/**
		 * 设置速度，比如{x:10,y:10}
		 * @param	velocity
		 */
		public function setVelocity(velocity:Object):void {
			if (!_body) _onAwake();
			_body.SetLinearVelocity(velocity);
		}
		
		/**
		 * 设置角度
		 * @param	value 单位为弧度
		 */
		public function setAngle(value:Object):void {
			if (!_body) _onAwake();
			_body.SetAngle(value);
			_body.SetAwake(true);
		}
		
		/**获得刚体质量*/
		public function getMass():Number {
			return _body ? _body.GetMass() : 0;
		}
		
		/**
		 * 获得质心的相对节点0,0点的位置偏移
		 */
		public function getCenter():Object {
			if (!_body) _onAwake();
			var p:Point = _body.GetLocalCenter();
			p.x = p.x * Physics.PIXEL_RATIO;
			p.y = p.y * Physics.PIXEL_RATIO;
			return p;
		}
		
		/**
		 * 获得质心的世界坐标，相对于Physics.I.worldRoot节点
		 */
		public function getWorldCenter():Object {
			if (!_body) _onAwake();
			var p:Point = _body.GetWorldCenter();
			p.x = p.x * Physics.PIXEL_RATIO;
			p.y = p.y * Physics.PIXEL_RATIO;
			return p;
		}
		
		/**
		 * 刚体类型，支持三种类型static，dynamic和kinematic类型
		 * static为静态类型，静止不动，不受重力影响，质量无限大，可以通过节点移动，旋转，缩放进行控制
		 * dynamic为动态类型，接受重力影响
		 * kinematic为运动类型，不受重力影响，可以通过施加速度或者力的方式使其运动
		 */
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
			if (_body) _body.SetType(window.box2d.b2BodyType["b2_" + _type + "Body"]);
		}
		
		/**重力缩放系数，设置为0为没有重力*/
		public function get gravityScale():Number {
			return _gravityScale;
		}
		
		public function set gravityScale(value:Number):void {
			_gravityScale = value;
			if (_body) _body.SetGravityScale(value);
		}
		
		/**是否允许旋转，如果不希望刚体旋转，这设置为false*/
		public function get allowRotation():Boolean {
			return _allowRotation;
		}
		
		public function set allowRotation(value:Boolean):void {
			_allowRotation = value;
			if (_body) _body.SetFixedRotation(!value);
		}
		
		/**是否允许休眠，允许休眠能提高性能*/
		public function get allowSleep():Boolean {
			return _allowSleep;
		}
		
		public function set allowSleep(value:Boolean):void {
			_allowSleep = value;
			if (_body) _body.SetSleepingAllowed(value);
		}
		
		/**旋转速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		public function get angularDamping():Number {
			return _angularDamping;
		}
		
		public function set angularDamping(value:Number):void {
			_angularDamping = value;
			if (_body) _body.SetAngularDamping(value);
		}
		
		/**角速度，设置会导致旋转*/
		public function get angularVelocity():Number {
			if (_body) return _body.GetAngularVelocity();
			return _angularVelocity;
		}
		
		public function set angularVelocity(value:Number):void {
			_angularVelocity = value;
			if (_body) _body.SetAngularVelocity(value);
		}
		
		/**线性速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		public function get linearDamping():Number {
			return _linearDamping;
		}
		
		public function set linearDamping(value:Number):void {
			_linearDamping = value;
			if (_body) _body.SetLinearDamping(value);
		}
		
		/**线性运动速度，比如{x:5,y:5}*/
		public function get linearVelocity():Object {
			if (_body) {
				var vec:* = _body.GetLinearVelocity();
				return {x: vec.x, y: vec.y};
			}
			return _linearVelocity;
		}
		
		public function set linearVelocity(value:Object):void {
			if (!value) return;
			if (value is Array) {
				value = {x: value[0], y: value[1]};
			}
			_linearVelocity = value;
			if (_body) _body.SetLinearVelocity(new window.box2d.b2Vec2(value.x, value.y));
		}
		
		/**是否高速移动的物体，设置为true，可以防止高速穿透*/
		public function get bullet():Boolean {
			return _bullet;
		}
		
		public function set bullet(value:Boolean):void {
			_bullet = value;
			if (_body) _body.SetBullet(value);
		}
	}
}
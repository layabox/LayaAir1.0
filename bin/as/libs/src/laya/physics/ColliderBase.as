package laya.physics {
	import laya.components.Component;
	
	/**
	 * 碰撞体基类
	 */
	public class ColliderBase extends Component {
		/**是否是传感器，传感器能够触发碰撞事件，但不会产生碰撞反应*/
		private var _isSensor:Boolean = false;
		/**密度值，值可以为零或者是正数，建议使用相似的密度，这样做可以改善堆叠稳定性，默认值为10*/
		private var _density:Number = 10;
		/**摩擦力，取值范围0-1，值越大，摩擦越大，默认值为0.2*/
		private var _friction:Number = 0.2;
		/**弹性系数，取值范围0-1，值越大，弹性越大，默认值为0*/
		private var _restitution:Number = 0;
		/**标签*/
		public var label:String;
		
		/**@private b2Shape对象*/
		protected var _shape:*;
		/**@private b2FixtureDef对象 */
		protected var _def:*;
		/**[只读]b2Fixture对象 */
		public var fixture:*;
		/**[只读]刚体引用*/
		public var rigidBody:RigidBody;
		
		/**@private 获取碰撞体信息*/
		protected function getDef():* {
			if (!_def) {
				var def:* = new window.box2d.b2FixtureDef();
				def.density = density;
				def.friction = friction;
				def.isSensor = isSensor;
				def.restitution = restitution;
				def.shape = _shape;
				_def = def;
			}
			return _def;
		}
		
		override protected function _onEnable():void {
			rigidBody || Laya.systemTimer.callLater(this, _checkRigidBody);
		}
		
		private function _checkRigidBody():void {
			if (!rigidBody) {
				var comp:RigidBody = owner.getComponent(RigidBody);
				if (comp) {
					this.rigidBody = comp;
					refresh();
				}
			}
		}
		
		override protected function _onDestroy():void {
			if (rigidBody) {
				if (fixture) {
					if (fixture.GetBody() == rigidBody.body) {
						rigidBody.body.DestroyFixture(fixture);
					}
					//fixture.Destroy();
					fixture = null;
				}
				rigidBody = null;
				_shape = null;
				_def = null;
			}
		}
		
		/**是否是传感器，传感器能够触发碰撞事件，但不会产生碰撞反应*/
		public function get isSensor():Boolean {
			return _isSensor;
		}
		
		public function set isSensor(value:Boolean):void {
			_isSensor = value;
			if (_def) {
				_def.isSensor = value;
				refresh();
			}
		}
		
		/**密度值，值可以为零或者是正数，建议使用相似的密度，这样做可以改善堆叠稳定性，默认值为10*/
		public function get density():Number {
			return _density;
		}
		
		public function set density(value:Number):void {
			_density = value;
			if (_def) {
				_def.density = value;
				refresh();
			}
		}
		
		/**摩擦力，取值范围0-1，值越大，摩擦越大，默认值为0.2*/
		public function get friction():Number {
			return _friction;
		}
		
		public function set friction(value:Number):void {
			_friction = value;
			if (_def) {
				_def.friction = value;
				refresh();
			}
		}
		
		/**弹性系数，取值范围0-1，值越大，弹性越大，默认值为0*/
		public function get restitution():Number {
			return _restitution;
		}
		
		public function set restitution(value:Number):void {
			_restitution = value;
			if (_def) {
				_def.restitution = value;
				refresh();
			}
		}
		
		/**
		 * @private
		 * 碰撞体参数发生变化后，刷新物理世界碰撞信息
		 */
		public function refresh():void {
			if (enabled && rigidBody) {
				var body:* = rigidBody.body;
				if (fixture) {
					//trace(fixture);
					if (fixture.GetBody() == rigidBody.body) {
						rigidBody.body.DestroyFixture(fixture);
					}
					fixture.Destroy();
					fixture = null;
				}
				var def:* = getDef();
				def.filter.groupIndex = rigidBody.group;
				def.filter.categoryBits = rigidBody.category;
				def.filter.maskBits = rigidBody.mask;
				fixture = body.CreateFixture(def);
				fixture.collider = this;
			}
		}
		
		/**
		 * @private
		 * 重置形状
		 */
		public function resetShape(re:Boolean = true):void {
		
		}
		
		/**
		 * 获取是否为单实例组件。
		 */
		override public function get isSingleton():Boolean {
			return false;
		}
	}
}
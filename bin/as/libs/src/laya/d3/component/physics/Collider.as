package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Ray;
	import laya.d3.utils.RaycastHit;
	import laya.events.Event;
	
	/**
	 * <code>Collider</code> 类用于创建碰撞器的父类，抽象类，不允许实例。
	 */
	public class Collider extends Component3D {
		/** @private */
		private static var _isSingleton:Boolean = false;
		/** @private */
		protected var _needUpdate:Boolean;
		/** @private 只读，不允许修改。*/
		public var _isRigidbody:Boolean;
		/** @private */
		public var _runtimeCollisonMap:Object;
		/** @private */
		public var _runtimeCollisonTestMap:Object;
		/** @private */
		public var _ignoreCollisonMap:Object;
		
		/** 是否为触发器。*/
		public var isTrigger:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function set enable(value:Boolean):void {
			if (_enable !== value) {
				var owner:Sprite3D = _owner as Sprite3D;
				if (owner.displayedInStage)
					(value) || (_clearCollsionMap()); //移除碰撞列表以及需要检测碰撞列表
				_enable = value;
				this.event(Event.ENABLE_CHANGED, _enable);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isSingleton():Boolean {
			return _isSingleton;
		}
		
		/**
		 * 创建一个 <code>Collider</code> 实例。
		 */
		public function Collider() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_isRigidbody = false;
			_runtimeCollisonMap = {};
			_runtimeCollisonTestMap = {};
			_ignoreCollisonMap = {};
			isTrigger = true;
		}
		
		/**
		 * @private
		 */
		public function _clearCollsionMap():void {
			for (var k:String in _runtimeCollisonMap) {
				var otherCollider:Collider = _runtimeCollisonMap[k];
				delete otherCollider._runtimeCollisonMap[id];
				if (otherCollider._isRigidbody)
					delete otherCollider._runtimeCollisonTestMap[id];
				
				var otherID:int = otherCollider.id;
				delete _runtimeCollisonMap[otherID];
				if (_isRigidbody)
					delete _runtimeCollisonTestMap[otherID];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _unload(owner:ComponentNode):void {
			for (var k:String in _runtimeCollisonMap) {
				var otherCollider:Collider = _runtimeCollisonMap[k];
				delete otherCollider._runtimeCollisonMap[id];
				if (otherCollider._isRigidbody)
					delete otherCollider._runtimeCollisonTestMap[id];
				
				delete _ignoreCollisonMap[k]._ignoreCollisonMap[id];
			}
		}
		
		/**
		 * @private
		 */
		public function _setIsRigidbody(value:Boolean):void {
			if (_isRigidbody !== value) {
				_isRigidbody = value;
				var owner:Sprite3D = _owner as Sprite3D;
				if (owner.displayedInStage) {
					var layer:Layer = owner.layer;
					layer._removeCollider(this);
					layer._addCollider(this);
				}
			}
		}
		
		/**
		 *@private
		 */
		public function _getType():int {
			return -1;
		}
		
		/**
		 * @private
		 */
		public function _collisonTo(other:Collider):Boolean {
			return false;
		}
		
		/**
		 * 在场景中投下可与球体碰撞器碰撞的一条光线,获取发生碰撞的球体碰撞器信息。
		 * @param  ray        射线
		 * @param  outHitInfo 与该射线发生碰撞球体碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值
		 */
		public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = 1.79e+308/*Number.MAX_VALUE*/):Boolean {
			throw new Error("Collider:Must override it.");
		}
	
	}

}
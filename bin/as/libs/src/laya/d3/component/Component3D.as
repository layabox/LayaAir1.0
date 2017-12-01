package laya.d3.component {
	import laya.d3.core.ComponentNode;
	import laya.d3.core.render.IUpdate;
	import laya.d3.core.render.RenderState;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.resource.IDestroy;
	
	/**
	 * 在enable属性发生变化后调度。
	 * @eventType Event.ENABLED_CHANGED
	 */
	[Event(name = "enabledchanged", type = "laya.events.Event")]
	
	/**
	 * <code>Component3D</code> 类用于创建组件的父类。
	 */
	public class Component3D extends EventDispatcher implements IUpdate, IDestroy {
		/** @private */
		private static var _isSingleton:Boolean = true;
		
		/**@private */
		private var _destroyed:Boolean;
		/** @private 唯一标识ID计数器。*/
		protected static var _uniqueIDCounter:int = 1;
		/** @private 唯一标识ID。*/
		protected var _id:int;
		/** @private 是否启动。*/
		protected var _enable:Boolean;
		/** @private 所属Sprite3D节点。*/
		protected var _owner:ComponentNode;
		
		/**是否已执行start函数。*/
		public var started:Boolean;
		
		/**
		 * 获取唯一标识ID。
		 * @return 唯一标识ID。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取所属Sprite3D节点。
		 * @return 所属Sprite3D节点。
		 */
		public function get owner():ComponentNode {
			return _owner;
		}
		
		/**
		 * 获取是否启用。
		 * @return 是否启动。
		 */
		public function get enable():Boolean {
			return _enable;
		}
		
		/**
		 * 设置是否启用。
		 * @param value 是否启动
		 */
		public function set enable(value:Boolean):void {
			if (_enable !== value) {
				_enable = value;
				this.event(Event.ENABLE_CHANGED, _enable);
			}
		}
		
		/**
		 * 获取是否为单实例组件。
		 * @return  是否为单实例组件。
		 */
		public function get isSingleton():Boolean {
			return _isSingleton;
		}
		
		/**
		 * 获取是否已销毁。
		 * @return 是否已销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个新的 <code>Component3D</code> 实例。
		 */
		public function Component3D() {
			_destroyed = false;
			_id = _uniqueIDCounter;
			_uniqueIDCounter++;
		}
		
		/**
		 * @private
		 * 初始化组件。
		 * @param	owner 所属Sprite3D节点。
		 */
		public function _initialize(owner:ComponentNode):void {
			_owner = owner;
			_enable = true;
			started = false;
			_load(owner);
		}
		
		/**
		 * @private
		 * 销毁组件。
		 */
		public function _destroy():void {
			_unload(_owner);
			_owner = null;
			_destroyed = true;
		}
		
		/**
		 * @private
		 * 载入组件时执行,可重写此函数。
		 */
		public function _load(owner:ComponentNode):void {
		}
		
		/**
		 * @private
		 * 在任意第一次更新时执行,可重写此函数。
		 */
		public function _start(state:RenderState):void {
		}
		
		/**
		 * @private
		 * 更新组件,可重写此函数。
		 * @param	state 渲染状态参数。
		 */
		public function _update(state:RenderState):void {
		}
		
		/**
		 * @private
		 * 更新的最后阶段执行,可重写此函数。
		 * @param state 渲染状态参数。
		 */
		public function _lateUpdate(state:RenderState):void {
		}
		
		/**
		 * @private
		 * 渲染前设置组件相关参数,可重写此函数。
		 * @param	state 渲染状态参数。
		 */
		public function _preRenderUpdate(state:RenderState):void {
		}
		
		/**
		 *  @private
		 * 渲染的最后阶段执行,可重写此函数。
		 * @param	state 渲染状态参数。
		 */
		public function _postRenderUpdate(state:RenderState):void {
		}
		
		/**
		 * @private
		 * 卸载组件时执行,可重写此函数。
		 */
		public function _unload(owner:ComponentNode):void {
			this.offAll();
		}
		
		/**
		 * @private
		 */
		public function _cloneTo(dest:Component3D):void {
		}
	}
}
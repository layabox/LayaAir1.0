package laya.d3.component {
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.IUpdate;
	import laya.d3.core.render.RenderState;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * 在enable属性发生变化后调度。
	 * @eventType Event.ENABLED_CHANGED
	 */
	[Event(name = "enabledchanged", type = "laya.events.Event")]
	
	/**
	 * <code>Component3D</code> 类用于创建组件的父类。
	 */
	public class Component3D extends EventDispatcher implements IUpdate {
		/** @private 唯一标识ID计数器。*/
		protected static var _uniqueIDCounter:int = 1;
		/** @private 唯一标识ID。*/
		protected var _id:int;
		/** @private 所属节点遮罩层。*/
		protected var _cachedOwnerLayerMask:uint;
		/** @private 所属节点是否启动。*/
		protected var _cachedOwnerEnable:Boolean;
		/** @private 是否启动。*/
		protected var _enable:Boolean;
		/** @private 所属Sprite3D节点。*/
		protected var _owner:Sprite3D;
		
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
		public function get owner():Sprite3D {
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
				this.event(Event.ENABLED_CHANGED, _enable);
			}
		}
		
		/**
		 * 获取是否激活。
		 * @return 是否激活。
		 */
		public function get isActive():Boolean {
			return Layer.isActive(_cachedOwnerLayerMask) && _cachedOwnerEnable && _enable;
		}
		
		/**
		 * 获取是否可见。
		 * @return 是否可见。
		 */
		public function get isVisible():Boolean {
			return Layer.isVisible(_cachedOwnerLayerMask) && _cachedOwnerEnable && _enable;
		}
		
		/**
		 * 创建一个新的 <code>Component3D</code> 实例。
		 */
		public function Component3D() {
			_id = _uniqueIDCounter;
			_uniqueIDCounter++;
		}
		
		/**
		 * @private
		 * owner蒙版变化事件处理。
		 * @param	mask 蒙版值。
		 */
		protected function _onLayerChanged(layer:Layer):void {
			_cachedOwnerLayerMask = layer.mask;
		}
		
		/**
		 * @private
		 * owner启用变化事件处理。
		 * @param	enable 是否启用。
		 */
		protected function _onEnableChanged(enable:Boolean):void {
			_cachedOwnerEnable = enable;
		}
		
		/**
		 * @private
		 * 初始化组件。
		 * @param	owner 所属Sprite3D节点。
		 */
		public function _initialize(owner:Sprite3D):void {
			_owner = owner;
			enable = true;
			started = false;
			_cachedOwnerLayerMask = owner.layer.mask;
			_owner.on(Event.LAYER_CHANGED, this, _onLayerChanged);
			_cachedOwnerEnable = owner.enable;
			_owner.on(Event.ENABLED_CHANGED, this, _onEnableChanged);
			_load(owner);
		}
		
		/**
		 * @private
		 * 卸载组件。
		 */
		public function _uninitialize():void {
			_unload(owner);
			_owner.off(Event.LAYER_CHANGED, this, _onLayerChanged);
			_owner.off(Event.ENABLED_CHANGED, this, _onEnableChanged);
			_owner = null;
		}
		
		/**
		 * @private
		 * 载入组件时执行,可重写此函数。
		 */
		public function _load(owner:Sprite3D):void {
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
		public function _unload(owner:Sprite3D):void {
		}
	
		////日后添加，物理相关函数
		//public  function onCollisionEnter():void{}
		//public  function onCollisionExit():void {}
		//public  function onCollisionStay():void{}	
	}
}
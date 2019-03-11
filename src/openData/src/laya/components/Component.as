package laya.components {
	import laya.display.Node;
	import laya.resource.IDestroy;
	import laya.resource.ISingletonElement;
	import laya.utils.Pool;
	import laya.utils.Utils;
	
	/**
	 * <code>Component</code> 类用于创建组件的基类。
	 */
	public class Component implements ISingletonElement, IDestroy {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** @private [实现IListPool接口]*/
		public var _destroyed:Boolean;
		/** @private [实现IListPool接口]*/
		private var _indexInList:int;
		
		/** @private */
		public var _id:int;
		/** @private */
		public var _enabled:Boolean;
		/** @private */
		private var _active:Boolean;
		/** @private */
		private var _awaked:Boolean;
		
		/**
		 * [只读]获取所属Node节点。
		 * @readonly
		 */
		public var owner:Node;
		
		/**
		 * 创建一个新的 <code>Component</code> 实例。
		 */
		public function Component() {
			this._id = Utils.getGID();
			this._resetComp();
		}
		
		/**
		 * 获取唯一标识ID。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取是否启用组件。
		 */
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
			if (owner) {
				if (value) owner.activeInHierarchy && _onEnable();
				else _active && _onDisable();
			}
		}
		
		/**
		 * 获取是否为单实例组件。
		 */
		public function get isSingleton():Boolean {
			return true;
		}
		
		/**
		 * 获取是否已经销毁 。
		 */
		public function get destroyed():Boolean {
			//[实现IListPool接口]
			return _destroyed;
		}
		
		/**
		 * @private
		 */
		private function _resetComp():void {
			this._indexInList = -1;
			this._enabled = true;
			this._active = false;
			this._awaked = false;
			this.owner = null;
		}
		
		/**
		 * [实现IListPool接口]
		 * @private
		 */
		public function _getIndexInList():int {
			return _indexInList;
		}
		
		/**
		 * [实现IListPool接口]
		 * @private
		 */
		public function _setIndexInList(index:int):void {
			_indexInList = index;
		}
		
		/**
		 * 被添加到节点后调用，可根据需要重写此方法
		 * @private
		 */
		public function _onAdded():void {
			//override it.
		}
		
		/**
		 * 被激活后调用，可根据需要重写此方法
		 * @private
		 */
		protected function _onAwake():void {
			//override it.
		}
		
		/**
		 * 被激活后调用，可根据需要重写此方法
		 * @private
		 */
		protected function _onEnable():void {
			//override it.
		}
		
		/**
		 * 被禁用时调用，可根据需要重写此方法
		 * @private
		 */
		protected function _onDisable():void {
			//override it.
		}
		
		/**
		 * 被添加到Scene后调用，无论Scene是否在舞台上，可根据需要重写此方法
		 * @private
		 */
		protected function _onEnableInScene():void {
			//override it.
		}
		
		/**
		 * 从Scene移除后调用，无论Scene是否在舞台上，可根据需要重写此方法
		 * @private
		 */
		protected function _onDisableInScene():void {
			//override it.
		}
		
		/**
		 * 被销毁时调用，可根据需要重写此方法
		 * @private
		 */
		protected function _onDestroy():void {
			//override it.
		}
		
		/**
		 * 重置组件参数到默认值，如果实现了这个函数，则组件会被重置并且自动回收到对象池，方便下次复用
		 * 如果没有重置，则不进行回收复用
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onReset():void {
			//override it.
		}
		
		/**
		 * @private
		 */
		public function _parse(data:Object):void {
			//override it.
		}
		
		/**
		 * @private
		 */
		public function _cloneTo(dest:Component):void {
			//override it.
		}
		
		/**
		 * @private
		 */
		public function _setActive(value:Boolean):void {
			if (_active === value) return;
			if (!owner.activeInHierarchy) return;
			_active = value;
			if (value) {
				if (!_awaked) {
					_awaked = true;
					_onAwake();
				}
				_enabled && _onEnable();
			} else {
				_enabled && _onDisable();
			}
		}
		
		/**
		 * @private
		 */
		public function _setActiveInScene(value:Boolean):void {
			if (value) _onEnableInScene();
			else _onDisableInScene();
		}
		
		/**
		 * 销毁组件
		 */
		public function destroy():void {
			if (owner) owner._destroyComponent(this);
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			_active && _setActive(false);
			owner._scene && _setActiveInScene(false);
			_onDestroy();
			_destroyed = true;
			if (this.onReset !== Component.prototype.onReset) {
				onReset();
				_resetComp();
				Pool.recoverByClass(this);
			} else {
				_resetComp();
			}
		}
	}
}
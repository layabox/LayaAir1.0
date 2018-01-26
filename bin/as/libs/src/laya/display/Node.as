package laya.display {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.Render;
	import laya.utils.Timer;
	
	/**
	 * 添加到父对象后调度。
	 * @eventType Event.ADDED
	 */
	[Event(name = "added", type = "laya.events.Event")]
	/**
	 * 被父对象移除后调度。
	 * @eventType Event.REMOVED
	 */
	[Event(name = "removed", type = "laya.events.Event")]
	/**
	 * 加入节点树时调度。
	 * @eventType Event.DISPLAY
	 */
	[Event(name = "display", type = "laya.events.Event")]
	/**
	 * 从节点树移除时调度。
	 * @eventType Event.UNDISPLAY
	 */
	[Event(name = "undisplay", type = "laya.events.Event")]
	
	/**
	 *  <code>Node</code> 类是可放在显示列表中的所有对象的基类。该显示列表管理 Laya 运行时中显示的所有对象。使用 Node 类排列显示列表中的显示对象。Node 对象可以有子显示对象。
	 */
	public class Node extends EventDispatcher {
		/**@private */
		protected static const ARRAY_EMPTY:Array = [];
		/**@private */
		private static const PROP_EMPTY:Object = {};
		/**@private */
		public static const NOTICE_DISPLAY:int = 0x1;
		/**@private */
		public static const MOUSEENABLE:int = 0x2;
		/**@private */
		private var _bits:int = 0;
		/**@private 子对象集合，请不要直接修改此对象。*/
		public var _childs:Array = ARRAY_EMPTY;
		/**@private 是否在显示列表中显示*/
		protected var _displayedInStage:Boolean;
		/**@private 父节点对象*/
		public var _parent:Node;
		/**@private 系统保留的私有变量集合*/
		public var _$P:Object = PROP_EMPTY;
		/**@private */
		public var conchModel:*;
		
		/**节点名称。*/
		public var name:String = "";
		/**[只读]是否已经销毁。对象销毁后不能再使用。*/
		public var _destroyed:Boolean;
		/**时间控制器，默认为Laya.timer。*/
		public var timer:Timer = Laya.scaleTimer;
		
		/**
		 * [只读]是否已经销毁。对象销毁后不能再使用。
		 * @return 
		 */
		 public function get destroyed():Boolean{
			return _destroyed;
		}
		
		/**
		 * <code>Node</code> 类用于创建节点对象，节点是最基本的元素。
		 */
		public function Node() {
			this.conchModel = Render.isConchNode ? this.createConchModel() : null;
		}
		
		/**@private */
		public function _setBit(type:int, value:Boolean):void {
			if (type == NOTICE_DISPLAY) {
				var preValue:Boolean = _getBit(type);
				if (preValue != value) {
					_updateDisplayedInstage();
				}
			}
			if (value) {
				_bits |= type;
			} else {
				_bits &= ~type;
			}
		}
		
		/**@private */
		public function _getBit(type:int):Boolean {
			return (_bits & type) != 0;
		}
		
		/**@private */
		public function _setUpNoticeChain():void {
			if (_getBit(NOTICE_DISPLAY)) {
				_setUpNoticeType(NOTICE_DISPLAY);
			}
		}
		
		/**@private */
		public function _setUpNoticeType(type:int):void {
			var ele:Node = this;
			ele._setBit(type, true);
			ele = ele.parent;
			while (ele) {
				if (ele._getBit(type)) return;
				ele._setBit(type, true);
				ele = ele.parent;
			}
		}
		
		/**
		 * <p>增加事件侦听器，以使侦听器能够接收事件通知。</p>
		 * <p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
		 * @param	type		事件的类型。
		 * @param	caller		事件侦听函数的执行域。
		 * @param	listener	事件侦听函数。
		 * @param	args		（可选）事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			if (type === Event.DISPLAY || type === Event.UNDISPLAY) {
				if (!_getBit(NOTICE_DISPLAY)) {
					_setUpNoticeType(NOTICE_DISPLAY);
				}
			}
			return _createListener(type, caller, listener, args, false);
		}
		
		/**
		 * <p>增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。</p>
		 * <p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
		 * @param	type		事件的类型。
		 * @param	caller		事件侦听函数的执行域。
		 * @param	listener	事件侦听函数。
		 * @param	args		（可选）事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		override public function once(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			if (type === Event.DISPLAY || type === Event.UNDISPLAY) {
				if (!_getBit(NOTICE_DISPLAY)) {
					_setUpNoticeType(NOTICE_DISPLAY);
				}
			}
			return _createListener(type, caller, listener, args, true);
		}
		
		/**@private */
		public function createConchModel():* {
			return null;
		}
		
		/**
		 * <p>销毁此对象。destroy对象默认会把自己从父节点移除，并且清理自身引用关系，等待js自动垃圾回收机制回收。destroy后不能再使用。</p>
		 * <p>destroy时会移除自身的事情监听，自身的timer监听，移除子对象及从父节点移除自己。</p>
		 * @param destroyChild	（可选）是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		public function destroy(destroyChild:Boolean = true):void {
			_destroyed = true;
			this._parent && this._parent.removeChild(this);
			
			//销毁子节点
			if (_childs) {
				if (destroyChild) destroyChildren();
				else this.removeChildren();
			}
			
			this._childs = null;
			
			this._$P = null;
			
			//移除所有事件监听
			this.offAll();
			
			//移除所有timer
			this.timer.clearAll(this);
		}
		
		/**
		 * 销毁所有子对象，不销毁自己本身。
		 */
		public function destroyChildren():void {
			//销毁子节点
			if (_childs) {
				for (var i:int = this._childs.length - 1; i > -1; i--) {
					this._childs[i].destroy(true);
				}
			}
		}
		
		/**
		 * 添加子节点。
		 * @param	node 节点对象
		 * @return	返回添加的节点
		 */
		public function addChild(node:Node):Node {
			if (!node || destroyed || node === this) return node;
			if (Sprite(node).zOrder) _set$P("hasZorder", true);
			if (node._parent === this) {
				var index:int = getChildIndex(node);
				if (index !== _childs.length - 1) {
					this._childs.splice(index, 1);
					this._childs.push(node);
					if (conchModel) {
						conchModel.removeChild(node.conchModel);
						conchModel.addChildAt(node.conchModel, this._childs.length - 1);
					}
					_childChanged();
				}
			} else {
				node.parent && node.parent.removeChild(node);
				this._childs === ARRAY_EMPTY && (this._childs = []);
				this._childs.push(node);
				conchModel && conchModel.addChildAt(node.conchModel, this._childs.length - 1);
				node.parent = this;
				_childChanged();
			}
			
			return node;
		}
		
		/**
		 * 批量增加子节点
		 * @param	...args 无数子节点。
		 */
		public function addChildren(... args):void {
			var i:int = 0, n:int = args.length;
			while (i < n) {
				addChild(args[i++]);
			}
		}
		
		/**
		 * 添加子节点到指定的索引位置。
		 * @param	node 节点对象。
		 * @param	index 索引位置。
		 * @return	返回添加的节点。
		 */
		public function addChildAt(node:Node, index:int):Node {
			if (!node || destroyed || node === this) return node;
			if (Sprite(node).zOrder) _set$P("hasZorder", true);
			if (index >= 0 && index <= this._childs.length) {
				if (node._parent === this) {
					var oldIndex:int = getChildIndex(node);
					this._childs.splice(oldIndex, 1);
					this._childs.splice(index, 0, node);
					if (conchModel) {
						conchModel.removeChild(node.conchModel);
						conchModel.addChildAt(node.conchModel, index);
					}
					_childChanged();
				} else {
					node.parent && node.parent.removeChild(node);
					this._childs === ARRAY_EMPTY && (this._childs = []);
					this._childs.splice(index, 0, node);
					conchModel && conchModel.addChildAt(node.conchModel, index);
					node.parent = this;
				}
				return node;
			} else {
				throw new Error("appendChildAt:The index is out of bounds");
			}
		}
		
		/**
		 * 根据子节点对象，获取子节点的索引位置。
		 * @param	node 子节点。
		 * @return	子节点所在的索引位置。
		 */
		public function getChildIndex(node:Node):int {
			return this._childs.indexOf(node);
		}
		
		/**
		 * 根据子节点的名字，获取子节点对象。
		 * @param	name 子节点的名字。
		 * @return	节点对象。
		 */
		public function getChildByName(name:String):Node {
			var nodes:Array = this._childs;
			if (nodes) {
				for (var i:int = 0, n:int = nodes.length; i < n; i++) {
					var node:Node = nodes[i];
					if (node.name === name) return node;
				}
			}
			return null;
		}
		
		/**@private */
		public function _get$P(key:String):* {
			return this._$P[key];
		}
		
		/**@private */
		public function _set$P(key:String, value:*):* {
			if (!destroyed) {
				this._$P === PROP_EMPTY && (this._$P = {});
				this._$P[key] = value;
			}
			return value;
		}
		
		/**
		 * 根据子节点的索引位置，获取子节点对象。
		 * @param	index 索引位置
		 * @return	子节点
		 */
		public function getChildAt(index:int):Node {
			return this._childs[index];
		}
		
		/**
		 * 设置子节点的索引位置。
		 * @param	node 子节点。
		 * @param	index 新的索引。
		 * @return	返回子节点本身。
		 */
		public function setChildIndex(node:Node, index:int):Node {
			var childs:Array = this._childs;
			if (index < 0 || index >= childs.length) {
				throw new Error("setChildIndex:The index is out of bounds.");
			}
			
			var oldIndex:int = getChildIndex(node);
			if (oldIndex < 0) throw new Error("setChildIndex:node is must child of this object.");
			childs.splice(oldIndex, 1);
			childs.splice(index, 0, node);
			if (conchModel) {
				conchModel.removeChild(node.conchModel);
				conchModel.addChildAt(node.conchModel, index);
			}
			_childChanged();
			return node;
		}
		
		/**
		 * @private
		 * 子节点发生改变。
		 * @param	child 子节点。
		 */
		protected function _childChanged(child:Node = null):void {
		
		}
		
		/**
		 * 删除子节点。
		 * @param	node 子节点
		 * @return	被删除的节点
		 */
		public function removeChild(node:Node):Node {
			if (!this._childs) return node;
			var index:int = this._childs.indexOf(node);
			return removeChildAt(index);
		}
		
		/**
		 * 从父容器删除自己，如已经被删除不会抛出异常。
		 * @return 当前节点（ Node ）对象。
		 */
		public function removeSelf():Node {
			this._parent && this._parent.removeChild(this);
			return this;
		}
		
		/**
		 * 根据子节点名字删除对应的子节点对象，如果找不到不会抛出异常。
		 * @param	name 对象名字。
		 * @return 查找到的节点（ Node ）对象。
		 */
		public function removeChildByName(name:String):Node {
			var node:Node = getChildByName(name);
			node && removeChild(node);
			return node;
		}
		
		/**
		 * 根据子节点索引位置，删除对应的子节点对象。
		 * @param	index 节点索引位置。
		 * @return	被删除的节点。
		 */
		public function removeChildAt(index:int):Node {
			var node:Node = getChildAt(index);
			if (node) {
				this._childs.splice(index, 1);
				conchModel && conchModel.removeChild(node.conchModel);
				node.parent = null;
			}
			return node;
		}
		
		/**
		 * 删除指定索引区间的所有子对象。
		 * @param	beginIndex 开始索引。
		 * @param	endIndex 结束索引。
		 * @return 当前节点对象。
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):Node {
			if (_childs && _childs.length > 0) {
				var childs:Array = this._childs;
				if (beginIndex === 0 && endIndex >= n) {
					var arr:Array = childs;
					this._childs = ARRAY_EMPTY;
				} else {
					arr = childs.splice(beginIndex, endIndex - beginIndex);
				}
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					arr[i].parent = null;
					conchModel && conchModel.removeChild(arr[i].conchModel);
				}
			}
			return this;
		}
		
		/**
		 * 替换子节点。
		 * @internal 将传入的新节点对象替换到已有子节点索引位置处。
		 * @param	newNode 新节点。
		 * @param	oldNode 老节点。
		 * @return	返回新节点。
		 */
		public function replaceChild(newNode:Node, oldNode:Node):Node {
			var index:int = this._childs.indexOf(oldNode);
			if (index > -1) {
				this._childs.splice(index, 1, newNode);
				if (conchModel) {
					conchModel.removeChild(oldNode.conchModel);
					conchModel.addChildAt(newNode.conchModel, index);
				}
				oldNode.parent = null;
				newNode.parent = this;
				return newNode;
			}
			return null;
		}
		
		/**
		 * 子对象数量。
		 */
		public function get numChildren():int {
			return this._childs.length;
		}
		
		/**父节点。*/
		public function get parent():Node {
			return this._parent;
		}
		
		public function set parent(value:Node):void {
			if (this._parent !== value) {
				if (value) {
					this._parent = value;
					//如果父对象可见，则设置子对象可见					
					event(Event.ADDED);
					if (_getBit(NOTICE_DISPLAY)) {
						_setUpNoticeChain();
						value.displayedInStage && _displayChild(this, true);
					}
					value._childChanged(this);
				} else {
					//设置子对象不可见
					event(Event.REMOVED);
					this._parent._childChanged();
					if (_getBit(NOTICE_DISPLAY)) _displayChild(this, false);
					this._parent = value;
				}
			}
		}
		
		/**表示是否在显示列表中显示。*/
		public function get displayedInStage():Boolean {
			if (_getBit(NOTICE_DISPLAY)) return _displayedInStage;
			_setUpNoticeType(NOTICE_DISPLAY);
			return _displayedInStage;
		}
		
		/**@private */
		private function _updateDisplayedInstage():void {
			var ele:Node;
			ele = this;
			var stage:Stage = Laya.stage;
			_displayedInStage = false;
			while (ele) {
				if (ele._getBit(NOTICE_DISPLAY)) {
					_displayedInStage = ele._displayedInStage;
					break;
				}
				if (ele == stage || ele._displayedInStage) {
					_displayedInStage = true;
					break;
				}
				
				ele = ele.parent;
			}
		}
		
		/**@private */
		public function _setDisplay(value:Boolean):void {
			if (_displayedInStage !== value) {
				_displayedInStage = value;
				if (value) event(Event.DISPLAY);
				else event(Event.UNDISPLAY);
			}
		}
		
		/**
		 * @private
		 * 设置指定节点对象是否可见(是否在渲染列表中)。
		 * @param	node 节点。
		 * @param	display 是否可见。
		 */
		private function _displayChild(node:Node, display:Boolean):void {
			var childs:Array = node._childs;
			if (childs) {
				for (var i:int = 0, n:int = childs.length; i < n; i++) {
					var child:Node = childs[i];
					if (!child._getBit(NOTICE_DISPLAY)) continue;
					if (child._childs.length > 0) {
						_displayChild(child, display);
					} else {
						child._setDisplay(display);
					}
				}
			}
			node._setDisplay(display);
		}
		
		/**
		 * 当前容器是否包含指定的 <code>Node</code> 节点对象 。
		 * @param	node  指定的 <code>Node</code> 节点对象 。
		 * @return	一个布尔值表示是否包含指定的 <code>Node</code> 节点对象 。
		 */
		public function contains(node:Node):Boolean {
			if (node === this) return true;
			while (node) {
				if (node.parent === this) return true;
				node = node.parent;
			}
			return false;
		}
		
		/**
		 * 定时重复执行某函数。功能同Laya.timer.timerLoop()。
		 * @param	delay		间隔时间(单位毫秒)。
		 * @param	caller		执行域(this)。
		 * @param	method		结束时的回调方法。
		 * @param	args		（可选）回调参数。
		 * @param	coverBefore	（可选）是否覆盖之前的延迟执行，默认为true。
		 * @param	jumpFrame 时钟是否跳帧。基于时间的循环回调，单位时间间隔内，如能执行多次回调，出于性能考虑，引擎默认只执行一次，设置jumpFrame=true后，则回调会连续执行多次
		 */
		public function timerLoop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true, jumpFrame:Boolean = false):void {
			timer.loop(delay, caller, method, args, coverBefore, jumpFrame);
		}
		
		/**
		 * 定时执行某函数一次。功能同Laya.timer.timerOnce()。
		 * @param	delay		延迟时间(单位毫秒)。
		 * @param	caller		执行域(this)。
		 * @param	method		结束时的回调方法。
		 * @param	args		（可选）回调参数。
		 * @param	coverBefore	（可选）是否覆盖之前的延迟执行，默认为true。
		 */
		public function timerOnce(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			timer._create(false, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时重复执行某函数(基于帧率)。功能同Laya.timer.frameLoop()。
		 * @param	delay		间隔几帧(单位为帧)。
		 * @param	caller		执行域(this)。
		 * @param	method		结束时的回调方法。
		 * @param	args		（可选）回调参数。
		 * @param	coverBefore	（可选）是否覆盖之前的延迟执行，默认为true。
		 */
		public function frameLoop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			timer._create(true, true, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时执行一次某函数(基于帧率)。功能同Laya.timer.frameOnce()。
		 * @param	delay		延迟几帧(单位为帧)。
		 * @param	caller		执行域(this)
		 * @param	method		结束时的回调方法
		 * @param	args		（可选）回调参数
		 * @param	coverBefore	（可选）是否覆盖之前的延迟执行，默认为true
		 */
		public function frameOnce(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			timer._create(true, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 清理定时器。功能同Laya.timer.clearTimer()。
		 * @param	caller 执行域(this)。
		 * @param	method 结束时的回调方法。
		 */
		public function clearTimer(caller:*, method:Function):void {
			timer.clear(caller, method);
		}
	}
}
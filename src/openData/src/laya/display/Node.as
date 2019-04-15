package laya.display {
	import laya.Const;
	import laya.components.Component;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
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
		private var _bits:int = 0;
		/**@private 子对象集合，请不要直接修改此对象。*/
		public var _children:Array = ARRAY_EMPTY;
		
		/**@private 仅仅用来处理输入事件的,并不是真正意义上的子对象 */
		public var _extUIChild:Array = ARRAY_EMPTY;
		
		/**@private 父节点对象*/
		public var _parent:Node = null;
		
		/**节点名称。*/
		public var name:String = "";
		/**[只读]是否已经销毁。对象销毁后不能再使用。*/
		public var destroyed:Boolean = false;
		/**@private */
		public var _conchData:*;
		
		public function Node() {
			createGLBuffer();
		}
		
		/**@private */
		public function createGLBuffer():void {
		}
		
		/**@private */
		public function _setBit(type:int, value:Boolean):void {
			if (type === Const.DISPLAY) {
				var preValue:Boolean = _getBit(type);
				if (preValue != value) _updateDisplayedInstage();
			}
			if (value) _bits |= type;
			else _bits &= ~type;
		}
		
		/**@private */
		public function _getBit(type:int):Boolean {
			return (_bits & type) != 0;
		}
		
		/**@private */
		public function _setUpNoticeChain():void {
			if (_getBit(Const.DISPLAY)) _setBitUp(Const.DISPLAY);
		}
		
		/**@private */
		public function _setBitUp(type:int):void {
			var ele:Node = this;
			ele._setBit(type, true);
			ele = ele._parent;
			while (ele) {
				if (ele._getBit(type)) return;
				ele._setBit(type, true);
				ele = ele._parent;
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
				if (!_getBit(Const.DISPLAY)) _setBitUp(Const.DISPLAY);
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
				if (!_getBit(Const.DISPLAY)) _setBitUp(Const.DISPLAY);
			}
			return _createListener(type, caller, listener, args, true);
		}
		
		/**
		 * <p>销毁此对象。destroy对象默认会把自己从父节点移除，并且清理自身引用关系，等待js自动垃圾回收机制回收。destroy后不能再使用。</p>
		 * <p>destroy时会移除自身的事情监听，自身的timer监听，移除子对象及从父节点移除自己。</p>
		 * @param destroyChild	（可选）是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		public function destroy(destroyChild:Boolean = true):void {
			destroyed = true;
			_destroyAllComponent();
			this._parent && this._parent.removeChild(this);
			
			//销毁子节点
			if (_children) {
				if (destroyChild) destroyChildren();
				else this.removeChildren();
			}
			onDestroy();
			
			this._children = null;
			
			//移除所有事件监听
			this.offAll();
		
			//移除所有timer
			//this.timer.clearAll(this);			
		}
		
		/**
		 * 销毁时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDestroy():void {
			//trace("onDestroy node", this.name);
		}
		
		/**
		 * 销毁所有子对象，不销毁自己本身。
		 */
		public function destroyChildren():void {
			//销毁子节点
			if (_children) {
				//为了保持销毁顺序，所以需要正序销毁
				for (var i:int = 0, n:int = this._children.length; i < n; i++) {
					this._children[0].destroy(true);
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
			if (Sprite(node)._zOrder) _setBit(Const.HAS_ZORDER, true);
			if (node._parent === this) {
				var index:int = getChildIndex(node);
				if (index !== _children.length - 1) {
					this._children.splice(index, 1);
					this._children.push(node);
					_childChanged();
				}
			} else {
				node._parent && node._parent.removeChild(node);
				this._children === ARRAY_EMPTY && (this._children = []);
				this._children.push(node);
				node._setParent(this);
				_childChanged();
			}
			
			return node;
		}
		
		public function addInputChild(node:Node):Node {
			if (_extUIChild == ARRAY_EMPTY) {
				_extUIChild = [node];
			} else {
				if (_extUIChild.indexOf(node) >= 0) {
					return null;
				}
				_extUIChild.push(node);
			}
			return null;
		}
		
		public function removeInputChild(node:Node):void {
			var idx:int = _extUIChild.indexOf(node);
			if (idx >= 0) {
				_extUIChild.splice(idx, 1);
			}
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
			if (Sprite(node)._zOrder) _setBit(Const.HAS_ZORDER, true);
			if (index >= 0 && index <= this._children.length) {
				if (node._parent === this) {
					var oldIndex:int = getChildIndex(node);
					this._children.splice(oldIndex, 1);
					this._children.splice(index, 0, node);
					_childChanged();
				} else {
					node._parent && node._parent.removeChild(node);
					this._children === ARRAY_EMPTY && (this._children = []);
					this._children.splice(index, 0, node);
					node._setParent(this);
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
			return this._children.indexOf(node);
		}
		
		/**
		 * 根据子节点的名字，获取子节点对象。
		 * @param	name 子节点的名字。
		 * @return	节点对象。
		 */
		public function getChildByName(name:String):Node {
			var nodes:Array = this._children;
			if (nodes) {
				for (var i:int = 0, n:int = nodes.length; i < n; i++) {
					var node:Node = nodes[i];
					if (node.name === name) return node;
				}
			}
			return null;
		}
		
		/**
		 * 根据子节点的索引位置，获取子节点对象。
		 * @param	index 索引位置
		 * @return	子节点
		 */
		public function getChildAt(index:int):Node {
			return this._children[index] || null;
		}
		
		/**
		 * 设置子节点的索引位置。
		 * @param	node 子节点。
		 * @param	index 新的索引。
		 * @return	返回子节点本身。
		 */
		public function setChildIndex(node:Node, index:int):Node {
			var childs:Array = this._children;
			if (index < 0 || index >= childs.length) {
				throw new Error("setChildIndex:The index is out of bounds.");
			}
			
			var oldIndex:int = getChildIndex(node);
			if (oldIndex < 0) throw new Error("setChildIndex:node is must child of this object.");
			childs.splice(oldIndex, 1);
			childs.splice(index, 0, node);
			_childChanged();
			return node;
		}
		
		/**
		 * 子节点发生改变。
		 * @private
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
			if (!this._children) return node;
			var index:int = this._children.indexOf(node);
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
				this._children.splice(index, 1);
				node._setParent(null);
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
			if (_children && _children.length > 0) {
				var childs:Array = this._children;
				if (beginIndex === 0 && endIndex >= childs.length - 1) {
					var arr:Array = childs;
					this._children = ARRAY_EMPTY;
				} else {
					arr = childs.splice(beginIndex, endIndex - beginIndex);
				}
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					arr[i]._setParent(null);
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
			var index:int = this._children.indexOf(oldNode);
			if (index > -1) {
				this._children.splice(index, 1, newNode);
				oldNode._setParent(null);
				newNode._setParent(this);
				return newNode;
			}
			return null;
		}
		
		/**
		 * 子对象数量。
		 */
		public function get numChildren():int {
			return this._children.length;
		}
		
		/**父节点。*/
		public function get parent():Node {
			return this._parent;
		}
		
		/**@private */
		protected function _setParent(value:Node):void {
			if (this._parent !== value) {
				if (value) {
					this._parent = value;
					//如果父对象可见，则设置子对象可见
					_onAdded();
					event(Event.ADDED);
					if (_getBit(Const.DISPLAY)) {
						_setUpNoticeChain();
						value.displayedInStage && _displayChild(this, true);
					}
					value._childChanged(this);
				} else {
					//设置子对象不可见
					_onRemoved();
					event(Event.REMOVED);
					this._parent._childChanged();
					if (_getBit(Const.DISPLAY)) _displayChild(this, false);
					this._parent = value;
				}
			}
		}
		
		/**表示是否在显示列表中显示。*/
		public function get displayedInStage():Boolean {
			if (_getBit(Const.DISPLAY)) return _getBit(Const.DISPLAYED_INSTAGE);
			_setBitUp(Const.DISPLAY);
			return _getBit(Const.DISPLAYED_INSTAGE);
		}
		
		/**@private */
		private function _updateDisplayedInstage():void {
			var ele:Node;
			ele = this;
			var stage:Stage = Laya.stage;
			var displayedInStage:Boolean = false;
			while (ele) {
				if (ele._getBit(Const.DISPLAY)) {
					displayedInStage = ele._getBit(Const.DISPLAYED_INSTAGE);
					break;
				}
				if (ele === stage || ele._getBit(Const.DISPLAYED_INSTAGE)) {
					displayedInStage = true;
					break;
				}
				ele = ele._parent;
			}
			_setBit(Const.DISPLAYED_INSTAGE, displayedInStage);
		}
		
		/**@private */
		public function _setDisplay(value:Boolean):void {
			if (_getBit(Const.DISPLAYED_INSTAGE) !== value) {
				_setBit(Const.DISPLAYED_INSTAGE, value);
				if (value) event(Event.DISPLAY);
				else event(Event.UNDISPLAY);
			}
		}
		
		/**
		 * 设置指定节点对象是否可见(是否在渲染列表中)。
		 * @private
		 * @param	node 节点。
		 * @param	display 是否可见。
		 */
		private function _displayChild(node:Node, display:Boolean):void {
			var childs:Array = node._children;
			if (childs) {
				for (var i:int = 0, n:int = childs.length; i < n; i++) {
					var child:Node = childs[i];
					if (!child._getBit(Const.DISPLAY)) continue;
					if (child._children.length > 0) {
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
				if (node._parent === this) return true;
				node = node._parent;
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
			var timer:Timer = scene ? scene.timer : Laya.timer;
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
			var timer:Timer = scene ? scene.timer : Laya.timer;
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
			var timer:Timer = scene ? scene.timer : Laya.timer;
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
			var timer:Timer = scene ? scene.timer : Laya.timer;
			timer._create(true, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 清理定时器。功能同Laya.timer.clearTimer()。
		 * @param	caller 执行域(this)。
		 * @param	method 结束时的回调方法。
		 */
		public function clearTimer(caller:*, method:Function):void {
			var timer:Timer = scene ? scene.timer : Laya.timer;
			timer.clear(caller, method);
		}
		
		/**
		 * <p>延迟运行指定的函数。</p>
		 * <p>在控件被显示在屏幕之前调用，一般用于延迟计算数据。</p>
		 * @param method 要执行的函数的名称。例如，functionName。
		 * @param args 传递给 <code>method</code> 函数的可选参数列表。
		 *
		 * @see #runCallLater()
		 */
		public function callLater(method:Function, args:Array = null):void {
			var timer:Timer = scene ? scene.timer : Laya.timer;
			timer.callLater(this, method, args);
		}
		
		/**
		 * <p>如果有需要延迟调用的函数（通过 <code>callLater</code> 函数设置），则立即执行延迟调用函数。</p>
		 * @param method 要执行的函数名称。例如，functionName。
		 * @see #callLater()
		 */
		public function runCallLater(method:Function):void {
			var timer:Timer = scene ? scene.timer : Laya.timer;
			timer.runCallLater(this, method);
		}
		
		//============================组件化支持==============================
		/** @private */
		private var _components:Array;
		/**@private */
		private var _activeChangeScripts:Array;//TODO:可用对象池
		
		/**@private */
		public var _scene:Node;
		
		/**
		 * 获得所属场景。
		 * @return	场景。
		 */
		public function get scene():* {
			return _scene;
		}
		
		/**
		 * 获取自身是否激活。
		 *   @return	自身是否激活。
		 */
		public function get active():Boolean {
			return !_getBit(Const.NOT_READY) && !_getBit(Const.NOT_ACTIVE);
		}
		
		/**
		 * 设置是否激活。
		 * @param	value 是否激活。
		 */
		public function set active(value:Boolean):void {
			value = !!value;
			if (!_getBit(Const.NOT_ACTIVE) !== value) {
				if (_activeChangeScripts && _activeChangeScripts.length !== 0) {
					if (value)
						throw "Node: can't set the main inActive node active in hierarchy,if the operate is in main inActive node or it's children script's onDisable Event.";
					else
						throw "Node: can't set the main active node inActive in hierarchy,if the operate is in main active node or it's children script's onEnable Event.";
				} else {
					_setBit(Const.NOT_ACTIVE, !value);
					if (_parent) {
						if (_parent.activeInHierarchy) {
							if (value) _processActive();
							else _processInActive();
						}
					}
					
				}
			}
		
		}
		
		/**
		 * 获取在场景中是否激活。
		 *   @return	在场景中是否激活。
		 */
		public function get activeInHierarchy():Boolean {
			return _getBit(Const.ACTIVE_INHIERARCHY);
		}
		
		/**
		 * @private
		 */
		protected function _onActive():void {
			//override it.
		}
		
		/**
		 * @private
		 */
		protected function _onInActive():void {
			//override it.
		}
		
		/**
		 * @private
		 */
		protected function _onActiveInScene():void {
			//override it.
		}
		
		/**
		 * @private
		 */
		protected function _onInActiveInScene():void {
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
		public function _setBelongScene(scene:Node):void {
			if (!_scene) {
				_scene = scene;
				if (_components) {
					for (var i:int = 0, n:int = _components.length; i < n; i++)
						_components[i]._setActiveInScene(true);
				}
				_onActiveInScene();
				for (i = 0, n = _children.length; i < n; i++)
					_children[i]._setBelongScene(scene);
			}
		}
		
		/**
		 * @private
		 */
		public function _setUnBelongScene():void {
			if (_scene !== this) {//移除节点本身是scene不继续派发
				_onInActiveInScene();
				if (_components) {
					for (var i:int = 0, n:int = _components.length; i < n; i++)
						_components[i]._setActiveInScene(false);
				}
				_scene = null;
				for (i = 0, n = _children.length; i < n; i++)
					_children[i]._setUnBelongScene();
			}
		}
		
		/**
		 * 组件被激活后执行，此时所有节点和组件均已创建完毕，次方法只执行一次
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onAwake():void {
			//this.name  && trace("onAwake node ", this.name);
		}
		
		/**
		 * 组件被启用后执行，比如节点被添加到舞台后
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onEnable():void {
			//this.name  && trace("onEnable node ", this.name);
		}
		
		/**
		 * @private
		 */
		public function _processActive():void {
			(_activeChangeScripts) || (_activeChangeScripts = []);
			_activeHierarchy(_activeChangeScripts);//处理属性,保证属性的正确性和即时性
			_activeScripts();//延时处理组件
		}
		
		/**
		 * @private
		 */
		public function _activeHierarchy(activeChangeScripts:Array):void {
			_setBit(Const.ACTIVE_INHIERARCHY, true);
			
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var comp:Component = _components[i];
					comp._setActive(true);
					(comp._isScript()) && (activeChangeScripts.push(comp));
				}
			}
			
			_onActive();
			for (i = 0, n = _children.length; i < n; i++) {
				var child:Node = _children[i];
				(!child._getBit(Const.NOT_ACTIVE)) && (child._activeHierarchy(activeChangeScripts));
			}
			if (!_getBit(Const.AWAKED)) {
				_setBit(Const.AWAKED, true);
				onAwake();
			}
			onEnable();
		}
		
		/**
		 * @private
		 */
		private function _activeScripts():void {
			for (var i:int = 0, n:int = _activeChangeScripts.length; i < n; i++)
				_activeChangeScripts[i].onEnable();
			_activeChangeScripts.length = 0;
		}
		
		/**
		 * @private
		 */
		private function _processInActive():void {
			(_activeChangeScripts) || (_activeChangeScripts = []);
			_inActiveHierarchy(_activeChangeScripts);//处理属性,保证属性的正确性和即时性
			_inActiveScripts();//延时处理组件
		}
		
		/**
		 * @private
		 */
		public function _inActiveHierarchy(activeChangeScripts:Array):void {
			_onInActive();
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var comp:Component = _components[i];
					comp._setActive(false);
					(comp._isScript()) && (activeChangeScripts.push(comp));
				}
			}
			_setBit(Const.ACTIVE_INHIERARCHY, false);
			
			for (i = 0, n = _children.length; i < n; i++) {
				var child:Node = _children[i];
				(child && !child._getBit(Const.NOT_ACTIVE)) && (child._inActiveHierarchy(activeChangeScripts));
			}
			onDisable();
		}
		
		/**
		 * @private
		 */
		private function _inActiveScripts():void {
			for (var i:int = 0, n:int = _activeChangeScripts.length; i < n; i++)
				_activeChangeScripts[i].onDisable();
			_activeChangeScripts.length = 0;
		}
		
		/**
		 * 组件被禁用时执行，比如从节点从舞台移除后
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDisable():void {
			//trace("onDisable node", this.name);
		}
		
		/**
		 * @private
		 */
		protected function _onAdded():void {
			if (_activeChangeScripts && _activeChangeScripts.length !== 0) {
				throw "Node: can't set the main inActive node active in hierarchy,if the operate is in main inActive node or it's children script's onDisable Event.";
			} else {
				var parentScene:Node = _parent.scene;
				parentScene && _setBelongScene(parentScene);
				(_parent.activeInHierarchy && active) && _processActive();
				
			}
		
		}
		
		/**
		 * @private
		 */
		protected function _onRemoved():void {
			if (_activeChangeScripts && _activeChangeScripts.length !== 0) {
				throw "Node: can't set the main active node inActive in hierarchy,if the operate is in main active node or it's children script's onEnable Event.";
			} else {
				(_parent.activeInHierarchy && active) && _processInActive();
				_parent.scene && _setUnBelongScene();
				
			}
		}
		
		/**
		 * @private
		 */
		public function _addComponentInstance(comp:Component):void {
			_components ||= [];
			_components.push(comp);
			
			comp.owner = this;
			comp._onAdded();
			if (activeInHierarchy){
				comp._setActive(true);
				(comp._isScript()) && ((comp as Object).onEnable());
			} 
			_scene && comp._setActiveInScene(true);
		}
		
		/**
		 * @private
		 */
		public function _destroyComponent(comp:Component):void {
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var item:Component = _components[i];
					if (item === comp) {
						item._destroy();
						_components.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _destroyAllComponent():void {
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var item:Component = _components[i];
					item._destroy();
				}
				_components.length = 0;
			}
		}
		
		/**
		 * @private 克隆。
		 * @param	destObject 克隆源。
		 */
		public function _cloneTo(destObject:*):void {
			var destNode:Node = destObject as Node;
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var destComponent:Component = destNode.addComponent(_components[i].constructor);
					_components[i]._cloneTo(destComponent);
				}
			}
		}
		
		/**
		 * 添加组件实例。
		 * @param	comp 组件实例。
		 * @return	组件。
		 */
		public function addComponentIntance(comp:Component):* {
			if (comp.owner)
				throw "Node:the component has belong to other node.";
			if (comp.isSingleton && getComponent((comp as Object).constructor))
				throw "Node:the component is singleton,can't add the second one.";
			_addComponentInstance(comp);
			return comp;
		}
		
		/**
		 * 添加组件。
		 * @param	type 组件类型。
		 * @return	组件。
		 */
		public function addComponent(type:Class):* {
			var comp:Component = Pool.createByClass(type);
			comp._destroyed = false;
			if (comp.isSingleton && getComponent(type))
				throw "无法实例" + type + "组件" + "，" + type + "组件已存在！";
			_addComponentInstance(comp);
			return comp;
		}
		
		/**
		 * 获得组件实例，如果没有则返回为null
		 * @param	clas 组建类型
		 * @return	返回组件
		 */
		public function getComponent(clas:Class):* {
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var comp:Component = _components[i];
					if (comp is clas)
						return comp;
				}
			}
			return null;
		}
		
		/**
		 * 获得组件实例，如果没有则返回为null
		 * @param	clas 组建类型
		 * @return	返回组件数组
		 */
		public function getComponents(clas:Class):Array {
			var arr:Array;
			if (_components) {
				for (var i:int = 0, n:int = _components.length; i < n; i++) {
					var comp:Component = _components[i];
					if (comp is clas) {
						arr ||= [];
						arr.push(comp);
					}
				}
			}
			return arr;
		}
		
		/**
		 * @private
		 * 获取timer
		 */
		public function get timer():Timer {
			return scene ? scene.timer : Laya.timer;
		}
	}
}
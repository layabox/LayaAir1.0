package laya.d3.core {
	import laya.d3.component.Component3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.IUpdate;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.IDispose;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	/**
	 * <code>Sprite3D</code> 类用于实现3D精灵。
	 */
	public class Sprite3D extends Node implements IUpdate, IDispose {
		/**唯一标识ID计数器。*/
		protected static var _uniqueIDCounter:int = 1/*int.MIN_VALUE*/;
		/**名字计数器。*/
		protected static var _nameNumberCounter:int = 0;
		
		/**是否在Stage中。*/
		protected var _isInStage:Boolean;
		/**唯一标识ID。*/
		private var _id:int;
		/**是否启用。*/
		protected var _enable:Boolean;
		/**图层蒙版。*/
		protected var _layerMask:uint;
		/**组件名字到索引映射。*/
		protected var _componentsMap:* = [];
		/**组件列表。*/
		protected var _components:Vector.<Component3D> = new Vector.<Component3D>();
		
		/**矩阵变换相关。*/
		public var transform:Transform3D;
		/**是否静态,静态包含一系列的特殊处理*/
		public var isStatic:Boolean;
		
		/**
		 * 获取唯一标识ID。
		 *   @return	唯一标识ID。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取是否启用。
		 *   @return	是否激活。
		 */
		public function get enable():Boolean {
			return _enable;
		}
		
		/**
		 * 获取是否在场景树。
		 *   @return	是否在场景树。
		 */
		public function get isInStage():Boolean {
			return _isInStage;
		}
		
		/**
		 * 设置是否启用。
		 * @param	value 是否启动。
		 */
		public function set enable(value:Boolean):void {
			if (_enable !== value) {
				_enable = value;
				this.event(Event.ENABLED_CHANGED, _enable);
			}
		}
		
		/**
		 * 获取是否激活。
		 *   @return	是否激活。
		 */
		public function get active():Boolean {
			return Layer.isActive(_layerMask) && _enable;
		}
		
		/**
		 * 获取是否显示。
		 * @return	是否显示。
		 */
		public function get visible():Boolean {
			return Layer.isVisible(_layerMask) && _enable;
		}
		
		/**
		 * 获取蒙版。
		 * @return	蒙版。
		 */
		public function get layer():Layer {
			return Layer.getLayerByMask(_layerMask);
		}
		
		/**
		 * 设置蒙版。
		 * @param	value 蒙版。
		 */
		public function set layer(value:Layer):void {
			_layerMask = value.mask;
			this.event(Event.LAYER_CHANGED, value);
		}
		
		/**
		 * 获得所属场景。
		 * @return	场景。
		 */
		public function get scene():BaseScene {
			return parent ? (parent as Object).scene : null;
		}
		
		/**
		 * 获得组件的数量。
		 * @return	组件数量。
		 */
		public function get componentsCount():int {
			return _components.length;
		}
		
		/**
		 * 创建一个 <code>Sprite3D</code> 实例。
		 */
		public function Sprite3D(name:String = null) {
			(name) ? (this.name = name) : (this.name = "Sprite3D-" + _nameNumberCounter++);
			
			_enable = true;
			_id = _uniqueIDCounter;
			_uniqueIDCounter++;
			layer = Layer.currentCreationLayer;
			transform = new Transform3D(this);
			on(Event.ADDED, this, _onAdded);
			on(Event.REMOVED, this, _onRemoved);
		}
		
		/**
		 * @private
		 */
		private function _onAdded():void {
			transform.parent = (_parent as Sprite3D).transform;
			var isInStage:Boolean = Laya.stage.contains(this);
			(isInStage) && (_addSelfAndChildrenRenderObjects());
			(isInStage) && (_changeSelfAndChildrenInStage(true));
		}
		
		/**
		 * @private
		 */
		private function _onRemoved():void {
			transform.parent = null;
			var isInStage:Boolean = Laya.stage.contains(this);//触发时还在stage中
			(isInStage) && (_clearSelfAndChildrenRenderObjects());
			(isInStage) && (_changeSelfAndChildrenInStage(false));
		}
		
		/**
		 * @private
		 */
		public function _changeSelfAndChildrenInStage(isInStage:Boolean):void {
			_isInStage = isInStage;
			event(Event.INSTAGE_CHANGED, isInStage);
			
			var children:Array = _childs;
			for (var i:int = 0, n:int = children.length; i < n; i++)
				(_childs[i] as Sprite3D)._changeSelfAndChildrenInStage(isInStage);
		}
		
		/**
		 * 清理自身渲染物体，请重载此函数。
		 */
		protected function _clearSelfRenderObjects():void {
		}
		
		/**
		 * 添加自身渲染物体，请重载此函数。
		 */
		protected function _addSelfRenderObjects():void {
		}
		
		/**
		 * 清理自身和子节点渲染物体,重写此函数。
		 */
		public function _clearSelfAndChildrenRenderObjects():void {
			_clearSelfRenderObjects();
			for (var i:int = 0, n:int = _childs.length; i < n; i++)
				(_childs[i] as Sprite3D)._clearSelfAndChildrenRenderObjects();
		}
		
		/**
		 * 添加自身和子节点渲染物体,重写此函数。
		 */
		public function _addSelfAndChildrenRenderObjects():void {
			_addSelfRenderObjects();
			for (var i:int = 0, n:int = _childs.length; i < n; i++)
				(_childs[i] as Sprite3D)._addSelfAndChildrenRenderObjects();
		}
		
		/**
		 * 更新组件update函数。
		 * @param	state 渲染相关状态。
		 */
		protected function _updateComponents(state:RenderState):void {
			for (var i:int = 0, n:int = _components.length; i < n; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.isActive) && (component._update(state));
			}
		}
		
		/**
		 * 更新组件lateUpdate函数。
		 * @param	state 渲染相关状态。
		 */
		protected function _lateUpdateComponents(state:RenderState):void {
			for (var i:int = 0; i < _components.length; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.isActive) && (component._lateUpdate(state));
			}
		}
		
		/**
		 * 更新子节点。
		 * @param	state 渲染相关状态。
		 */
		protected function _updateChilds(state:RenderState):void {
			var n:int = _childs.length;
			if (n === 0) return;
			for (var i:int = 0; i < n; ++i) {
				var child:Sprite3D = _childs[i];
				child._update((state));
			}
		}
		
		/**
		 * 排序函数。
		 * @param	state 渲染相关状态。
		 */
		public function _getSortID(renderElement:IRenderable, material:BaseMaterial):int {
			return +renderElement._getVertexBuffer().vertexDeclaration.id + material.id * VertexDeclaration._maxVertexDeclarationBit;
		}
		
		/**
		 * 更新
		 * @param	state 渲染相关状态
		 */
		public function _update(state:RenderState):void {
			state.owner = this;
			if (_enable) {
				_updateComponents(state);
				_lateUpdateComponents(state);
			}
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		override public function addChildAt(node:Node, index:int):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return super.addChildAt(node, index);
		}
		
		override public function addChild(node:Node):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return super.addChild(node);
		}
		
		/**
		 * 添加指定类型组件。
		 * @param	type 组件类型。
		 * @return	组件。
		 */
		public function addComponent(type:*):Component3D {
			if (!(_componentsMap[type] === undefined))
				throw new Error("无法创建" + type + "组件" + "，" + type + "组件已存在！");
			
			var component:Component3D = ClassUtils.getInstance(type);
			component._initialize(this);
			_componentsMap[type] = _components.length;
			_components.push(component);
			this.event(Event.COMPONENT_ADDED, component);
			return component;
		}
		
		/**
		 * 获得指定类型组件。
		 * @param	type 组件类型。
		 * @return	组件。
		 */
		public function getComponentByType(type:*):Component3D {
			if (_componentsMap[type] === undefined)
				return null;
			return _components[_componentsMap[type]];
		}
		
		/**
		 * 获得指定类型组件。
		 * @param	type 组件类型。
		 * @return	组件。
		 */
		public function getComponentByIndex(index:int):Component3D {
			return _components[index];
		}
		
		/**
		 * 移除指定类型组件。
		 * @param	type 组件类型。
		 */
		public function removeComponent(type:String):void {
			if (_componentsMap[type] === undefined)
				return;
			var component:Component3D = _components[_componentsMap[type]];
			_components.splice(_componentsMap[type], 1);
			delete _componentsMap[type];
			this.event(Event.COMPONENT_REMOVED, component);
		}
		
		/**
		 * 移除全部组件。
		 */
		public function removeAllComponent():void {
			for (var component:* in _componentsMap)
				removeComponent(component);
		}
		
		/**
		 * 加载场景文件。
		 * @param	url 地址。
		 */
		public function loadHierarchy(url:String):void {
			if (url === null) return;
			
			var loader:Loader = new Loader();
			url = URL.formatURL(url);
			var _this:Sprite3D = this;
			var onComp:Function = function(data:String):void {
				var preBasePath:String = URL.basePath;
				URL.basePath = URL.getPath(URL.formatURL(url));
				var sprite:Sprite3D = ClassUtils.createByJson(data, null, _this, Handler.create(null, Utils3D._parseHierarchyProp, null, false), Handler.create(null, Utils3D._parseHierarchyNode, null, false));
				addChild(sprite);
				URL.basePath = preBasePath;
				event(Event.HIERARCHY_LOADED, [_this, sprite]);
			}
			loader.once(Event.COMPLETE, null, onComp);
			loader.load(url, Loader.TEXT);
		}
		
		public function dispose():void {
			off(Event.ADDED, this, _onAdded);
			off(Event.REMOVED, this, _onRemoved);
			for (var i:int, n:int = _components.length; i < n; i++)
				_components[i]._uninitialize();
		}
	
	}
}
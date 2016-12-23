package laya.d3.core {
	import laya.d3.component.Component3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.IUpdate;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.ICreateResource;
	import laya.resource.IDispose;
	import laya.runtime.IConchNode;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	/**
	 * <code>Sprite3D</code> 类用于实现3D精灵。
	 */
	public class Sprite3D extends Node implements IUpdate, ICreateResource, IClone {
		public static const WORLDMATRIX:int = 0;
		public static const MVPMATRIX:int = 1;
		
		/**唯一标识ID计数器。*/
		protected static var _uniqueIDCounter:int = 0;
		/**名字计数器。*/
		protected static var _nameNumberCounter:int = 0;
		
		/**
		 * 创建精灵的克隆实例。
		 * @param	original  原始精灵。
		 * @param	position  世界位置。
		 * @param	rotation  世界旋转。
		 * @param   parent    父节点。
		 * @param   worldPositionStays 是否保持自身世界变换,注意:在position，rotation均为空时有效。
		 * @return  克隆实例。
		 */
		public static function instantiate(original:Sprite3D, position:Vector3 = null, rotation:Quaternion = null, parent:Node = null, worldPositionStays:Boolean = true):Sprite3D {
			var destSprite3D:Sprite3D = original.clone();
			
			var transform:Transform3D;
			if (position || rotation) {
				(parent) && (parent.addChild(destSprite3D));
				transform = destSprite3D.transform;
				(position) && (transform.position = position);
				(rotation) && (transform.rotation = rotation);
			} else {
				if (worldPositionStays) {
					transform = destSprite3D.transform;
					
					if (parent) {
						var oriPosition:Vector3 = transform.position;
						var oriRotation:Quaternion = transform.rotation;
						parent.addChild(destSprite3D);
						transform.position = oriPosition;
						transform.rotation = oriRotation;
					}
				} else {
					if (parent) {
						parent.addChild(destSprite3D);
					}
				}
			}
			return destSprite3D;
		}
		
		/**
		 * 加载网格模板,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Sprite3D {
			return Laya.loader.create(url, null, null, Sprite3D, 1, false);
		}
		
		/** @private */
		private var _projectionViewWorldMatrix:Matrix4x4;
		
		/**唯一标识ID。*/
		private var _id:int;
		/**是否启用。*/
		protected var _enable:Boolean;
		/**图层蒙版。*/
		protected var _layerMask:uint;
		/**组件名字到索引映射。*/
		protected var _componentsMap:Array = [];
		/**组件列表。*/
		protected var _components:Vector.<Component3D> = new Vector.<Component3D>();
		
		/** @private */
		public var _shaderValues:ValusArray;
		
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
			_projectionViewWorldMatrix = new Matrix4x4();
			_shaderValues = new ValusArray();
			
			(name) ? (this.name = name) : (this.name = "Sprite3D-" + _nameNumberCounter++);
			_enable = true;
			_id = ++_uniqueIDCounter;
			layer = Layer.currentCreationLayer;
			transform = new Transform3D(this);
			on(Event.DISPLAY, this, _onDisplay);
			on(Event.UNDISPLAY, this, _onUnDisplay);
		}
		
		override public function createConchModel():* {
			return __JS__("null");
		}
		
		/**
		 * @private
		 */
		private function _onDisplay():void {
			transform.parent = (_parent as Sprite3D).transform;
			_addSelfRenderObjects();
		}
		
		/**
		 * @private
		 */
		private function _onUnDisplay():void {
			transform.parent = null;
			_clearSelfRenderObjects();
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
			for (var i:int = 0; i < n; ++i)
				_childs[i]._update((state));
		}
		
		/**
		 * 排序函数。
		 * @param	state 渲染相关状态。
		 */
		public function _getSortID(renderElement:IRenderable, material:BaseMaterial):int {
			return renderElement._getVertexBuffer().vertexDeclaration.id + material.id * VertexDeclaration._maxVertexDeclarationBit;
		}
		
		/**
		 * 准备精灵级Shader数据,可重载此函数。
		 * @param	view
		 * @param	projection
		 * @param	projectionView
		 */
		public function _prepareShaderValuetoRender(view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);//TODO:静态合并需要使用,待调整移除。
			var projViewWorld:Matrix4x4 = getProjectionViewWorldMatrix(projectionView);
			_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
			debugger;
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
		
		/**
		 * @private
		 */
		public function _setShaderValueMatrix4x4(shaderName:int, matrix4x4:Matrix4x4):void {
			_shaderValues.setValue(shaderName, matrix4x4 ? matrix4x4.elements : null);
		}
		
		/**
		 * 设置颜色。
		 * @param	shaderIndex shader索引。
		 * @param	color 颜色向量。
		 */
		protected function _setShaderValueColor(shaderIndex:int, color:*):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, color ? color.elements : null);
		}
		
		/**
		 * 获取投影视图世界矩阵。
		 * @param	projectionViewMatrix 投影视图矩阵。
		 * @return  投影视图世界矩阵。
		 */
		public function getProjectionViewWorldMatrix(projectionViewMatrix:Matrix4x4):Matrix4x4 {
			var curLoopCount:int = Stat.loopCount;
			Matrix4x4.multiply(projectionViewMatrix, transform.worldMatrix, _projectionViewWorldMatrix);
			return _projectionViewWorldMatrix;
		}
		
		/**
		 * 加载层级文件，并作为该节点的子节点。
		 * @param	url
		 */
		public function loadHierarchy(url:String):void {
			addChild(Sprite3D.load(url));
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
			if (_componentsMap.indexOf(type) !== -1)
				throw new Error("无法创建" + type + "组件" + "，" + type + "组件已存在！");
			
			var component:Component3D = ClassUtils.getInstance(type);
			component._initialize(this);
			_componentsMap.push(type);
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
			var index:int = _componentsMap.indexOf(type);
			if (index === -1)
				return null;
			return _components[index];
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
			var index:int = _componentsMap.indexOf(type);
			if (index === -1)
				return;
			var component:Component3D = _components[index];
			_components.splice(index, 1);
			_componentsMap.splice(index, 1);
			component._uninitialize();
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
		 *@private
		 */
		public function onAsynLoaded(url:String, data:*):void {
			if (destroyed)//TODO:其它资源是否同样处理
				return;
			
			var oriData:Object = data[0];
			var innerResouMap:Object = data[1];
			ClassUtils.createByJson(oriData as String, this, this, Handler.create(null, Utils3D._parseHierarchyProp, [innerResouMap], false), Handler.create(null, Utils3D._parseHierarchyNode, null, false));
			event(Event.HIERARCHY_LOADED, [this]);
		}
		
		public function cloneTo(destObject:*):void {
			var destSprite3D:Sprite3D = destObject as Sprite3D;
			
			destSprite3D.name = name/* + "(clone)"*/;//TODO:克隆后不能播放刚体动画，找不到名字
			destSprite3D.destroyed = destroyed;
			destSprite3D.timer = timer;
			destSprite3D._$P = _$P;
			
			destSprite3D.enable = enable;
			
			var destLocalMatrix:Matrix4x4 = destSprite3D.transform.localMatrix;
			transform.localMatrix.cloneTo(destLocalMatrix);
			destSprite3D.transform.localMatrix = destLocalMatrix;
			destSprite3D.isStatic = isStatic;
			
			var i:int, n:int;
			for (i = 0, n = _componentsMap.length; i < n; i++)
				destSprite3D.addComponent(_componentsMap[i]);
			
			for (i = 0, n = _childs.length; i < n; i++)
				destSprite3D.addChild(_childs[i].clone());
		}
		
		public function clone():* {
			var destSprite3D:Sprite3D = __JS__("new this.constructor()");
			cloneTo(destSprite3D);
			return destSprite3D;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			for (var i:int, n:int = _components.length; i < n; i++)
				_components[i]._uninitialize();
			_components = null;
			_componentsMap = null;
			transform = null;
		}
	
	}
}
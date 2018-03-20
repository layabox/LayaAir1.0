package laya.d3.core {
	import laya.d3.animation.AnimationNode;
	import laya.d3.component.Animator;
	import laya.d3.component.Component3D;
	import laya.d3.component.Rigidbody;
	import laya.d3.component.Script;
	import laya.d3.component.physics.BoxCollider;
	import laya.d3.component.physics.Collider;
	import laya.d3.component.physics.MeshCollider;
	import laya.d3.component.physics.SphereCollider;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.IUpdate;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.ICreateResource;
	import laya.utils.ClassUtils;
	import laya.utils.Stat;
	
	/**
	 * <code>Sprite3D</code> 类用于实现3D精灵。
	 */
	public class Sprite3D extends ComponentNode implements IUpdate, ICreateResource, IClone {
		/**@private 着色器变量名，世界矩阵。*/
		public static const WORLDMATRIX:int = 0;
		/**@private 着色器变量名，世界视图投影矩阵。*/
		public static const MVPMATRIX:int = 1;
		
		/**@private */
		protected static var _uniqueIDCounter:int = 0;
		/**@private */
		protected static var _nameNumberCounter:int = 0;
		
		/**
		 * 创建精灵的克隆实例。
		 * @param	original  原始精灵。
		 * @param   parent    父节点。
		 * @param   worldPositionStays 是否保持自身世界变换。
		 * @param	position  世界位置,worldPositionStays为false时生效。
		 * @param	rotation  世界旋转,worldPositionStays为false时生效。
		 * @return  克隆实例。
		 */
		public static function instantiate(original:Sprite3D, parent:Node = null, worldPositionStays:Boolean = true, position:Vector3 = null, rotation:Quaternion = null):Sprite3D {
			var destSprite3D:Sprite3D = original.clone();
			(parent) && (parent.addChild(destSprite3D));
			var transform:Transform3D = destSprite3D.transform;
			if (worldPositionStays) {
				var worldMatrix:Matrix4x4 = transform.worldMatrix;
				original.transform.worldMatrix.cloneTo(worldMatrix);
				transform.worldMatrix = worldMatrix;
			} else {
				(position) && (transform.position = position);
				(rotation) && (transform.rotation = rotation);
			}
			return destSprite3D;
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Sprite3D {
			return Laya.loader.create(url, null, null, Sprite3D);
		}
		
		/** @private */
		private var _projectionViewWorldMatrix:Matrix4x4;
		/** @private */
		public var _projectionViewWorldUpdateLoopCount:int;
		/** @private */
		public var _projectionViewWorldUpdateCamera:BaseCamera;
		
		/** @private */
		private var _id:int;
		/** @private */
		private var __loaded:Boolean;
		/**@private */
		private var _url:String;
		/**@private */
		private var _group:String;
		
		/** @private */
		protected var _active:Boolean;
		/** @private */
		protected var _activeInHierarchy:Boolean;
		/** @private */
		protected var _layer:Layer;
		
		/** @private */
		public var _shaderDefineValue:int;
		/** @private */
		public var _shaderValues:ValusArray;
		/** @private */
		public var _colliders:Vector.<Collider>;
		/**@private */
		public var _scene:Scene;
		/**@private */
		public var _transform:Transform3D;
		/** @private */
		public var _hierarchyAnimator:Animator;
		
		/**是否静态,静态包含一系列的静态处理。*/
		public var isStatic:Boolean;
		
		/**
		 * @private
		 */
		public function set _loaded(value:Boolean):void {
			__loaded = value;
		}
		
		/**
		 * 获取唯一标识ID。
		 *   @return	唯一标识ID。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取是否已加载完成。
		 */
		public function get loaded():Boolean {
			return __loaded;
		}
		
		/**
		 * 获取自身是否激活。
		 *   @return	自身是否激活。
		 */
		public function get active():Boolean {
			return _active;
		}
		
		/**
		 * 设置是否激活。
		 * @param	value 是否激活。
		 */
		public function set active(value:Boolean):void {
			if (_active !== value) {
				_active = value;
				if (_parent) {
					if ((_parent === _scene && _parent.displayedInStage) || (_parent as Sprite3D)._activeInHierarchy) {//(父节点为场景||父节点为精灵)
						if (value)
							_activeHierarchy();
						else
							_inActiveHierarchy();
					}
				}
			}
		}
		
		/**
		 * 获取在场景中是否激活。
		 *   @return	在场景中是否激活。
		 */
		public function get activeInHierarchy():Boolean {
			return _activeInHierarchy;
		}
		
		/**
		 * 获取蒙版。
		 * @return	蒙版。
		 */
		public function get layer():Layer {
			return _layer;
		}
		
		/**
		 * 设置蒙版。
		 * @param	value 蒙版。
		 */
		public function set layer(value:Layer):void {
			if (value) {
				if (displayedInStage) {
					var i:int, n:int = _colliders.length;
					if (_layer) {
						for (i = 0; i < n; i++)
							_layer._removeCollider(_colliders[i]);
					}
					for (i = 0; i < n; i++)
						value._addCollider(_colliders[i]);
				}
				_layer = value;
				this.event(Event.LAYER_CHANGED, value);
			} else {
				throw new Error("Layer value can be null.");
			}
		}
		
		/**
		 * 获得所属场景。
		 * @return	场景。
		 */
		public function get scene():Scene {
			return _scene;
		}
		
		/**
		 * 获得组件的数量。
		 * @return	组件数量。
		 */
		public function get componentsCount():int {
			return _components.length;
		}
		
		/**
		 * 获取资源的URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 获取精灵变换。
		 */
		public function get transform():Transform3D {
			return _transform;
		}
		
		/**
		 * 创建一个 <code>Sprite3D</code> 实例。
		 */
		public function Sprite3D(name:String = null) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			__loaded = true;
			_projectionViewWorldUpdateLoopCount = -1;
			_activeInHierarchy = false;
			_projectionViewWorldMatrix = new Matrix4x4();
			_shaderValues = new ValusArray();
			_colliders = new Vector.<Collider>();
			_id = ++_uniqueIDCounter;
			_transform = new Transform3D(this);
			this.name = name ? name : "Sprite3D-" + _nameNumberCounter++;
			layer = Layer.currentCreationLayer;
			active = true;
		}
		
		/**
		 * @private
		 */
		public function _setUrl(url:String):void {
			_url = url;
		}
		
		/**
		 * @private
		 */
		public function _getGroup():String {
			return _group;
		}
		
		/**
		 * @private
		 */
		public function _setGroup(value:String):void {
			_group = value;
		}
		
		/**
		 * @private
		 */
		private function _addChild3D(sprite3D:Sprite3D):void {
			sprite3D.transform.parent = transform;
			if (_hierarchyAnimator) {
				(/*_hierarchyAnimator &&*/!sprite3D._hierarchyAnimator) && (sprite3D._setHierarchyAnimator(_hierarchyAnimator, null));//执行条件为sprite3D._hierarchyAnimator==parentAnimator,只有一种情况sprite3D._hierarchyAnimator=null成立,且_belongAnimator不为空有意义
				_getAnimatorToLinkSprite3D(sprite3D, true, new <String>[sprite3D.name]);//TODO:是否获取默认值函数移到active事件函数内，U3D修改active会重新获取默认值
			}
			if (_scene) {
				sprite3D._setBelongScene(_scene);
				(_activeInHierarchy && sprite3D._active) && (sprite3D._activeHierarchy());
			}
		}
		
		/**
		 * @private
		 */
		private function _removeChild3D(sprite3D:Sprite3D):void {
			sprite3D.transform.parent = null;
			if (_scene) {
				(_activeInHierarchy && sprite3D._active) && (sprite3D._inActiveHierarchy());
				sprite3D._setUnBelongScene();
			}
			if (_hierarchyAnimator) {
				(/*_hierarchyAnimator &&*/(sprite3D._hierarchyAnimator == _hierarchyAnimator)) && (sprite3D._clearHierarchyAnimator(_hierarchyAnimator, null));//_belongAnimator不为空有意义
				_getAnimatorToLinkSprite3D(sprite3D, false, new <String>[sprite3D.name]);//TODO:是否获取默认值函数移到active事件函数内，U3D修改active会重新获取默认值
			}
		}
		
		/**
		 *@private
		 */
		private function _parseBaseCustomProps(customProps:Object):void {
			var loccalPosition:Vector3 = transform.localPosition;
			loccalPosition.fromArray(customProps.translate);
			transform.localPosition = loccalPosition;
			var localRotation:Quaternion = transform.localRotation;
			localRotation.fromArray(customProps.rotation);
			transform.localRotation = localRotation;
			var localScale:Vector3 = transform.localScale;
			localScale.fromArray(customProps.scale);
			transform.localScale = localScale;
			var layerData:* = customProps.layer;
			(layerData != null) && (layer = Layer.getLayerByNumber(layerData));
		}
		
		/**
		 *@private
		 */
		private function _parseCustomComponent(rootNode:ComponentNode, innerResouMap:Object, componentsData:Object):void {
			for (var k:String in componentsData) {
				var component:Object = componentsData[k];
				switch (k) {
				case "Animator": 
					var animator:Animator = addComponent(Animator) as Animator;
					if (component.avatarPath) {//兼容代码
						animator.avatar = Loader.getRes(innerResouMap[component.avatarPath]);
					} else {
						var avatarData:Object = component.avatar;
						if (avatarData) {
							animator.avatar = Loader.getRes(innerResouMap[avatarData.path]);
							var linkSprites:Object = avatarData.linkSprites;
							(linkSprites) && (rootNode.once(Event.HIERARCHY_LOADED, this, _onRootNodeHierarchyLoaded, [animator, linkSprites]));
						}
					}
					
					var clipPaths:Vector.<String> = component.clipPaths;
					var clipCount:int = clipPaths.length;
					for (var i:int = 0; i < clipCount; i++)
						animator.addClip(Loader.getRes(innerResouMap[clipPaths[i]]));
					animator.clip = Loader.getRes(innerResouMap[clipPaths[0]]);//TODO:单处存储模型动画路径
					var playOnWake:* = component.playOnWake;
					(playOnWake !== undefined) && (animator.playOnWake = playOnWake);
					break;
				case "Rigidbody": 
					var rigidbody:Rigidbody = addComponent(Rigidbody) as Rigidbody;
					break;
				case "SphereCollider": 
					var sphereCollider:SphereCollider = addComponent(SphereCollider) as SphereCollider;
					sphereCollider.isTrigger = component.isTrigger;
					var center:Vector3 = sphereCollider.center;
					center.fromArray(component.center);
					sphereCollider.center = center;
					sphereCollider.radius = component.radius;
					break;
				case "BoxCollider": 
					var boxCollider:BoxCollider = addComponent(BoxCollider) as BoxCollider;
					boxCollider.isTrigger = component.isTrigger;
					boxCollider.center.fromArray(component.center);
					var size:Vector3 = boxCollider.size;
					size.fromArray(component.size);
					boxCollider.size = size;
					break;
				case "MeshCollider": 
					var meshCollider:MeshCollider = addComponent(MeshCollider) as MeshCollider;
					break;
				default: 
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _onRootNodeHierarchyLoaded(animator:Animator, linkSprites:Object):void {
			for (var k:String in linkSprites) {
				var nodeOwner:Sprite3D = this;
				var path:Vector.<String> = linkSprites[k];
				for (var j:int = 0, m:int = path.length; j < m; j++) {
					var p:String = path[j];
					if (p === "") {
						break;
					} else {
						nodeOwner = nodeOwner.getChildByName(p) as Sprite3D;
						if (!nodeOwner)
							break;
					}
				}
				(nodeOwner) && (animator.linkSprite3DToAvatarNode(k, nodeOwner));//此时Avatar文件已经加载完成
			}
		}
		
		/**
		 * @private
		 */
		private function _setHierarchyAnimator(animator:Animator, parentAnimator:Animator):void {
			_changeHierarchyAnimator(animator);
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i];
				(child._hierarchyAnimator == parentAnimator) && (child._setHierarchyAnimator(animator, parentAnimator));
			}
		}
		
		/**
		 * @private
		 */
		private function _clearHierarchyAnimator(animator:Animator, parentAnimator:Animator):void {
			_changeHierarchyAnimator(parentAnimator);
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i];
				(child._hierarchyAnimator == animator) && (child._clearHierarchyAnimator(animator, parentAnimator));
			}
		}
		
		/**
		 * @private
		 */
		private function _getAnimatorToLinkSprite3D(sprite3D:Sprite3D, isLink:Boolean, path:Vector.<String>):void {
			var animator:Animator = getComponentByType(Animator) as Animator;
			if (animator) {
				if (animator.avatar) {
					(animator.avatar._version) || (sprite3D._setAnimatorToLinkAvatar(animator, isLink));//兼容代码
				} else {
					sprite3D._setAnimatorToLinkSprite3DNoAvatar(animator, isLink, path);
				}
			}
			
			if (_parent && _parent is Sprite3D) {
				path.unshift(_parent.name);
				var p:Sprite3D = _parent as Sprite3D;
				(p._hierarchyAnimator) && (p._getAnimatorToLinkSprite3D(sprite3D, isLink, path));
			}
		}
		
		/**
		 * @private
		 */
		private function _setAnimatorToLinkSprite3DNoAvatar(animator:Animator, isLink:Boolean, path:Vector.<String>):void {
			var i:int, n:int;
			for (i = 0, n = animator.getClipCount(); i < n; i++)
				animator._handleSpriteOwnersBySprite(i, isLink, path, this);
			
			for (i = 0, n = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i];
				var index:int = path.length;
				path.push(child.name);
				child._setAnimatorToLinkSprite3DNoAvatar(animator, isLink, path);
				path.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 */
		protected function _changeHierarchyAnimator(animator:Animator):void {
			_hierarchyAnimator = animator;
		}
		
		/**
		 * @private
		 */
		public function _isLinkSpriteToAnimationNode(animator:Animator, node:AnimationNode, isLink:Boolean):void {
			var nodeIndex:int = animator._avatarNodes.indexOf(node);
			var cacheSpriteToNodesMap:Vector.<int> = animator._cacheSpriteToNodesMap;
			
			if (isLink) {
				_transform.dummy = node.transform;
				animator._cacheNodesToSpriteMap[nodeIndex] = cacheSpriteToNodesMap.length;
				cacheSpriteToNodesMap.push(nodeIndex);
			} else {
				_transform.dummy = null;
				var index:int = animator._cacheNodesToSpriteMap[nodeIndex];
				animator._cacheNodesToSpriteMap[nodeIndex] = null;
				cacheSpriteToNodesMap.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 */
		public function _setBelongScene(scene:Scene):void {
			_scene = scene;
			for (var i:int = 0, n:int = _childs.length; i < n; i++)
				(_childs[i] as Sprite3D)._setBelongScene(scene);
		}
		
		/**
		 * @private
		 */
		public function _setUnBelongScene():void {
			_scene = null;
			for (var i:int = 0, n:int = _childs.length; i < n; i++)
				(_childs[i] as Sprite3D)._setUnBelongScene();
		}
		
		/**
		 * @private
		 */
		public function _activeHierarchy():void {
			var i:int, n:int;
			_activeInHierarchy = true;
			_addSelfRenderObjects();
			for (i = 0, n = _colliders.length; i < n; i++)
				_layer._addCollider(_colliders[i]);
			this.event(Event.ACTIVE_IN_HIERARCHY_CHANGED, true);
			
			for (i = 0, n = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i] as Sprite3D;
				(child._active) && (child._activeHierarchy());
			}
		}
		
		/**
		 * @private
		 */
		public function _inActiveHierarchy():void {
			var i:int, n:int;
			_activeInHierarchy = false;
			_clearSelfRenderObjects();
			for (i = 0, n = _colliders.length; i < n; i++) {
				var col:Collider = _colliders[i];
				col._clearCollsionMap();
				_layer._removeCollider(col);
			}
			this.event(Event.ACTIVE_IN_HIERARCHY_CHANGED, false);
			
			for (i = 0, n = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i] as Sprite3D;
				(child._active) && (child._inActiveHierarchy());
			}
		}
		
		/**
		 * @private
		 */
		override public function addComponent(type:*):Component3D {
			var typeComponentIndex:Vector.<int>;
			var index:int = _componentsMap.indexOf(type);
			if (index === -1) {
				typeComponentIndex = new Vector.<int>();
				_componentsMap.push(type);
				_typeComponentsIndices.push(typeComponentIndex);
			} else {
				typeComponentIndex = _typeComponentsIndices[index];
				if (_components[typeComponentIndex[0]].isSingleton)
					throw new Error("无法单实例创建" + type + "组件" + "，" + type + "组件已存在！");
			}
			
			var component:Component3D = ClassUtils.getInstance(type);
			typeComponentIndex.push(_components.length);
			_components.push(component);
			if (component is Collider) {
				var rigidbody:Rigidbody = getComponentByType(Rigidbody) as Rigidbody;
				(rigidbody) && ((component as Collider)._isRigidbody = true);
				(displayedInStage) && (_layer._addCollider(component as Collider));
				_colliders.push(component);
			} else if (component is Animator) {
				var animator:Animator = component as Animator;
				_setHierarchyAnimator(animator, _parent ? (_parent as Sprite3D)._hierarchyAnimator : null);
				_setAnimatorToLinkSprite3DNoAvatar(animator, true, new <String>[]);//此时一定没有Avatar
			} else if (component is Rigidbody) {
				for (var i:int = 0, n:int = _colliders.length; i < n; i++)
					_colliders[i]._setIsRigidbody(true);
			}
			if (component is Script)
				_scripts.push(component);
			component._initialize(this);
			return component;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _removeComponent(mapIndex:int, index:int):void {
			var i:int, n:int;
			var componentIndices:Vector.<int> = _typeComponentsIndices[mapIndex];
			var componentIndex:int = componentIndices[index];
			var component:Component3D = _components[componentIndex];
			
			if (component is Collider) {
				var colliderComponent:Collider = component as Collider;
				(displayedInStage) && (_layer._removeCollider(colliderComponent));
				_colliders.splice(_colliders.indexOf(colliderComponent), 1);
			} else if (component is Animator) {
				var animator:Animator = component as Animator;
				_clearHierarchyAnimator(animator, _parent ? (_parent as Sprite3D)._hierarchyAnimator : null);
			} else if (component is Rigidbody) {
				for (i = 0, n = _colliders.length; i < n; i++) {
					var collider:Collider = _colliders[i];
					collider._setIsRigidbody(false);
					var runtimeCollisonMap:Object = collider._runtimeCollisonMap;
					var runtimeCollisonTestMap:Object = collider._runtimeCollisonTestMap;
					for (var k:String in runtimeCollisonMap)
						delete runtimeCollisonTestMap[k];
				}
			}
			
			_components.splice(componentIndex, 1);
			if (component is Script)
				_scripts.splice(_scripts.indexOf(component as Script), 1);
			componentIndices.splice(index, 1);
			(componentIndices.length === 0) && (_typeComponentsIndices.splice(mapIndex, 1), _componentsMap.splice(mapIndex, 1));
			
			for (i = 0, n = _componentsMap.length; i < n; i++) {
				componentIndices = _typeComponentsIndices[i];
				for (var j:int = componentIndices.length - 1; j >= 0; j--) {
					var oldComponentIndex:int = componentIndices[j];
					if (oldComponentIndex > componentIndex)
						componentIndices[j] = --oldComponentIndex;
					else
						break;
				}
			}
			
			component._destroy();
		}
		
		/**
		 * @private
		 */
		override public function createConchModel():* {
			return __JS__("null");
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
		 *@private
		 */
		protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, nodeData:Object):void {
		
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
		 * 更新子节点。
		 * @param	state 渲染相关状态。
		 */
		protected function _updateChildsConch(state:RenderState):void {//NATIVE
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
			return material.id * VertexDeclaration._maxVertexDeclarationBit + renderElement._getVertexBuffer().vertexDeclaration.id;
		}
		
		/**
		 * 更新
		 * @param	state 渲染相关状态
		 */
		public function _update(state:RenderState):void {
			state.owner = this;
			if (_activeInHierarchy) {
				_updateComponents(state);
				_lateUpdateComponents(state);
				
				Stat.spriteCount++;
				_childs.length && _updateChilds(state);
			}
		}
		
		/**
		 * 更新
		 * @param	state 渲染相关状态
		 */
		public function _updateConch(state:RenderState):void {//NATIVE
			state.owner = this;
			if (_activeInHierarchy) {
				_updateComponents(state);
				_lateUpdateComponents(state);
				
				Stat.spriteCount++;
				_childs.length && _updateChilds(state);
			}
		}
		
		/**
		 * 获取投影视图世界矩阵。
		 * @param	projectionViewMatrix 投影视图矩阵。
		 * @return  投影视图世界矩阵。
		 */
		public function getProjectionViewWorldMatrix(projectionViewMatrix:Matrix4x4):Matrix4x4 {
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
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt(node:Node, index:int):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
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
					_addChild3D(node as Sprite3D);
				}
				return node;
			} else {
				throw new Error("appendChildAt:The index is out of bounds");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChild(node:Node):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
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
				_addChild3D(node as Sprite3D);
			}
			
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):Node {
			var node:Node = getChildAt(index);
			if (node) {
				_removeChild3D(node as Sprite3D);
				this._childs.splice(index, 1);
				conchModel && conchModel.removeChild(node.conchModel);
				node.parent = null;
			}
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):Node {
			if (_childs && _childs.length > 0) {
				var childs:Array = this._childs;
				if (beginIndex === 0 && endIndex >= n) {
					var arr:Array = childs;
					this._childs = ARRAY_EMPTY;
				} else {
					arr = childs.splice(beginIndex, endIndex - beginIndex);
				}
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					_removeChild3D(arr[i] as Sprite3D);
					arr[i].parent = null;
					conchModel && conchModel.removeChild(arr[i].conchModel);
				}
			}
			return this;
		}
		
		/**
		 *@private
		 */
		public function onAsynLoaded(url:String, data:*, params:Array):void {
			var json:Object = data[0];
			if (json.type !== "Sprite3D")
				throw new Error("Sprite3D: The .lh file root type must be Sprite3D,please use other function to  load  this file.");
			
			var innerResouMap:Object = data[1];
			Utils3D._createNodeByJson(this, json, this, innerResouMap);
			event(Event.HIERARCHY_LOADED, [this]);
			__loaded = true;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			if (destroyed)
				throw new Error("Sprite3D: Can't be cloned if the Sprite3D has destroyed.");
			
			var destSprite3D:Sprite3D = destObject as Sprite3D;
			
			destSprite3D.name = name/* + "(clone)"*/;//TODO:克隆后不能播放刚体动画，找不到名字
			destSprite3D._destroyed = _destroyed;
			destSprite3D.timer = timer;
			destSprite3D._$P = _$P;
			
			destSprite3D.active = _active;
			
			var destLocalPosition:Vector3 = destSprite3D.transform.localPosition;
			transform.localPosition.cloneTo(destLocalPosition);
			destSprite3D.transform.localPosition = destLocalPosition;
			
			var destLocalRotation:Quaternion = destSprite3D.transform.localRotation;
			transform.localRotation.cloneTo(destLocalRotation);
			destSprite3D.transform.localRotation = destLocalRotation;
			
			var destLocalScale:Vector3 = destSprite3D.transform.localScale;
			transform.localScale.cloneTo(destLocalScale);
			destSprite3D.transform.localScale = destLocalScale;
			
			destSprite3D.isStatic = isStatic;
			var i:int, n:int;
			for (i = 0, n = _componentsMap.length; i < n; i++) {
				var destComponent:Component3D = destSprite3D.addComponent(_componentsMap[i]);
				_components[i]._cloneTo(destComponent);
			}
			
			for (i = 0, n = _childs.length; i < n; i++)
				destSprite3D.addChild(_childs[i].clone());
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destSprite3D:Sprite3D = __JS__("new this.constructor()");
			cloneTo(destSprite3D);
			return destSprite3D;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			var i:int, n:int;
			for (i = 0, n = _components.length; i < n; i++)
				_components[i]._destroy();
			_components = null;
			_componentsMap = null;
			_typeComponentsIndices = null;
			_transform = null;
			_colliders = null;
			Loader.clearRes(url);
		}
		
		//兼容代码
		/**
		 * @private
		 */
		private function _handleSpriteToAvatar(animator:Animator, isLink:Boolean):void {
			var i:int, n:int;
			var avatarNodes:Vector.<AnimationNode> = animator._avatarNodes;
			var node:AnimationNode = animator._avatarNodeMap[name];//TODO:骨骼重名时存在问题
			if (node && node.name === name && !_transform.dummy) //判断!sprite._transform.dummy重名节点可按顺序依次匹配。
				_isLinkSpriteToAnimationNode(animator, node, isLink);
		}
		
		/**
		 * @private
		 */
		private function _setAnimatorToLinkAvatar(animator:Animator, isLink:Boolean):void {
			_handleSpriteToAvatar(animator, isLink);
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var child:Sprite3D = _childs[i];
				child._setAnimatorToLinkAvatar(animator, isLink);
			}
		}
		//兼容代码
	}
}
package laya.d3.core.render {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.ITreeNode;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.resource.IDestroy;
	
	/**
	 * <code>Render</code> 类用于渲染器的父类，抽象类不允许实例。
	 */
	public class BaseRender extends EventDispatcher implements IDestroy {
		/**@private */
		public static var _tempBoundBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/**@private */
		private static var _uniqueIDCounter:int = 0;
		/**@private */
		private static var _greenColor:Vector4 = new Vector4(0.0, 1.0, 0.0, 1.0);
		
		/**@private */
		private var _id:int;
		/**@private */
		private var _destroyed:Boolean;
		/** @private */
		private var _lightmapScaleOffset:Vector4;
		/** @private */
		private var _lightmapIndex:int;
		/** @private */
		private var _enable:Boolean;
		/** @private */
		private var _receiveShadow:Boolean;
		/** @private */
		private var _materialsInstance:Vector.<Boolean>;
		/** @private */
		protected var _boundingSphere:BoundSphere;
		/** @private */
		protected var _boundingBox:BoundBox;
		/** @private */
		protected var _boundingBoxCenter:Vector3;
		/** @private */
		protected var _boundingSphereNeedChange:Boolean;
		/** @private */
		protected var _boundingBoxNeedChange:Boolean;
		/** @private */
		protected var _boundingBoxCenterNeedChange:Boolean;
		/** @private */
		protected var _octreeNodeNeedChange:Boolean;
		
		/** @private */
		public var _indexInSceneFrustumCullingObjects:int;
		/** @private */
		public var _materials:Vector.<BaseMaterial>;
		/** @private */
		public var _owner:RenderableSprite3D;
		/** @private */
		public var _renderElements:Vector.<RenderElement>;
		/** @private */
		public var _distanceForSort:Number;
		/** @private */
		public var _treeNode:ITreeNode;
		/**@private */
		public var _isPartOfStaticBatch:Boolean;
		/**@private */
		public var _staticBatchRootSprite3D:Sprite3D;
		/**@private */
		public var _staticBatchRenderElements:Vector.<RenderElement>;
		
		/**排序矫正值。*/
		public var sortingFudge:Number;
		/** 是否产生阴影。 */
		public var castShadow:Boolean;
		
		/**
		 * 获取唯一标识ID,通常用于识别。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取光照贴图的索引。
		 * @return 光照贴图的索引。
		 */
		public function get lightmapIndex():int {
			return _lightmapIndex;
		}
		
		/**
		 * 设置光照贴图的索引。
		 * @param value 光照贴图的索引。
		 */
		public function set lightmapIndex(value:int):void {
			_lightmapIndex = value;
			_applyLightMapParams();
		}
		
		/**
		 * 获取光照贴图的缩放和偏移。
		 * @return  光照贴图的缩放和偏移。
		 */
		public function get lightmapScaleOffset():Vector4 {
			return _lightmapScaleOffset;
		}
		
		/**
		 * 设置光照贴图的缩放和偏移。
		 * @param  光照贴图的缩放和偏移。
		 */
		public function set lightmapScaleOffset(value:Vector4):void {
			_lightmapScaleOffset = value;
			_setShaderValueColor(RenderableSprite3D.LIGHTMAPSCALEOFFSET, value);
			_addShaderDefine(RenderableSprite3D.SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV);
		}
		
		/**
		 * 获取是否可用。
		 * @return 是否可用。
		 */
		public function get enable():Boolean {
			return _enable;
		}
		
		/**
		 * 设置是否可用。
		 * @param value 是否可用。
		 */
		public function set enable(value:Boolean):void {
			_enable = value;
			event(Event.ENABLE_CHANGED, [this, value]);
		}
		
		/**
		 * 返回第一个实例材质,第一次使用会拷贝实例对象。
		 * @return 第一个实例材质。
		 */
		public function get material():BaseMaterial {
			var material:BaseMaterial = _materials[0];
			if (material && !_materialsInstance[0]) {
				var insMat:BaseMaterial = _getInstanceMaterial(material,0);
				event(Event.MATERIAL_CHANGED, [this, 0, insMat]);
			}
			return _materials[0];
		}
		
		/**
		 * 设置第一个实例材质。
		 * @param value 第一个实例材质。
		 */
		public function set material(value:BaseMaterial):void {
			sharedMaterial = value;
		}
		
		/**
		 * 获取潜拷贝实例材质列表,第一次使用会拷贝实例对象。
		 * @return 浅拷贝实例材质列表。
		 */
		public function get materials():Vector.<BaseMaterial> {
			for (var i:int = 0, n:int = _materials.length; i < n; i++) {
				if (!_materialsInstance[i]) {
					var insMat:BaseMaterial = _getInstanceMaterial(_materials[i],i);
					event(Event.MATERIAL_CHANGED, [this, i, insMat]);
				}
			}
			return _materials.slice();
		}
		
		/**
		 * 设置实例材质列表。
		 * @param value 实例材质列表。
		 */
		public function set materials(value:Vector.<BaseMaterial>):void {
			sharedMaterials = value;
		}
		
		/**
		 * 返回第一个材质。
		 * @return 第一个材质。
		 */
		public function get sharedMaterial():BaseMaterial {
			return _materials[0];
		}
		
		/**
		 * 设置第一个材质。
		 * @param value 第一个材质。
		 */
		public function set sharedMaterial(value:BaseMaterial):void {
			var lastValue:BaseMaterial = _materials[0];
			if (lastValue !== value) {
				_materials[0] = value;
				_materialsInstance[0] = false;
				_changeMaterialReference(lastValue, value);
				event(Event.MATERIAL_CHANGED, [this, 0, value]);
			}
		}
		
		/**
		 * 获取浅拷贝材质列表。
		 * @return 浅拷贝材质列表。
		 */
		public function get sharedMaterials():Vector.<BaseMaterial> {
			var materials:Vector.<BaseMaterial> = _materials.slice();
			return materials;
		}
		
		/**
		 * 设置材质列表。
		 * @param value 材质列表。
		 */
		public function set sharedMaterials(value:Vector.<BaseMaterial>):void {
			if (!value)
				throw new Error("MeshRender: shadredMaterials value can't be null.");
			var len:int = value.length;
			_materialsInstance.length = len;
			for (var i:int = 0; i < len; i++) {
				var lastValue:BaseMaterial = _materials[i];
				if (lastValue !== value[i]) {
					_materialsInstance[i] = false;
					_changeMaterialReference(lastValue, value[i]);
					event(Event.MATERIAL_CHANGED, [this, i, value[i]]);
				}
			}
			_materials = value;
		}
		
		/**
		 * 获取包围球,只读,不允许修改其值。
		 * @return 包围球。
		 */
		public function get boundingSphere():BoundSphere {
			if (_boundingSphereNeedChange) {
				_calculateBoundingSphere();
				_boundingSphereNeedChange = false;
			}
			return _boundingSphere;
		}
		
		/**
		 * 获取包围盒,只读,不允许修改其值。
		 * @return 包围盒。
		 */
		public function get boundingBox():BoundBox {
			if (_boundingBoxNeedChange) {
				_calculateBoundingBox();
				_boundingBoxNeedChange = false;
			}
			return _boundingBox;
		}
		
		/**
		 * 获取包围盒中心,不允许修改其值。
		 * @return 包围盒中心。
		 */
		public function get boundingBoxCenter():Vector3 {
			if (_boundingBoxCenterNeedChange) {
				var boundBox:BoundBox = boundingBox;
				Vector3.add(boundBox.min, boundBox.max, _boundingBoxCenter);
				Vector3.scale(_boundingBoxCenter, 0.5, _boundingBoxCenter);
				_boundingBoxCenterNeedChange = false;
			}
			return _boundingBoxCenter;
		}
		
		/**
		 * 设置是否接收阴影属性
		 */
		public function set receiveShadow(value:Boolean):void {
			if (_receiveShadow !== value) {
				_receiveShadow = value;
				if (value)
					_addShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_RECEIVE_SHADOW);
				else
					_removeShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_RECEIVE_SHADOW);
			}
		}
		
		/**
		 * 获得是否接收阴影属性
		 */
		public function get receiveShadow():Boolean {
			return _receiveShadow;
		}
		
		/**
		 * 获取是否已销毁。
		 * @return 是否已销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个新的 <code>BaseRender</code> 实例。
		 */
		public function BaseRender(owner:RenderableSprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_uniqueIDCounter;
			_indexInSceneFrustumCullingObjects = -1;
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			_boundingBoxCenter = new Vector3();
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_boundingBoxCenterNeedChange = true;
			_octreeNodeNeedChange = true;
			_materials = new Vector.<BaseMaterial>();
			_renderElements = new Vector.<RenderElement>();
			_isPartOfStaticBatch = false;
			_destroyed = false;
			_owner = owner;
			_enable = true;
			_materialsInstance = new Vector.<Boolean>();
			lightmapIndex = -1;
			castShadow = false;
			receiveShadow = false;
			sortingFudge = 0.0;
			_owner.transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatNeedChange);
		}
		
		/**
		 * @private
		 */
		private function _changeMaterialReference(lastValue:BaseMaterial, value:BaseMaterial):void {
			(lastValue) && (lastValue._removeReference());
			value._addReference();
		}
		
		/**
		 * @private
		 */
		private function _getInstanceMaterial(material:BaseMaterial,index:int):BaseMaterial {
			var insMat:BaseMaterial = __JS__("new material.constructor()");
			material.cloneTo(insMat);//深拷贝
			insMat.name = insMat.name + "(Instance)";
			_materialsInstance[index] = true;
			_changeMaterialReference(_materials[index], insMat);
			_materials[index] = insMat;
			return insMat;
		}
		
		/**
		 * @private
		 */
		private function _setShaderValuelightMap(lightMap:Texture2D):void {
			_setShaderValueTexture(RenderableSprite3D.LIGHTMAP, lightMap);
		}
		
		/**
		 * @private
		 */
		protected function _onWorldMatNeedChange():void {
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_boundingBoxCenterNeedChange = true;
			_octreeNodeNeedChange = true;
		}
		
		/**
		 * @private
		 */
		protected function _renderRenderableBoundBox():void {
			var linePhasor:PhasorSpriter3D = Laya3D._debugPhasorSprite;
			var boundBox:BoundBox = boundingBox;
			var corners:Vector.<Vector3> = _tempBoundBoxCorners;
			boundBox.getCorners(corners);
			linePhasor.line(corners[0], _greenColor, corners[1], _greenColor);
			linePhasor.line(corners[2], _greenColor, corners[3], _greenColor);
			linePhasor.line(corners[4], _greenColor, corners[5], _greenColor);
			linePhasor.line(corners[6], _greenColor, corners[7], _greenColor);
			
			linePhasor.line(corners[0], _greenColor, corners[3], _greenColor);
			linePhasor.line(corners[1], _greenColor, corners[2], _greenColor);
			linePhasor.line(corners[2], _greenColor, corners[6], _greenColor);
			linePhasor.line(corners[3], _greenColor, corners[7], _greenColor);
			
			linePhasor.line(corners[0], _greenColor, corners[4], _greenColor);
			linePhasor.line(corners[1], _greenColor, corners[5], _greenColor);
			linePhasor.line(corners[4], _greenColor, corners[7], _greenColor);
			linePhasor.line(corners[5], _greenColor, corners[6], _greenColor);
		}
		
		/**
		 * @private
		 */
		protected function _calculateBoundingSphere():void {
			throw("BaseRender: must override it.");
		}
		
		/**
		 * @private
		 */
		protected function _calculateBoundingBox():void {
			throw("BaseRender: must override it.");
		}
		
		/**
		 * @private
		 */
		public function _setShaderValueTexture(shaderName:int, texture:BaseTexture):void {
			_owner._shaderValues.setValue(shaderName, texture);
		}
		
		/**
		 * @private
		 */
		public function _setShaderValueMatrix4x4(shaderName:int, matrix4x4:Matrix4x4):void {
			_owner._shaderValues.setValue(shaderName, matrix4x4 ? matrix4x4.elements : null);
		}
		
		/**
		 * 设置颜色。
		 * @param	shaderIndex shader索引。
		 * @param	color 颜色向量。
		 */
		public function _setShaderValueColor(shaderIndex:int, color:*):void {
			_owner._shaderValues.setValue(shaderIndex, color ? color.elements : null);
		}
		
		/**
		 * 设置Buffer。
		 * @param	shaderIndex shader索引。
		 * @param	buffer  buffer数据。
		 */
		public function _setShaderValueBuffer(shaderIndex:int, buffer:Float32Array):void {
			_owner._shaderValues.setValue(shaderIndex, buffer);
		}
		
		/**
		 * 设置整型。
		 * @param	shaderIndex shader索引。
		 * @param	i 整形。
		 */
		public function _setShaderValueInt(shaderIndex:int, i:int):void {
			_owner._shaderValues.setValue(shaderIndex, i);
		}
		
		/**
		 * 设置布尔。
		 * @param	shaderIndex shader索引。
		 * @param	b 布尔。
		 */
		public function _setShaderValueBool(shaderIndex:int, b:Boolean):void {
			_owner._shaderValues.setValue(shaderIndex, b);
		}
		
		/**
		 * 设置浮点。
		 * @param	shaderIndex shader索引。
		 * @param	i 浮点。
		 */
		public function _setShaderValueNumber(shaderIndex:int, number:Number):void {
			_owner._shaderValues.setValue(shaderIndex, number);
		}
		
		/**
		 * 设置二维向量。
		 * @param	shaderIndex shader索引。
		 * @param	vector2 二维向量。
		 */
		public function _setShaderValueVector2(shaderIndex:int, vector2:Vector2):void {
			_owner._shaderValues.setValue(shaderIndex, vector2 ? vector2.elements : null);
		}
		
		/**
		 * 增加Shader宏定义。
		 * @param value 宏定义。
		 */
		public function _addShaderDefine(value:int):void {
			_owner._shaderDefineValue |= value;
		}
		
		/**
		 * 移除Shader宏定义。
		 * @param value 宏定义。
		 */
		public function _removeShaderDefine(value:int):void {
			_owner._shaderDefineValue &= ~value;
		}
		
		/**
		 * @private
		 */
		public function _renderUpdate(projectionView:Matrix4x4):Boolean {
			return true;
		}
		
		/**
		 * @private
		 */
		public function _applyLightMapParams():void {
			if (_lightmapIndex >= 0) {
				var scene:Scene = _owner.scene;
				if (scene) {
					var lightMaps:Vector.<Texture2D> = scene.getlightmaps();
					var lightMap:Texture2D = lightMaps[_lightmapIndex];
					if (lightMap) {
						_addShaderDefine(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
						if (lightMap.loaded)
							_setShaderValuelightMap(lightMap);
						else
							lightMap.once(Event.LOADED, this, _setShaderValuelightMap);
					} else {
						_removeShaderDefine(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
					}
				} else {
					_removeShaderDefine(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
				}
			} else {
				_removeShaderDefine(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
			}
		}
		
		/**
		 * @private
		 */
		public function _updateOctreeNode():void {
			var treeNode:ITreeNode = _treeNode;
			if (treeNode && _octreeNodeNeedChange) {
				treeNode.updateObject(this);
				_octreeNodeNeedChange = false;
			}
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			offAll();
			var i:int = 0, n:int = 0;
			for (i = 0, n = _renderElements.length; i < n; i++)
				_renderElements[i]._destroy();
			for (i = 0, n = _materials.length; i < n; i++)
				_materials[i]._removeReference();
			
			_renderElements = null;
			_owner = null;
			_materials = null;
			_boundingBox = null;
			_boundingBoxCenter = null;
			_boundingSphere = null;
			_lightmapScaleOffset = null;
			_destroyed = true;
		}
	
	}

}
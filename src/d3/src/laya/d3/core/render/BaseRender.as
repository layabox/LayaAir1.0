package laya.d3.core.render {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.BoundsOctreeNode;
	import laya.d3.core.scene.IOctreeObject;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.Render;
	import laya.resource.ISingletonElement;
	import laya.webgl.resource.Texture2D;
	
	/**
	 * <code>Render</code> 类用于渲染器的父类，抽象类不允许实例。
	 */
	public class BaseRender extends EventDispatcher implements ISingletonElement, IOctreeObject {
		/**@private */
		public static var _tempBoundBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/**@private */
		private static var _uniqueIDCounter:int = 0;
		
		/**@private */
		private var _id:int;
		/** @private */
		private var _lightmapScaleOffset:Vector4;
		/** @private */
		private var _lightmapIndex:int;
		/** @private */
		private var _receiveShadow:Boolean;
		/** @private */
		private var _materialsInstance:Vector.<Boolean>;
		/** @private */
		private var _castShadow:Boolean;
		/** @private  [实现IListPool接口]*/
		private var _indexInList:int = -1;
		/** @private */
		public var _indexInCastShadowList:int = -1;
		
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
		public var _enable:Boolean;
		/** @private */
		public var _shaderValues:ShaderData;
		/** @private */
		public var _defineDatas:DefineDatas;
		
		/** @private */
		public var _sharedMaterials:Vector.<BaseMaterial>;
		/** @private */
		public var _scene:Scene3D;
		/** @private */
		public var _owner:RenderableSprite3D;
		/** @private */
		public var _renderElements:Vector.<RenderElement>;
		/** @private */
		public var _distanceForSort:Number;
		/**@private */
		public var _visible:Boolean = true;//初始值为默认可见,否则会造成第一帧动画不更新等，TODO:还有个包围盒更新好像浪费了
		/** @private */
		public var _octreeNode:BoundsOctreeNode;
		/** @private */
		public var _indexInOctreeMotionList:int = -1;
		
		/** @private */
		public var _updateMark:int=-1;
		/** @private */
		public var _updateRenderType:int=-1;
		/** @private */
		public var _isPartOfStaticBatch:Boolean = false;
		/** @private */
		public var _staticBatch:GeometryElement = null;
		
		/**排序矫正值。*/
		public var sortingFudge:Number;
		
		/**@private	[NATIVE]*/
		public var _cullingBufferIndex:int;
		
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
			if (_lightmapIndex !== value) {
				_lightmapIndex = value;
				_applyLightMapParams();
			}
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
			_shaderValues.setVector(RenderableSprite3D.LIGHTMAPSCALEOFFSET, value);
			_defineDatas.add(RenderableSprite3D.SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV);
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
			_enable = !!value;
		}
		
		/**
		 * 返回第一个实例材质,第一次使用会拷贝实例对象。
		 * @return 第一个实例材质。
		 */
		public function get material():BaseMaterial {
			var material:BaseMaterial = _sharedMaterials[0];
			if (material && !_materialsInstance[0]) {
				var insMat:BaseMaterial = _getInstanceMaterial(material, 0);
				var renderElement:RenderElement = _renderElements[0];
				(renderElement) && (renderElement.material = insMat);
			}
			return _sharedMaterials[0];
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
			for (var i:int = 0, n:int = _sharedMaterials.length; i < n; i++) {
				if (!_materialsInstance[i]) {
					var insMat:BaseMaterial = _getInstanceMaterial(_sharedMaterials[i], i);
					var renderElement:RenderElement = _renderElements[i];
					(renderElement) && (renderElement.material = insMat);
				}
			}
			return _sharedMaterials.slice();
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
			return _sharedMaterials[0];
		}
		
		/**
		 * 设置第一个材质。
		 * @param value 第一个材质。
		 */
		public function set sharedMaterial(value:BaseMaterial):void {
			var lastValue:BaseMaterial = _sharedMaterials[0];
			if (lastValue !== value) {
				_sharedMaterials[0] = value;
				_materialsInstance[0] = false;
				_changeMaterialReference(lastValue, value);
				var renderElement:RenderElement = _renderElements[0];
				(renderElement) && (renderElement.material = value);
			}
		}
		
		/**
		 * 获取浅拷贝材质列表。
		 * @return 浅拷贝材质列表。
		 */
		public function get sharedMaterials():Vector.<BaseMaterial> {
			var materials:Vector.<BaseMaterial> = _sharedMaterials.slice();
			return materials;
		}
		
		/**
		 * 设置材质列表。
		 * @param value 材质列表。
		 */
		public function set sharedMaterials(value:Vector.<BaseMaterial>):void {
			if (!value)
				throw new Error("BaseRender: shadredMaterials value can't be null.");
			var len:int = value.length;
			_materialsInstance.length = len;
			for (var i:int = 0; i < len; i++) {
				var lastValue:BaseMaterial = _sharedMaterials[i];
				if (lastValue !== value[i]) {
					_materialsInstance[i] = false;
					_changeMaterialReference(lastValue, value[i]);
					var renderElement:RenderElement = _renderElements[i];
					(renderElement) && (renderElement.material = value[i]);
				}
			}
			_sharedMaterials = value;
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
					_defineDatas.add(RenderableSprite3D.SHADERDEFINE_RECEIVE_SHADOW);
				else
					_defineDatas.remove(RenderableSprite3D.SHADERDEFINE_RECEIVE_SHADOW);
			}
		}
		
		/**
		 * 获得是否接收阴影属性
		 */
		public function get receiveShadow():Boolean {
			return _receiveShadow;
		}
		
		/**
		 * 获取是否产生阴影。
		 * @return 是否产生阴影。
		 */
		public function get castShadow():Boolean {
			return _castShadow;
		}
		
		/**
		 *	设置是否产生阴影。
		 * 	@param value 是否产生阴影。
		 */
		public function set castShadow(value:Boolean):void {
			if (_castShadow !== value) {
				if (_owner.activeInHierarchy) {
					if (value)
						_scene._addShadowCastRenderObject(this);
					else
						_scene._removeShadowCastRenderObject(this);
				}
				_castShadow = value;
			}
		}
		
		/**
		 * 是否是静态的一部分。
		 */
		public function get isPartOfStaticBatch():Boolean {
			return _isPartOfStaticBatch;
		}
		
		/**
		 * @private
		 * 创建一个新的 <code>BaseRender</code> 实例。
		 */
		public function BaseRender(owner:RenderableSprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_uniqueIDCounter;
			_indexInCastShadowList = -1;
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			_boundingBoxCenter = new Vector3();
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			if (Render.supportWebGLPlusCulling) {//[NATIVE]
				var length:int = FrustumCulling._cullingBufferLength;
				_cullingBufferIndex = length;
				var cullingBuffer:Float32Array = FrustumCulling._cullingBuffer;
				var resizeLength:int = length + 5;
				if (resizeLength >= cullingBuffer.length) {
					var temp:Float32Array = cullingBuffer;
					cullingBuffer = FrustumCulling._cullingBuffer = new Float32Array(cullingBuffer.length + 4096);
					cullingBuffer.set(temp, 0);
				}
				cullingBuffer[length] = 1;
				FrustumCulling._cullingBufferLength = resizeLength;
			}
			
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_boundingBoxCenterNeedChange = true;
			_sharedMaterials = new Vector.<BaseMaterial>();
			_renderElements = new Vector.<RenderElement>();
			_owner = owner;
			_enable = true;
			_materialsInstance = new Vector.<Boolean>();
			_shaderValues = new ShaderData(null);
			_defineDatas = new DefineDatas();
			lightmapIndex = -1;
			_castShadow = false;
			receiveShadow = false;
			sortingFudge = 0.0;
			(owner) && (_owner.transform.on(Event.TRANSFORM_CHANGED, this, _onWorldMatNeedChange));//如果为合并BaseRender,owner可能为空
		}
		
		/**
		 * @private
		 */
		public function _getOctreeNode():BoundsOctreeNode {//[实现IOctreeObject接口]
			return _octreeNode;
		}
		
		/**
		 * @private
		 */
		public function _setOctreeNode(value:BoundsOctreeNode):void {//[实现IOctreeObject接口]
			_octreeNode = value;
		}
		
		/**
		 * @private
		 */
		public function _getIndexInMotionList():int {//[实现IOctreeObject接口]
			return _indexInOctreeMotionList;
		}
		
		/**
		 * @private
		 */
		public function _setIndexInMotionList(value:int):void {//[实现IOctreeObject接口]
			_indexInOctreeMotionList = value;
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
		private function _getInstanceMaterial(material:BaseMaterial, index:int):BaseMaterial {
			var insMat:BaseMaterial = __JS__("new material.constructor()");
			material.cloneTo(insMat);//深拷贝
			insMat.name = insMat.name + "(Instance)";
			_materialsInstance[index] = true;
			_changeMaterialReference(_sharedMaterials[index], insMat);
			_sharedMaterials[index] = insMat;
			return insMat;
		}
		
		/**
		 * @private
		 */
		public function _applyLightMapParams():void {
			if (_scene && _lightmapIndex >= 0) {
				var lightMaps:Vector.<Texture2D> = _scene.getlightmaps();
				if (_lightmapIndex < lightMaps.length) {
					_defineDatas.add(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
					_shaderValues.setTexture(RenderableSprite3D.LIGHTMAP, lightMaps[_lightmapIndex]);
				} else {
					_defineDatas.remove(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
				}
			} else {
				_defineDatas.remove(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
			}
		}
		
		/**
		 * @private
		 */
		protected function _onWorldMatNeedChange(flag:int):void {
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_boundingBoxCenterNeedChange = true;
			
			if (_octreeNode) {
				flag &= Transform3D.TRANSFORM_WORLDPOSITION | Transform3D.TRANSFORM_WORLDQUATERNION | Transform3D.TRANSFORM_WORLDSCALE;//过滤有用TRANSFORM标记
				if (flag) {
					if (_indexInOctreeMotionList === -1)//_octreeNode表示在八叉树队列中
						_octreeNode._octree.addMotionObject(this);
				}
			}
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
		 * @private [实现ISingletonElement接口]
		 */
		public function _getIndexInList():int {
			return _indexInList;
		}
		
		/**
		 * @private [实现ISingletonElement接口]
		 */
		public function _setIndexInList(index:int):void {
			_indexInList = index;
		}
		
		/**
		 * @private
		 */
		public function _setBelongScene(scene:Scene3D):void {
			if (_scene !== scene) {
				_scene = scene;
				_applyLightMapParams();
			}
		}
		
		/**
		 * @private
		 * @param boundFrustum 如果boundFrustum为空则为摄像机不裁剪模式。
		 */
		public function _needRender(boundFrustum:BoundFrustum):Boolean {
			return true;
		}
		
		/**
		 * @private
		 */
		public function _renderUpdate(context:RenderContext3D, transform:Transform3D):void {
		}
		
		/**
		 * @private
		 */
		public function _renderUpdateWithCamera(context:RenderContext3D, transform:Transform3D):void {
		}
		
		/**
		 * @private
		 */
		public function _revertBatchRenderUpdate(context:RenderContext3D):void {
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			(_indexInOctreeMotionList !== -1) && (_octreeNode._octree.removeMotionObject(this));
			offAll();
			var i:int = 0, n:int = 0;
			for (i = 0, n = _renderElements.length; i < n; i++)
				_renderElements[i].destroy();
			for (i = 0, n = _sharedMaterials.length; i < n; i++)
				(_sharedMaterials[i].destroyed) || (_sharedMaterials[i]._removeReference());//TODO:材质可能为空
			
			_renderElements = null;
			_owner = null;
			_sharedMaterials = null;
			_boundingBox = null;
			_boundingBoxCenter = null;
			_boundingSphere = null;
			_lightmapScaleOffset = null;
		}
	}
}
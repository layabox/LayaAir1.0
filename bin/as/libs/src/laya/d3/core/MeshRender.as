package laya.d3.core {
	import laya.d3.core.material.Material;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.resource.IDispose;
	
	/**
	 * <code>MeshRender</code> 类用于网格渲染器。
	 */
	public class MeshRender extends EventDispatcher implements IDispose {
		/** @private */
		private var _boundingObjectNeedChange:Boolean;
		
		/** @private */
		private var _owner:MeshSprite3D;
		/** @private */
		private var _materials:Vector.<Material>;
		/** @private */
		private var _frustumCulling:FrustumCullingObject;
		/** @private */
		private var _boundingSphere:BoundSphere;
		/** @private */
		private var _boundingBox:BoundBox;
		
		/** 是否产生阴影。 */
		public var castShadow:Boolean;
		/** 是否接收阴影。 */
		public var receiveShadow:Boolean;
		
		/**
		 * 返回第一个实例材质,第一次使用会拷贝实例对象。
		 * @return 第一个实例材质。
		 */
		public function get material():Material {
			var material:Material = _materials[0];
			if (material && !material._isInstance) {
				var instanceMaterial:Material = new Material();
				material.copy(instanceMaterial);//深拷贝，暂不处罚更换材质事件
				instanceMaterial.name = instanceMaterial.name + "(Instance)";
				instanceMaterial._isInstance = true;
				_materials[0] = instanceMaterial;
			}
			return _materials[0];
		}
		
		/**
		 * 设置第一个实例材质。
		 * @param value 第一个实例材质。
		 */
		public function set material(value:Material):void {
			var oldMaterial:Material = _materials[0];
			_materials[0] = value;
			event(Event.MATERIAL_CHANGED, [this, [oldMaterial], [value]]);
		}
		
		/**
		 * 获取潜拷贝实例材质列表,第一次使用会拷贝实例对象。
		 * @return 浅拷贝实例材质列表。
		 */
		public function get materials():Vector.<Material> {
			for (var i:int = 0, n:int = _materials.length; i < n; i++) {
				var material:Material = _materials[i];
				if (!material._isInstance) {
					var instanceMaterial:Material = new Material();
					material.copy(instanceMaterial);//深拷贝，暂不处理更换材质事件
					instanceMaterial.name = instanceMaterial.name + "(Instance)";
					instanceMaterial._isInstance = true;
					_materials[i] = instanceMaterial;
				}
			}
			return _materials.slice();
		}
		
		/**
		 * 设置实例材质列表。
		 * @param value 实例材质列表。
		 */
		public function set materials(value:Vector.<Material>):void {
			if (!value)
				throw new Error("MeshRender: materials value can't be null.");
			
			var oldMaterials:Vector.<Material> = _materials;
			_materials = value;
			_owner._iAsyncLodingMeshMaterial = false;
			event(Event.MATERIAL_CHANGED, [this, oldMaterials.slice(), value.slice()]);
		}
		
		/**
		 * 返回第一个材质。
		 * @return 第一个材质。
		 */
		public function get shadredMaterial():Material {
			return _materials[0];
		}
		
		/**
		 * 设置第一个材质。
		 * @param value 第一个材质。
		 */
		public function set shadredMaterial(value:Material):void {
			var oldMaterial:Material = _materials[0];
			_materials[0] = value;
			event(Event.MATERIAL_CHANGED, [this, [oldMaterial], [value]]);
		}
		
		/**
		 * 获取浅拷贝材质列表。
		 * @return 浅拷贝材质列表。
		 */
		public function get shadredMaterials():Vector.<Material> {
			var materials:Vector.<Material> = _materials.slice();
			return materials;
		}
		
		/**
		 * 设置材质列表。
		 * @param value 材质列表。
		 */
		public function set shadredMaterials(value:Vector.<Material>):void {
			if (!value)
				throw new Error("MeshRender: shadredMaterials value can't be null.");
			
			var oldMaterials:Vector.<Material> = _materials;
			_materials = value;
			_owner._iAsyncLodingMeshMaterial = false;
			event(Event.MATERIAL_CHANGED, [this, oldMaterials.slice(), value.slice()]);
		}
		
		/**
		 * 获取包围盒。
		 * @return 包围盒。
		 */
		public function get boundingBox():BoundBox {
			_calculateBoundingObject();
			return _boundingBox;
		}
		
		/**
		 * 获取包围球。
		 * @return 包围球。
		 */
		public function get boundingSphere():BoundSphere {
			_calculateBoundingObject();
			return _boundingSphere;
		}
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:MeshSprite3D) {
			_materials = new Vector.<Material>();
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			
			_boundingObjectNeedChange = true;
			_owner = owner;
			castShadow = true;
			receiveShadow = true;
			
			_frustumCulling = new FrustumCullingObject();
			_frustumCulling._component = this;
			
			_frustumCulling._layerMask = _owner.layer.mask;
			_frustumCulling._ownerEnable = _owner.enable;
			
			_owner.transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatNeedChange);
			_owner.on(Event.LAYER_CHANGED, this, _onOwnerLayerChanged);
			_owner.on(Event.ENABLED_CHANGED, this, _onOwnerEnableChanged);
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatNeedChange():void {
			_boundingObjectNeedChange = true;
		}
		
		/**
		 * @private
		 */
		private function _onOwnerLayerChanged(layer:Layer):void {
			_frustumCulling._layerMask = layer.mask;
		}
		
		/**
		 * @private
		 */
		private function _onOwnerEnableChanged(enable:Boolean):void {
			_frustumCulling._ownerEnable = enable;
		}
		
		/**
		 * @private
		 */
		private function _calculateBoundingObject():void {
			if (_boundingObjectNeedChange) {
				if (_owner.meshFilter.sharedMesh == null) {
					_boundingBox.toDefault();
					_boundingSphere.toDefault();
				} else {
					var meshBoundingSphere:BoundSphere = _owner.meshFilter.sharedMesh._boundingSphere;
					var maxScale:Number;
					var transform:Transform3D = _owner.transform;
					var scale:Vector3 = transform.scale;
					if (scale.x >= scale.y && scale.x >= scale.z)
						maxScale = scale.x;
					else
						maxScale = scale.y >= scale.z ? scale.y : scale.z;
					
					var worldMat:Matrix4x4 = transform.worldMatrix;
					Vector3.transformCoordinate(meshBoundingSphere.center, worldMat, _boundingSphere.center);
					_boundingSphere.radius = meshBoundingSphere.radius * maxScale;
					
					var meshBoudingBox:BoundBox = _owner.meshFilter.sharedMesh._boundingBox;//TODO:有问题,应该获取Corners八个点然后转换。
					Vector3.transformCoordinate(meshBoudingBox.min, worldMat, _boundingBox.min);
					Vector3.transformCoordinate(meshBoudingBox.max, worldMat, _boundingBox.max)
				}
				_boundingObjectNeedChange = false;
			}
		}
		
		/**
		 * @private
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function dispose():void {
			_owner.transform.off(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatNeedChange);
			_owner.off(Event.LAYER_CHANGED, this, _onOwnerLayerChanged);
			_owner.off(Event.ENABLED_CHANGED, this, _onOwnerEnableChanged);
		}
	
	}

}
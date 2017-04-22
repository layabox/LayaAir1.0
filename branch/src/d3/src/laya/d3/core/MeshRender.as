package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.RenderSprite;
	import laya.resource.IDispose;
	
	/**
	 * <code>MeshRender</code> 类用于网格渲染器。
	 */
	public class MeshRender extends BaseRender {
		/** @private */
		private var _meshSprite3DOwner:MeshSprite3D;
		///** @private */
		//private var _lightmapIndex:int;//TODO:改良光照贴图到世界
		/** @private */
		private var _lightmapScaleOffset:Vector4;
		/** 光照贴图的索引。*/
		public var lightmapIndex:int;
		
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
			_owner._setShaderValueColor(MeshSprite3D.LIGHTMAPSCALEOFFSET, value);
			_owner._addShaderDefine(RenderableSprite3D.SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV);
		}
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:MeshSprite3D) {
			super(owner);
			_meshSprite3DOwner = owner;
			lightmapIndex = -1;
			castShadow = false;
			receiveShadow = false;
			_meshSprite3DOwner.meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(sender:MeshFilter, oldMesh:BaseMesh, mesh:BaseMesh):void {
			if (mesh.loaded) {
				_boundingSphereNeedChange = _boundingBoxNeedChange = _boundingBoxCenterNeedChange = _octreeNodeNeedChange = true;
			} else {
				mesh.once(Event.LOADED, this, _onMeshLoaed);
			}
		
		}
		
		/**
		 * @private
		 */
		private function _onMeshLoaed(sender:MeshRender, enable:Boolean):void {
			_boundingSphereNeedChange = _boundingBoxNeedChange = _boundingBoxCenterNeedChange = _octreeNodeNeedChange = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			var sharedMesh:BaseMesh = _meshSprite3DOwner.meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingSphere == null) {
				_boundingSphere.toDefault();
			} else {
				var meshBoundingSphere:BoundSphere = sharedMesh.boundingSphere;
				var maxScale:Number;
				var transform:Transform3D = _meshSprite3DOwner.transform;
				var scale:Vector3 = transform.scale;
				if (scale.x >= scale.y && scale.x >= scale.z)
					maxScale = scale.x;
				else
					maxScale = scale.y >= scale.z ? scale.y : scale.z;
				
				Vector3.transformCoordinate(meshBoundingSphere.center, transform.worldMatrix, _boundingSphere.center);
				_boundingSphere.radius = meshBoundingSphere.radius * maxScale;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {
			var sharedMesh:BaseMesh = _meshSprite3DOwner.meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingBox == null) {
				_boundingBox.toDefault();
			} else {
				var worldMat:Matrix4x4 = _meshSprite3DOwner.transform.worldMatrix;
				var corners:Vector.<Vector3> = sharedMesh.boundingBoxCorners;
				for (var i:int = 0; i < 8; i++)
					Vector3.transformCoordinate(corners[i], worldMat, _tempBoudingBoxCorners[i]);
				BoundBox.createfromPoints(_tempBoudingBoxCorners, _boundingBox);
			}
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			_lightmapScaleOffset = null;
			_meshSprite3DOwner = null;
		
		}
	
	}

}
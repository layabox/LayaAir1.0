package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.graphics.RenderObject;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.RenderSprite;
	import laya.resource.IDispose;
	
	/**
	 * <code>MeshRender</code> 类用于网格渲染器。
	 */
	public class MeshRender extends BaseRender {
		/** @private */
		private static var _tempBoudingBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/** @private */
		private var _meshSprite3DOwner:MeshSprite3D;
		///** @private */
		//private var _lightmapIndex:int;
		/** @private */
		private var _lightmapScaleOffset:Vector4;
		
		/** 是否产生阴影。 */
		public var castShadow:Boolean;
		/** 是否接收阴影。 */
		public var receiveShadow:Boolean;
		
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
			_owner._addShaderDefine(ShaderDefines3D.SCALEOFFSETLIGHTINGMAPUV);
		}
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:MeshSprite3D) {
			super(owner);
			_meshSprite3DOwner = owner;
			lightmapIndex = -1;
			castShadow = true;
			receiveShadow = true;
			
			_meshSprite3DOwner.meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(sender:MeshFilter, oldMesh:BaseMesh, mesh:BaseMesh):void {
			if (mesh.loaded) {
				_boundingSphereNeedChange = true;
				_boundingBoxNeedChange = true;
				_octreeNodeNeedChange = true;
			} else {
				mesh.once(Event.LOADED, this, _onMeshLoaed);
			}
		}
		
		/**
		 * @private
		 */
		private function _onMeshLoaed(sender:MeshRender, enable:Boolean):void {
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_octreeNodeNeedChange = true;
		}
		
		override protected function _calculateBoundingSphere():void {
			if (_meshSprite3DOwner.meshFilter.sharedMesh === null || _meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere === null) {
				_boundingSphere.toDefault();
			} else {
				var meshBoundingSphere:BoundSphere = _meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere;
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
		
		override protected function _calculateBoundingBox():void {
			if (_meshSprite3DOwner.meshFilter.sharedMesh === null || _meshSprite3DOwner.meshFilter.sharedMesh.boundingBox === null) {
				_boundingBox.toDefault();
			} else {
				var worldMat:Matrix4x4 = _meshSprite3DOwner.transform.worldMatrix;
				var corners:Vector.<Vector3> = _meshSprite3DOwner.meshFilter.sharedMesh.boundingBoxCorners;
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
			_meshSprite3DOwner = null;
		
		}
	
	}

}
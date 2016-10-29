package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.graphics.RenderObject;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
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
		
		/** 是否产生阴影。 */
		public var castShadow:Boolean;
		/** 是否接收阴影。 */
		public var receiveShadow:Boolean;
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:MeshSprite3D) {
			super(owner);
			_meshSprite3DOwner = owner;
			
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
				var meshBoudingBox:BoundBox = _meshSprite3DOwner.meshFilter.sharedMesh.boundingBox;//TODO:有问题,应该获取Corners八个点然后转换。
				var worldMat:Matrix4x4 = _meshSprite3DOwner.transform.worldMatrix;
				Vector3.transformCoordinate(meshBoudingBox.min, worldMat, _boundingBox.min);
				Vector3.transformCoordinate(meshBoudingBox.max, worldMat, _boundingBox.max);
			}
		}
		
		/**
		 * @private
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		override public function dispose():void {
			_meshSprite3DOwner.meshFilter.off(Event.MESH_CHANGED, this, _onMeshChanged);
		}
	
	}

}
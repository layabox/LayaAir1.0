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
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:RenderableSprite3D) {
			super(owner);
			(owner as MeshSprite3D).meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(meshFilter:MeshFilter,oldMesh:BaseMesh, mesh:BaseMesh):void {
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
			var sharedMesh:BaseMesh = (_owner as MeshSprite3D).meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingSphere == null) {
				_boundingSphere.toDefault();
			} else {
				var meshBoundingSphere:BoundSphere = sharedMesh.boundingSphere;
				var maxScale:Number;
				var transform:Transform3D = _owner.transform;
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
			var sharedMesh:BaseMesh = (_owner as MeshSprite3D).meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingBox == null) {
				_boundingBox.toDefault();
			} else {
				var worldMat:Matrix4x4 = (_owner as MeshSprite3D).transform.worldMatrix;
				var corners:Array = sharedMesh.boundingBoxCorners;
				for (var i:int = 0; i < 8; i++)
					Vector3.transformCoordinate(corners[i], worldMat, _tempBoundBoxCorners[i]);
				BoundBox.createfromPoints(_tempBoundBoxCorners, _boundingBox);
			}
		}
		
		/**
		 * @private
		 */
		override public function _renderUpdate(projectionView:Matrix4x4):void {
			var transform:Transform3D = _owner.transform;
			if (transform) {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
				var projViewWorld:Matrix4x4 = _owner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
			} else {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, Matrix4x4.DEFAULT);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projectionView);
			}
		}
	}

}
package laya.d3.core {
	import laya.d3.core.render.BaseRender;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.events.Event;
	
	/**
	 * <code>MeshRender</code> 类用于网格渲染器。
	 */
	public class MeshRender extends BaseRender {
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function MeshRender(owner:RenderableSprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(owner);
			(owner as MeshSprite3D).meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(meshFilter:MeshFilter, oldMesh:BaseMesh, mesh:BaseMesh):void {
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
		 * @private
		 */
		protected function _calculateBoundingSphereByInitSphere(boundSphere:BoundSphere):void {
			var maxScale:Number;
			var transform:Transform3D = _owner.transform;
			var scaleE:Float32Array = transform.scale.elements;
			var scaleX:Number = Math.abs(scaleE[0]);
			var scaleY:Number = Math.abs(scaleE[1]);
			var scaleZ:Number = Math.abs(scaleE[2]);
			
			if (scaleX >= scaleY && scaleX >= scaleZ)
				maxScale = scaleX;
			else
				maxScale = scaleY >= scaleZ ? scaleY : scaleZ;
			Vector3.transformCoordinate(boundSphere.center, transform.worldMatrix, _boundingSphere.center);
			_boundingSphere.radius = boundSphere.radius * maxScale;
		}
		
		/**
		 * @private
		 */
		protected function _calculateBoundBoxByInitCorners(corners:Vector.<Vector3>):void {
			var worldMat:Matrix4x4 = (_owner as MeshSprite3D).transform.worldMatrix;
			for (var i:int = 0; i < 8; i++)
				Vector3.transformCoordinate(corners[i], worldMat, _tempBoundBoxCorners[i]);
			BoundBox.createfromPoints(_tempBoundBoxCorners, _boundingBox);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			var sharedMesh:BaseMesh = (_owner as MeshSprite3D).meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingSphere == null)
				_boundingSphere.toDefault();
			else
				_calculateBoundingSphereByInitSphere(sharedMesh.boundingSphere);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {
			var sharedMesh:BaseMesh = (_owner as MeshSprite3D).meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingBox == null)
				_boundingBox.toDefault();
			else
				_calculateBoundBoxByInitCorners(sharedMesh.boundingBoxCorners);
		}
		
		/**
		 * @private
		 */
		override public function _renderUpdate(projectionView:Matrix4x4):Boolean {
			var transform:Transform3D = _owner.transform;
			if (transform) {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
				var projViewWorld:Matrix4x4 = _owner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
			} else {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, Matrix4x4.DEFAULT);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projectionView);
			}
			
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
			return true;
		}
	}

}
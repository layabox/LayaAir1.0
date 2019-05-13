package D3UI {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;

	public class UISprite3DRenderer extends BaseRender {
		public var boundsph:BoundSphere = new BoundSphere(new Vector3(), 1.0);
		protected var _projectionViewWorldMatrix:Matrix4x4;
		public function UISprite3DRenderer(owner:UISprite3D) {
			_owner = owner;
			super(owner, 4);
			_projectionViewWorldMatrix = new Matrix4x4();
		}
		
		private function _onMeshLoaed():void {
			_boundingSphereNeedChange = true;
			_boundingBoxNeedChange = true;
			_boundingBoxCenterNeedChange = true;
			_octreeNodeNeedChange = true;
		}
		
		/**
		 * @private
		 */
		//计算包围盒根据原始包围盒
		protected function _calculateBoundBoxByInitCorners(corners:Vector.<Vector3>):void {
			var worldMat:Matrix4x4 = (_owner as MeshSprite3D).transform.worldMatrix;
			for (var i:int = 0; i < 8; i++)
				BoundBox.createfromPoints(_tempBoundBoxCorners, _boundingBox);
			Vector3.transformCoordinate(corners[i], worldMat, _tempBoundBoxCorners[i]);
		}
		
		/**
		 * @inheritDoc
		 */
		//计算球包围盒
		override protected function _calculateBoundingSphere():void {
			var boundSphere:BoundSphere = (_owner as UISprite3D)._bsphere;
			var maxScale:Number;
			var transform:Transform3D = _owner.transform;
			var scaleE:Float32Array = transform.scale.elements;
			var scaleX:Number = scaleE[0];
			scaleX || (scaleX = -scaleX);
			var scaleY:Number = scaleE[1];
			scaleY || (scaleY = -scaleY);
			var scaleZ:Number = scaleE[2];
			scaleZ || (scaleZ = -scaleZ);
			
			if (scaleX >= scaleY && scaleX >= scaleZ)
				maxScale = scaleX;
			else
				maxScale = scaleY >= scaleZ ? scaleY : scaleZ;
			Vector3.transformCoordinate(boundSphere.center, transform.worldMatrix, _boundingSphere.center);
			_boundingSphere.radius = boundSphere.radius * maxScale;
		}
		
		/**
		 * @inheritDoc
		 */
		//计算Box包围盒
		override protected function _calculateBoundingBox():void {
			var sharedMesh:Mesh = (_owner as MeshSprite3D).meshFilter.sharedMesh;
			if (sharedMesh == null || sharedMesh.boundingBox == null)
				_boundingBox.toDefault();
			else
				_calculateBoundBoxByInitCorners(sharedMesh.boundingBoxCorners);
		}
		
		/**
		 * @inheritDoc
		 */
		//判断是否需要渲染
		override public function _needRender(boundFrustum:BoundFrustum):Boolean {
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		//更新模型位置
		override public function _renderUpdate(context:RenderContext3D, transform:Transform3D):void {
			/*
			if (transform)
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
			else
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, Matrix4x4.DEFAULT);
			*/
		}
		
		/**
		 * @inheritDoc
		 */
		//更新模型照相机位置
		override public function _renderUpdateWithCamera(context:RenderContext3D, transform:Transform3D):void {
			var projectionView:Matrix4x4 = context.projectionViewMatrix;
			if (transform) {
				Matrix4x4.multiply(projectionView, transform.worldMatrix, _projectionViewWorldMatrix);
				//_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, _projectionViewWorldMatrix);
				_owner._matWVP = _projectionViewWorldMatrix;
			} else {
				//_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, projectionView);
				_owner._matWVP = projectionView;
			}
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
		}
		
		/**
		 * @inheritDoc
		 */
		//删除
		override public function _destroy():void {
		
		}

	}
}
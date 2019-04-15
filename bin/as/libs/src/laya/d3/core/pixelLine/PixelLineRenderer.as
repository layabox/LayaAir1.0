package laya.d3.core.pixelLine {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderData;
	
	/**
	 * <code>PixelLineRenderer</code> 类用于线渲染器。
	 */
	public class PixelLineRenderer extends BaseRender {
		
		/** @private */
		protected var _projectionViewWorldMatrix:Matrix4x4;
		
		public function PixelLineRenderer(owner:PixelLineSprite3D) {
			super(owner);
			_projectionViewWorldMatrix = new Matrix4x4();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {
			var min:Vector3 = _boundingBox.min;
			min.x = -Number.MAX_VALUE;
			min.y = -Number.MAX_VALUE;
			min.z = -Number.MAX_VALUE;
			var max:Vector3 = _boundingBox.max;
			max.x = Number.MAX_VALUE;
			max.y = Number.MAX_VALUE;
			max.z = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			var center:Vector3 = _boundingSphere.center;
			center.x = 0;
			center.y = 0;
			center.z = 0;
			_boundingSphere.radius = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdateWithCamera(context:RenderContext3D, transform:Transform3D):void {//TODO:整理_renderUpdate
			var projectionView:Matrix4x4 = context.projectionViewMatrix;
			var sv:ShaderData = _shaderValues;
			if (transform) {
				var worldMat:Matrix4x4 = transform.worldMatrix;
				sv.setMatrix4x4(Sprite3D.WORLDMATRIX, worldMat);
				Matrix4x4.multiply(projectionView, worldMat, _projectionViewWorldMatrix);
				sv.setMatrix4x4(Sprite3D.MVPMATRIX, _projectionViewWorldMatrix);
			} else {
				sv.setMatrix4x4(Sprite3D.WORLDMATRIX, Matrix4x4.DEFAULT);
				sv.setMatrix4x4(Sprite3D.MVPMATRIX, projectionView);
			}
		}
		
	}

}
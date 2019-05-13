package laya.d3Extend.lineRender {
	
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.shader.ShaderData;
	
	/**
	 * ...
	 * @author
	 */
	public class LineRenderer extends BaseRender {
		/** @private */
		protected var _projectionViewWorldMatrix:Matrix4x4;
		
		public function LineRenderer(owner:LineSprite3D) {
			super(owner,RenderableSprite3D.shaderUniforms.count);
			_projectionViewWorldMatrix = new Matrix4x4();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {
			var minE:Float32Array = _boundingBox.min.elements;
			minE[0] = -Number.MAX_VALUE;
			minE[1] = -Number.MAX_VALUE;
			minE[2] = -Number.MAX_VALUE;
			var maxE:Float32Array = _boundingBox.min.elements;
			maxE[0] = Number.MAX_VALUE;
			maxE[1] = Number.MAX_VALUE;
			maxE[2] = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			var centerE:Float32Array = _boundingSphere.center.elements;
			centerE[0] = 0;
			centerE[1] = 0;
			centerE[2] = 0;
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
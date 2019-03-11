package laya.d3.core.trail {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * <code>TrailRenderer</code> 类用于创建拖尾渲染器。
	 */
	public class TrailRenderer extends BaseRender {
		public function TrailRenderer(owner:TrailSprite3D) {
			super(owner);
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
			_owner.transform.position.cloneTo(_boundingSphere.center);
			_boundingSphere.radius = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _needRender(boundFrustum:BoundFrustum):Boolean {
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(state:RenderContext3D, transform:Transform3D):void {
			super._renderUpdate(state,transform);
			(_owner as TrailSprite3D).trailFilter._update(state);
		}
		protected var _projectionViewWorldMatrix:Matrix4x4 = new Matrix4x4();
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdateWithCamera(context:RenderContext3D, transform:Transform3D):void {
			var projectionView:Matrix4x4 = context.projectionViewMatrix;
			if (transform) {
				Matrix4x4.multiply(projectionView, transform.worldMatrix, _projectionViewWorldMatrix);
				_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, _projectionViewWorldMatrix);
			} else {
				_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, projectionView);
			}
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
		}
	}
}
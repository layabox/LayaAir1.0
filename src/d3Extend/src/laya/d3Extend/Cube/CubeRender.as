package Cube {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * <code>CubeRender</code> 类用于实现方块渲染器。
	 */
	public class CubeRender extends BaseRender {
		/**@private */
		private var _projectionViewWorldMatrix:Matrix4x4;
		
		/**
		 * 创建一个 <code>CubeRender</code> 实例。
		 */
		public function CubeRender(owner:RenderableSprite3D) {
			super(owner, 4);
			_projectionViewWorldMatrix = new Matrix4x4();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			_boundingSphere.radius = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(context:RenderContext3D, transform:Transform3D):void {
			if (transform)
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
			else
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, Matrix4x4.DEFAULT);
		}
		
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _destroy():void {
		
		}
	
	}

}
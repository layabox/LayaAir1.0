package laya.d3.core.trail {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.renders.Render;
	
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
			var min:Vector3 = _boundingBox.min;
			min.x = -Number.MAX_VALUE;
			min.y = -Number.MAX_VALUE;
			min.z = -Number.MAX_VALUE;
			var max:Vector3 = _boundingBox.min;
			max.x = Number.MAX_VALUE;
			max.y = Number.MAX_VALUE;
			max.z = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			_owner.transform.position.cloneTo(_boundingSphere.center);
			_boundingSphere.radius = Number.MAX_VALUE;
			if (Render.isConchApp) {//[NATIVE]
				var center:Vector3=_boundingSphere.center;
				var buffer:Float32Array = FrustumCulling._cullingBuffer;
				buffer[_cullingBufferIndex + 1] = center.x;
				buffer[_cullingBufferIndex + 2] = center.y;
				buffer[_cullingBufferIndex + 3] = center.z;
				buffer[_cullingBufferIndex + 4] =_boundingSphere.radius;
			}
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
			super._renderUpdate(state, transform);
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
		}
	}
}
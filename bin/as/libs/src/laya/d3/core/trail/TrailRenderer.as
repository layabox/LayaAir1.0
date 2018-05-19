package laya.d3.core.trail {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrailRenderer extends BaseRender {
		
		public function TrailRenderer(owner:TrailSprite3D) {
			super(owner);
		}
		
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
		
		override protected function _calculateBoundingSphere():void {
			var centerE:Float32Array = _boundingSphere.center.elements;
			centerE[0] = 0;
			centerE[1] = 0;
			centerE[2] = 0;
			_boundingSphere.radius = Number.MAX_VALUE;
		}
		
		override public function _renderUpdate(projectionView:Matrix4x4):Boolean {
			return true;
		}
		
	}
}
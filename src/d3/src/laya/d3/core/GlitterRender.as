package laya.d3.core {
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.render.BaseRender;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GlitterRender extends BaseRender{
		
		public function GlitterRender(owner:Glitter) {
			super(owner);
		}
		
		override protected function _calculateBoundingBox():void {//TODO:更具粒子参数计算
			var minE:Float32Array = _boundingBox.min.elements;
			minE[0] = -Number.MAX_VALUE;
			minE[1] = -Number.MAX_VALUE;
			minE[2] = -Number.MAX_VALUE;
			var maxE:Float32Array = _boundingBox.min.elements;
			maxE[0] = Number.MAX_VALUE;
			maxE[1] = Number.MAX_VALUE;
			maxE[2] = Number.MAX_VALUE;
		}
		
		override protected function _calculateBoundingSphere():void {//TODO:更具粒子参数计算
			var centerE:Float32Array = _boundingSphere.center.elements;
			centerE[0] = 0;
			centerE[1] = 0;
			centerE[2] = 0;
			_boundingSphere.radius = Number.MAX_VALUE;
		}
	
	}

}
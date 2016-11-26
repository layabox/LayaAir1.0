package laya.d3.core.particleShuriKen {
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.shader.ShaderDefines3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShurikenParticleRender extends BaseRender {
		/**渲染模式。*/
		public var renderMode:int;
		/**拉伸广告牌模式摄像机速度缩放,暂不支持*/
		public var stretchedBillboardCameraSpeedScale:int = 0;
		/**拉伸广告牌模式速度缩放*/
		public var stretchedBillboardSpeedScale:int = 0;
		/**拉伸广告牌模式长度缩放*/
		public var stretchedBillboardLengthScale:int = 1;

		public function ShurikenParticleRender(owner:ShuriKenParticle3D) {
			super(owner);
			renderMode = 0;
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
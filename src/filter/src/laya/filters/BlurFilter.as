package laya.filters {
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.utils.RunDriver;
	
	/**
	 * 模糊滤镜
	 */
	public class BlurFilter extends Filter {
		
		/**模糊滤镜的强度(值越大，越不清晰 */
		public var strength:Number;
		public var strength_sig2_2sig2_gauss1:Array = [];//给shader用的。避免创建对象
		public var strength_sig2_native:Float32Array;//给native用的
		public var renderFunc:*;//
		/**
		 * 模糊滤镜
		 * @param	strength	模糊滤镜的强度值
		 */
		public function BlurFilter(strength:Number = 4) {
			this.strength = strength;
			_action = null;
			_glRender = new BlurFilterGLRender();
		}
		
		/**
		 * @private
		 * 当前滤镜的类型
		 */
		override public function get type():int {
			return BLUR;
		}
		
		public function getStrenth_sig2_2sig2_native():Float32Array
		{
			if (!strength_sig2_native)
			{
				strength_sig2_native = new Float32Array(4);
			}
			//TODO James 不要每次进行计算
			var sigma:Number = strength/3.0;
			var sigma2:Number = sigma * sigma;
			strength_sig2_native[0] = strength;
			strength_sig2_native[1] = sigma2;
			strength_sig2_native[2] = 2.0*sigma2;
			strength_sig2_native[3] = 1.0 / (2.0 * Math.PI * sigma2);
			return strength_sig2_native;
		}
	}
}
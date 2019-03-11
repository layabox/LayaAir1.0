package laya.filters {
	import laya.maths.Matrix;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	/**
	 * @private
	 */
	public class BlurFilterGLRender {
		private static var blurinfo:Array = new Array(2);
		public function render(rt:RenderTexture2D, ctx:WebGLContext2D,width:int,height:int, filter:BlurFilter):void {
			var shaderValue:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			setShaderInfo(shaderValue,filter,rt.width,rt.height);
			ctx.drawTarget(rt, 0, 0, width, height, Matrix.EMPTY.identity(), shaderValue);
		}

		public function setShaderInfo(shader:Value2D,filter:BlurFilter,w:int,h:int):void {
			shader.defines.add(Filter.BLUR);
			var sv:Object = shader as Object;
			blurinfo[0] = w; blurinfo[1] = h;
			sv.blurInfo = blurinfo;
			var sigma:Number = filter.strength/3.0;//3σ以外影响很小。即当σ=1的时候，半径为3;
			var sigma2:Number = sigma*sigma;
			filter.strength_sig2_2sig2_gauss1[0] = filter.strength;
			filter.strength_sig2_2sig2_gauss1[1] = sigma2;			//做一些预计算传给shader，提高效率
			filter.strength_sig2_2sig2_gauss1[2] = 2.0*sigma2;
			filter.strength_sig2_2sig2_gauss1[3] = 1.0/(2.0*Math.PI*sigma2);
			sv.strength_sig2_2sig2_gauss1 = filter.strength_sig2_2sig2_gauss1;
		}
	}
}
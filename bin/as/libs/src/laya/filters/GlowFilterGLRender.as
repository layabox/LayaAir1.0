package laya.filters{
	import laya.maths.Matrix;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	/**
	 * @private
	 */
	public class GlowFilterGLRender {
		
		private function setShaderInfo(shader:Value2D, w:int, h:int, data:GlowFilter):void {
			shader.defines.add(data.type);
			var sv:Object = shader as Object;
			sv.u_blurInfo1 = data._sv_blurInfo1;// [data.blur, data.blur, data.offX, -data.offY];
			var info2:* = data._sv_blurInfo2;
			info2[0] = w; info2[1] = h; 
			sv.u_blurInfo2 = info2;
			sv.u_color = data.getColor();
		}
		public function render(rt:RenderTexture2D, ctx:WebGLContext2D,width:int,height:int, filter:GlowFilter):void {
			var w:int = width, h:int = height;
			var svBlur:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			setShaderInfo(svBlur,w,h,filter);
			var svCP:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			var matI:Matrix = Matrix.TEMP.identity();
			ctx.drawTarget(rt, 0, 0, w, h, matI, svBlur);	//先画模糊的底
			ctx.drawTarget(rt, 0, 0, w, h, matI, svCP);		//再画原始图片
			
		}
	}
}
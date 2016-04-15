package laya.webgl.shader.d2.value
{
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.CONST3D2D;
	
	public class PrimitiveSV extends Value2D
	{	
		public var a_color:Array;

		public function PrimitiveSV()
		{
			super(ShaderDefines2D.PRIMITIVE,0);
			this.position=[2, WebGLContext.FLOAT, false, 5 * CONST3D2D.BYTES_PE, 0];
			this.a_color=[3, WebGLContext.FLOAT, false, 5 * CONST3D2D.BYTES_PE, 2*4];
//			this.alpha=1;
		}
	}
}
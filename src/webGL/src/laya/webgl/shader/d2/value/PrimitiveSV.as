package laya.webgl.shader.d2.value{
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.CONST3D2D;
	
	public class PrimitiveSV extends Value2D{	
		public function PrimitiveSV(args:*){
			super(ShaderDefines2D.PRIMITIVE,0);
			this._attribLocation = ['position', 0, 'attribColor', 1];// , 'clipDir', 2, 'clipRect', 3];
		}
	}
}
package laya.ani.bone.shader 
{

	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author wk
	 */
	public class aniShaderValue extends Value2D
	{
		public var texcoord:*;
		
		public function aniShaderValue( ) 
		{
			super(0,0);
			var _vlen : int = 8 * CONST3D2D.BYTES_PE;
			this.position = [2, WebGLContext.FLOAT, false, _vlen, 0];
			this.texcoord = [2, WebGLContext.FLOAT, false, _vlen,  2 * CONST3D2D.BYTES_PE];
			this.color = [4, WebGLContext.FLOAT, false, _vlen,  4 * CONST3D2D.BYTES_PE];
		}
		
		//override public function refresh():void 
		//{
			//super.refresh();
			//
		//}
		
	}

}
package laya.webgl.shader.d2.fillTexture 
{

	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FillTextureShaderValue extends Value2D
	{
		public var texcoord:*;
		public var u_texRange:Array = [0, 1, 0, 1];
		public var u_offset:Array = [0.5, 0.5];
		
		private static var _fillTextureShaderValue:FillTextureShaderValue;
		
		public function FillTextureShaderValue( ) 
		{
			super(0,0);
			var _vlen : int = 8 * CONST3D2D.BYTES_PE;
			this.position = [2, WebGLContext.FLOAT, false, _vlen, 0];
			this.texcoord = [2, WebGLContext.FLOAT, false, _vlen,  2 * CONST3D2D.BYTES_PE];
			this.color = [4, WebGLContext.FLOAT, false, _vlen,  4 * CONST3D2D.BYTES_PE];
		}
		
		public static function instance():FillTextureShaderValue
		{
			return _fillTextureShaderValue ||= new FillTextureShaderValue();
		}
		
	}

}
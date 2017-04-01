package laya.webgl.shader.d2.value {
	
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.CONST3D2D;
	public class FillTextureSV extends Value2D {
		/*public var u_texRange:Array = [0, 1, 0, 1];
		public var u_offset:Array = [0.5, 0.5];	*/
		public var texcoord:Array = _TEXCOORD;
		public var u_colorMatrix:Array;
		public var strength : Number = 0;
		public var colorMat : Array = null;
		public var colorAlpha : Array = null;
		public var u_TexRange:Array = [0, 1, 0, 1];
		public var u_offset:Array = [0,0];
		
		public function FillTextureSV(type:*) {
			super(ShaderDefines2D.FILLTEXTURE,0);
			//var _vlen:int = 8 * CONST3D2D.BYTES_PE;
			//this.position = [2, WebGLContext.FLOAT, false, _vlen, 0];
			//this.color = [4, WebGLContext.FLOAT, false, _vlen, 4 * CONST3D2D.BYTES_PE];
		}
		
	    override public function setValue(vo:Shader2D):void
		{
			ALPHA = vo.ALPHA;
			//texture =vo.glTexture?vo.glTexture.source:null;
			vo.filters && setFilters(vo.filters);
		}
		
		
		override public function clear():void
		{
			texture = null;
			shader = null;
			defines.setValue(0);
		}
		
	}

}
package laya.webgl.shader.d2.value
{
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	
	public class TextureSV extends Value2D
	{
		public var texcoord:Array = _TEXCOORD;
		public var u_colorMatrix:Array;
		public var strength : Number = 0;
		public var colorMat : Array = null;
		public var colorAlpha : Array = null;
		
		public function TextureSV(subID:int=0)
		{
			super(ShaderDefines2D.TEXTURE2D,subID);
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
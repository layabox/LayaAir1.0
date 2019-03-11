package laya.webgl.shader.d2.value
{
	import laya.webgl.WebGL;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	
	public class TextureSV extends Value2D
	{
		public var u_colorMatrix:Array;
		public var strength : Number = 0;
		public var blurInfo:Array = null;
		public var colorMat : Float32Array = null;
		public var colorAlpha : Float32Array = null;
		public function TextureSV(subID:int=0)
		{
			super(ShaderDefines2D.TEXTURE2D, subID);
			this._attribLocation = ['posuv', 0, 'attribColor', 1, 'attribFlags', 2];// , 'clipDir', 3, 'clipRect', 4];
		}
		
		override public function clear():void
		{
			texture = null;
			shader = null;
			defines._value=subID + (WebGL.shaderHighPrecision?ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION:0);
			//defines.setValue(0);
		}
	}
}
package laya.webgl.shader.d2.value
{
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	
	public class Color2dSV extends Value2D
	{
		public function Color2dSV(args:*)
		{
			super(ShaderDefines2D.COLOR2D, 0);
			color = [];
		}
		
		override public function setValue(value:Shader2D):void
		{
			value.fillStyle&&(color = value.fillStyle._color._color);
			value.strokeStyle&&(color = value.strokeStyle._color._color);
		}
	}
}
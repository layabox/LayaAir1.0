package laya.webgl.shader.d2.value
{
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;

	public class GlowSV extends TextureSV
	{
		
		public var u_blurX:Boolean;
		public var u_color:Array;
		public var u_offset:Array;
		public var u_strength:Number;
		public var u_texW:int;
		public var u_texH:int;
		public function GlowSV(args:*)
		{
			super( ShaderDefines2D.FILTERGLOW|ShaderDefines2D.TEXTURE2D);
		}
		
		override public function setValue(vo:Shader2D):void
		{
			//colorAdd = vo.colorAdd;
			super.setValue(vo);
		}
		
		override public function clear():void
		{
			//colorAdd=null;
			super.clear();
		}
	}
}
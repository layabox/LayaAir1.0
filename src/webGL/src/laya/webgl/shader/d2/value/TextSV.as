package laya.webgl.shader.d2.value
{
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;

	public class TextSV extends TextureSV
	{
		public static var pool:Array = [];
		private static var _length:int=0;
		public function TextSV(args:*)
		{
			super(ShaderDefines2D.COLORADD);
			this.defines.add(ShaderDefines2D.COLORADD);
		}
		
		override public function release():void
		{
			pool[_length++]=this;
			this.clear();
		}
		
		override public function clear():void
		{
//			colorAdd=null;
			super.clear();
		}
		
		public static function create():TextSV
		{
			if (_length) return pool[--_length];
			else return new TextSV(null);
		}
	}
	
}
package laya.webgl.shader.d2.skinAnishader 
{
	import laya.webgl.shader.Shader;
	/**
	 * ...
	 * @author ...
	 */
	public class SkinAniShader extends Shader
	{
		
		private static var _instance:SkinAniShader;
		
		public function SkinAniShader() 
		{
			var vs:String = __INCLUDESTR__("aniShader.vs");
			var ps:String = __INCLUDESTR__("aniShader.ps");
			super(vs, ps, "SpineShader");
		}
		
		public static function getInstance():SkinAniShader
		{
			return _instance ||= new SkinAniShader();
		}
	}

}
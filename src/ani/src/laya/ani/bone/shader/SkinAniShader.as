package laya.ani.bone.shader 
{
	import laya.webgl.shader.Shader;
	/**
	 * ...
	 * @author ...
	 */
	public class SkinAniShader extends Shader
	{
		
		public static var shader:SkinAniShader = new SkinAniShader();
		
		public function SkinAniShader() 
		{
			var vs:String = __INCLUDESTR__("aniShader.vs");
			var ps:String = __INCLUDESTR__("aniShader.ps");
			super(vs, ps, "SpineShader");
		}
		
	}

}
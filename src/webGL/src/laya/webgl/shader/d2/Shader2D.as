package laya.webgl.shader.d2 {
	import laya.resource.Bitmap;
	import laya.webgl.canvas.DrawStyle;
	import laya.webgl.shader.Shader;
	
	public class Shader2D {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public var ALPHA:Number = 1;
		public var glTexture:Bitmap;
		public var shader:Shader;
		public var filters:Array;
		public var defines:ShaderDefines2D = new ShaderDefines2D();
		public var shaderType:int = 0;
		public var colorAdd:Array;
		public var strokeStyle:DrawStyle;
		public var fillStyle:DrawStyle;
		
		public function destroy():void {
			defines = null;
			filters = null;
			glTexture = null;
			strokeStyle = null;
			fillStyle = null;
		}
		
		public static function __init__():void {
			Shader.addInclude("parts/ColorFilter_ps_uniform.glsl", __INCLUDESTR__("files/parts/ColorFilter_ps_uniform.glsl"));
			Shader.addInclude("parts/ColorFilter_ps_logic.glsl", __INCLUDESTR__("files/parts/ColorFilter_ps_logic.glsl"));
			
			Shader.addInclude("parts/GlowFilter_ps_uniform.glsl", __INCLUDESTR__("files/parts/GlowFilter_ps_uniform.glsl"));
			Shader.addInclude("parts/GlowFilter_ps_logic.glsl", __INCLUDESTR__("files/parts/GlowFilter_ps_logic.glsl"));
			
			Shader.addInclude("parts/BlurFilter_ps_logic.glsl", __INCLUDESTR__("files/parts/BlurFilter_ps_logic.glsl"));
			Shader.addInclude("parts/BlurFilter_ps_uniform.glsl", __INCLUDESTR__("files/parts/BlurFilter_ps_uniform.glsl"));
			
			Shader.addInclude("parts/ColorAdd_ps_uniform.glsl", __INCLUDESTR__("files/parts/ColorAdd_ps_uniform.glsl"));
			Shader.addInclude("parts/ColorAdd_ps_logic.glsl", __INCLUDESTR__("files/parts/ColorAdd_ps_logic.glsl"));
			
			var vs:String, ps:String;
			
			vs = __INCLUDESTR__("files/texture.vs");
			ps = __INCLUDESTR__("files/texture.ps");
			Shader.preCompile2D(0, ShaderDefines2D.TEXTURE2D, vs, ps, null);
			
			vs = __INCLUDESTR__("files/line.vs");
			ps = __INCLUDESTR__("files/line.ps");
			Shader.preCompile2D(0, ShaderDefines2D.COLOR2D, vs, ps, null);
			
			vs = __INCLUDESTR__("files/primitive.vs");
			ps = __INCLUDESTR__("files/primitive.ps");
			Shader.preCompile2D(0, ShaderDefines2D.PRIMITIVE, vs, ps, null);
			
			vs = __INCLUDESTR__("files/texture.vs");
			ps = __INCLUDESTR__("files/fillTextureShader.ps");
			Shader.preCompile2D(0, ShaderDefines2D.FILLTEXTURE, vs, ps, null);
			
			vs = __INCLUDESTR__("skinAnishader/skinShader.vs");
			ps = __INCLUDESTR__("skinAnishader/skinShader.ps");
			Shader.preCompile2D(0, ShaderDefines2D.SKINMESH, vs, ps, null);
		}
	}
}
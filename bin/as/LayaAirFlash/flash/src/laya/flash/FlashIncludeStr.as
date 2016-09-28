/*[IF-FLASH]*/package laya.flash {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashIncludeStr 
	{
[Embed(source="../../files/line.ps", mimeType="application/octet-stream")]		
public static var line_ps:Class;		
[Embed(source="../../files/line.vs", mimeType="application/octet-stream")]
public static var line_vs:Class;		
[Embed(source="../../files/primitive.ps", mimeType="application/octet-stream")]
public static var primitive_ps:Class;		
[Embed(source="../../files/primitive.vs", mimeType="application/octet-stream")]
public static var primitive_vs:Class;		
[Embed(source="../../files/texture.ps", mimeType="application/octet-stream")]
public static var texture_ps:Class;		
[Embed(source="../../files/texture.vs", mimeType="application/octet-stream")]
public static var texture_vs:Class;		

[Embed(source="../../files/parts/BlurFilter_ps_logic.glsl", mimeType="application/octet-stream")]
public static var BlurFilter_ps_logic:Class;		
[Embed(source = "../../files/parts/BlurFilter_ps_uniform.glsl", mimeType = "application/octet-stream")]
public static var BlurFilter_ps_uniform:Class;		
[Embed(source = "../../files/parts/BlurFilter_vs_logic.glsl", mimeType = "application/octet-stream")]
public static var BlurFilter_vs_logic:Class;		
[Embed(source = "../../files/parts/BlurFilter_vs_uniform.glsl", mimeType = "application/octet-stream")]
public static var BlurFilter_vs_uniform:Class;
[Embed(source = "../../files/parts/ColorAdd_ps_logic.glsl", mimeType = "application/octet-stream")]
public static var ColorAdd_ps_logic:Class;
[Embed(source = "../../files/parts/ColorAdd_ps_uniform.glsl", mimeType = "application/octet-stream")]
public static var ColorAdd_ps_uniform:Class;
[Embed(source = "../../files/parts/ColorFilter_ps_logic_flash.glsl", mimeType = "application/octet-stream")]
public static var ColorFilter_ps_logic:Class;
[Embed(source = "../../files/parts/ColorFilter_ps_uniform.glsl", mimeType = "application/octet-stream")]
public static var ColorFilter_ps_uniform:Class;
[Embed(source = "../../files/parts/GlowFilter_ps_logic.glsl", mimeType = "application/octet-stream")]
public static var GlowFilter_ps_logic:Class;
[Embed(source = "../../files/parts/GlowFilter_ps_uniform.glsl", mimeType = "application/octet-stream")]
public static var GlowFilter_ps_uniform:Class;


[Embed(source = "../../files/fillTexture/fillTextureShader.ps", mimeType = "application/octet-stream")]
public static var FillTextureShader_ps:Class;
[Embed(source = "../../files/fillTexture/fillTextureShader.vs", mimeType = "application/octet-stream")]
public static var FillTextureShader_vs:Class;

[Embed(source = "../../files/skinAnishader/aniShader.ps", mimeType = "application/octet-stream")]
public static var SkinAniShader_ps:Class;
[Embed(source = "../../files/skinAnishader/aniShader.vs", mimeType = "application/octet-stream")]
public static var SkinAniShader_vs:Class;


		public static function add(path:String, _class:*):void
		{
			var byteDataTxt:ByteArray = new _class();
			includeStr[path] = byteDataTxt.readUTFBytes(byteDataTxt.bytesAvailable);
			trace("add include:" + path);
		}
		
		public static function __init__():void 
		{
			add("files/line.ps", line_ps);
			add("files/line.vs", line_vs);
			add("files/primitive.ps", primitive_ps);
			add("files/primitive.vs", primitive_vs);
			add("files/texture.ps", texture_ps);
			add("files/texture.vs", texture_vs);
			add("files/parts/BlurFilter_ps_logic.glsl", BlurFilter_ps_logic);
			add("files/parts/BlurFilter_ps_uniform.glsl", BlurFilter_ps_uniform);
			add("files/parts/BlurFilter_vs_logic.glsl", BlurFilter_vs_logic);
			add("files/parts/BlurFilter_vs_uniform.glsl", BlurFilter_vs_uniform);
			add("files/parts/ColorAdd_ps_logic.glsl", ColorAdd_ps_logic);
			add("files/parts/ColorAdd_ps_uniform.glsl", ColorAdd_ps_uniform);
			add("files/parts/ColorFilter_ps_logic.glsl", ColorFilter_ps_logic);
			add("files/parts/ColorFilter_ps_uniform.glsl", ColorFilter_ps_uniform);
			add("files/parts/GlowFilter_ps_logic.glsl", GlowFilter_ps_logic);
			add("files/parts/GlowFilter_ps_uniform.glsl", GlowFilter_ps_uniform);
			
			add("fillTextureShader.ps", FillTextureShader_ps);
			add("fillTextureShader.vs", FillTextureShader_vs);
			add("aniShader.ps", SkinAniShader_ps);
			add("aniShader.vs", SkinAniShader_vs);
		}
		
		public static var   includeStr:Dictionary = new Dictionary();
		
		/**
		 * 在项目窗口启动之前，把项目自己的shader文件加入到系统Shader列表中。
		 * @param	path
		 * @param	byteDT
		 */
		public static function addExtraShader( path : String, byteDT : ByteArray ) : void {
			includeStr[path] = byteDT.readUTFBytes( byteDT.bytesAvailable );
		}
	}

}
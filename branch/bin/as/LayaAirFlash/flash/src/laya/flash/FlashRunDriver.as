/*[IF-FLASH]*/package laya.flash 
{
	import flash.utils.getTimer;
	import laya.filters.Filter;
	import laya.filters.webgl.BlurFilterActionGL;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.filters.webgl.GlowFilterActionGL;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.atlas.AtlasWebGLCanvas;
	import laya.filters.ColorFilterAction;
	import laya.filters.IFilterAction;

	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashRunDriver 
	{
		
		public static function now():Number
		{
			return getTimer();
		}
		
		public static function getWindow():*
		{
			return new Window();
		}
		
		public static function newWebGLContext(canvas:*,webGLName:String):*
		{
			return new FlashWebGLContext();
		}
		
		public static function getPixelRatio(pixelRatio:Number=1):Number {
			return 1;
		}
		
		public static function getIncludeStr(name:String):String
		{
			if (!FlashIncludeStr.includeStr[name]) 
			{
				trace("getIncludeStr null:" + name);
			}
			return FlashIncludeStr.includeStr[name];
		}
		
		public static function createShaderCondition(conditionScript:String):Function
		{
			return (new FlashCondition(conditionScript)).condition;
		}
		
		public static function measureText(txt:String, font:String):* {
			return FlashContext.__measureText(txt, font);
		}
		
		public static function flashFlushImage(atlasWebGLCanvas:AtlasWebGLCanvas):void {
			var gl:WebGLContext = WebGL.mainContext;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, atlasWebGLCanvas.source);
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, atlasWebGLCanvas._flashCacheImage.image);
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			atlasWebGLCanvas._flashCacheImageNeedFlush = false;
		}
		
		/**
		 * 用于创建滤镜动作。
		 */
		public static var createFilterAction:Function =/*[STATIC SAFE]*/ function(type:int):IFilterAction {
			//return new ColorFilterAction();
			//return new ColorFilterActionGL();
			var action:IFilterAction;
			switch (type)
			{
			case Filter.COLOR: 
				action = new ColorFilterActionGL();
				break;
			case Filter.BLUR: 
				action = new BlurFilterActionGL();
				break;
			case Filter.GLOW: 
				action = new GlowFilterActionGL();
				break;
			}
			return action;			
		}
		
	}

}
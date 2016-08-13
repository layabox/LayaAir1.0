/*[IF-FLASH]*/package laya.flash 
{
	import com.adobe.glsl2agal.CModule;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import laya.media.flashaudio.FlashSound;
	import laya.media.SoundManager;
	import laya.utils.ClassUtils;
	import laya.utils.RunDriver;
	import laya.utils.Utils;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	import laya.webgl.WebGL;
	/**
	 * ...
	 * @author laya
	 */
	public class FlashInit 
	{		
		public static function __init__(stage:Stage):void
		{
			WebGL.enable();
			CModule.startAsync();
			//FlashWebGLContext.context3D.enableErrorChecking = true;
			RunDriver.getIncludeStr = FlashRunDriver.getIncludeStr;
			RunDriver.getPixelRatio = FlashRunDriver.getPixelRatio;
			RunDriver.getWindow = FlashRunDriver.getWindow;
			RunDriver.newWebGLContext = FlashRunDriver.newWebGLContext;
			RunDriver.createShaderCondition = FlashRunDriver.createShaderCondition;			
			RunDriver.now = FlashRunDriver.now;
			RunDriver.measureText = FlashRunDriver.measureText;
			RunDriver.flashFlushImage = FlashRunDriver.flashFlushImage;
			SoundManager._soundClass = FlashSound;

			ClassUtils.getClass = function(className:String):Class
			{
				var classObject:String = ClassUtils._classMap[className] || className;
				return getDefinitionByName(classObject) as Class;
			};

			RunDriver.createFilterAction = FlashRunDriver.createFilterAction;
			
			//AtlasResourceManager.disable();
			
			FlashIncludeStr.__init__();
			
			IndexBuffer2D.create = FlashIndexBuffer.create;
			
			VertexBuffer2D.create = FlashVertexBuffer.create;
			
			Utils.parseXMLFromString = FlashDOMParser.parseFromString;
		}
	}
}
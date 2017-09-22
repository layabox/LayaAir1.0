package laya.webgl.canvas {
	import laya.webgl.WebGLContext;
	
	public class BlendMode
	{
		public static var activeBlendFunction:Function = null;
		
		public static const NAMES:Array = /*[STATIC SAFE]*/["normal", "add", "multiply", "screen","overlay","light","mask","destination-out"];
		public static const TOINT:* = /*[STATIC SAFE]*/{ "normal":0, "add":1, "multiply":2, "screen":3 ,"lighter":1,"overlay":4,"light":5,"mask":6,"destination-out":7};
		public static const NORMAL:String = /*0;// */"normal";
		public static const ADD:String = /*1;//*/ "add";
		public static const MULTIPLY:String = /*2;//*/ "multiply";
		public static const SCREEN:String = /*3;//*/ "screen";
		public static const LIGHT:String = /*1;//*/ "light";
		public static const OVERLAY:String =/*4;//*/ "overlay";
		public static const DESTINATIONOUT:String =/*7;//*/ "destination-out";
		
		public static var fns:Array = [];
		public static var targetFns:Array = [];
		
		public static function _init_(gl:WebGLContext):void
		{
			fns = [BlendNormal, BlendAdd, BlendMultiply, BlendScreen, BlendOverlay, BlendLight, BlendMask,BlendDestinationOut];
			targetFns = [BlendNormalTarget, BlendAddTarget, BlendMultiplyTarget, BlendScreenTarget, BlendOverlayTarget, BlendLightTarget,BlendMask,BlendDestinationOut];
		}
		
		public static function BlendNormal(gl:WebGLContext):void
		{
			//为了避免黑边，和canvas作为贴图的黑边
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}

		public static function BlendAdd(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.DST_ALPHA);
		}
		
		public static function BlendMultiply(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.DST_COLOR, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}
		
		public static function BlendScreen(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE);
		}
		
		public static function BlendOverlay(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_COLOR);
		}

		public static function BlendLight(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE);
		}

		public static function BlendNormalTarget(gl:WebGLContext):void
		{
			gl.blendFunc(WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}

		public static function BlendAddTarget(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.DST_ALPHA);
		}
		
		public static function BlendMultiplyTarget(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.DST_COLOR, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}
		
		public static function BlendScreenTarget(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE);
		}
		
		public static function BlendOverlayTarget(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_COLOR);
		}

		public static function BlendLightTarget(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ONE, WebGLContext.ONE);
		}
		
		public static function BlendMask(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ZERO, WebGLContext.SRC_ALPHA);
		}
		
		public static function BlendDestinationOut(gl:WebGLContext):void
		{
			gl.blendFunc( WebGLContext.ZERO, WebGLContext.ZERO);
		}
	}
}
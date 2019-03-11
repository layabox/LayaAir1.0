package laya.webgl.canvas {
	import laya.webgl.WebGLContext;
	
	public class BlendMode
	{
		public static var activeBlendFunction:Function = null;
		public static const NAMES:Array = /*[STATIC SAFE]*/["normal", "add", "multiply", "screen", "overlay", "light", "mask", "destination-out"];
		public static const TOINT:* = /*[STATIC SAFE]*/{ "normal":0, "add":1, "multiply":2, "screen":3 , "overlay":4, "light":5, "mask":6, "destination-out":7, "lighter":1 };
		
		public static const NORMAL:String = "normal";					//0
		public static const ADD:String = "add";							//1
		public static const MULTIPLY:String = "multiply";				//2
		public static const SCREEN:String = "screen";					//3
		public static const OVERLAY:String = "overlay";					//4
		public static const LIGHT:String = "light";						//5
		public static const MASK:String = "mask";						//6
		public static const DESTINATIONOUT:String = "destination-out";	//7
		public static const LIGHTER:String = "lighter";					//1  等同于加色法
		
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
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}

		public static function BlendAdd(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.DST_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendMultiply(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.DST_COLOR, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendScreen(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE);
		}
		
		//TODO:coverage
		public static function BlendOverlay(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_COLOR);
		}
		
		//TODO:coverage
		public static function BlendLight(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE);
		}
	
		public static function BlendNormalTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl,WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendAddTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.DST_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendMultiplyTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.DST_COLOR, WebGLContext.ONE_MINUS_SRC_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendScreenTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE);
		}
		
		//TODO:coverage
		public static function BlendOverlayTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_COLOR);
		}

		//TODO:coverage
		public static function BlendLightTarget(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE);
		}
		
		public static function BlendMask(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ZERO, WebGLContext.SRC_ALPHA);
		}
		
		//TODO:coverage
		public static function BlendDestinationOut(gl:WebGLContext):void
		{
			WebGLContext.setBlendFunc(gl, WebGLContext.ZERO, WebGLContext.ZERO);
		}
	}
}
package laya.filters {
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.filters.IFilterAction;
	import laya.filters.BlurFilter;
	import laya.filters.GlowFilterAction;
	import laya.filters.webgl.BlurFilterActionGL;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.filters.webgl.GlowFilterActionGL;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.system.System;
	import laya.utils.RunDriver;
	import laya.webgl.canvas.save.SaveClipRect;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 */
	public class WebGLFilter {
		private static var isInit:Boolean = false;
		
		/*[IF-SCRIPT-BEGIN]
		   {
		   RunDriver.createFilterAction=
		   function(type:int)
		   {
		   var action;
		   switch(type)
		   {
		   case Filter.BLUR:
		   action=new BlurFilter();
		   break;
		   case Filter.GLOW:
		   action=new GlowFilterAction();
		   break;
		   case Filter.COLOR:
		   action=new ColorFilterAction();
		   break;
		   }
		   return action;
		   }
		   }
		   [IF-SCRIPT-END]*/
		public static function enable():void {
			if (isInit) return;
			isInit = true;
			if (!Render.isWebGL) return;
		/*[IF-SCRIPT-BEGIN]
		   RunDriver.createFilterAction=function(type);
		   {
		   var action;
		   switch(type)
		   {
		   case Filter.COLOR:
		   action=new ColorFilterActionGL();
		   break;
		   case Filter.BLUR:
		   action=new BlurFilterActionGL();
		   break;
		   case Filter.GLOW:
		   action=new GlowFilterActionGL();
		   break;
		   }
		   return action;
		   }
		   [IF-SCRIPT-END]*/
		}
	
	}

}
package laya.filters
{
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
import laya.webgl.resource.RenderTarget2D;
import laya.webgl.shader.d2.ShaderDefines2D;
import laya.webgl.shader.d2.value.Value2D;
import laya.webgl.submit.Submit;
import laya.webgl.submit.SubmitCMD;
import laya.webgl.submit.SubmitCMDScope;
	public class WebGLFilter
	{
		private static var isInit:Boolean = false;
		/*[IF-SCRIPT-BEGIN]
		{
			System.createFilterAction=
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
		public static function enable():void
		{
			if (isInit) return ;
			isInit = true;
			if (!Render.isWebGl) return;
			/*[IF-SCRIPT-BEGIN]

			System.createFilterAction=function(type);
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
			
			//scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number
			Filter._filterStart=function(scope, sprite, context, x, y){
				var b = scope.getValue("bounds");
				var source = RenderTarget2D.create(b.width+20, b.height+20);
				source.start();
				//source.clear(0,0,1,1);
				scope.addValue("src", source);
			}
			
			//scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number
			Filter._filterEnd=function(scope, sprite:Sprite, context, x:Number, y:Number):void {
				var b = scope.getValue("bounds");
				var source = scope.getValue("src");
				source.end();
				var out = RenderTarget2D.create(b.width + 20, b.height + 20);
				out.start();
				scope.addValue("out", out);
				sprite._filterCache = out;
			}
				
			//scope:SubmitCMDScope
			Filter._EndTarget=function(scope):void {
				var out = scope.getValue("out");
				out.end();
			}
			
			//scope:SubmitCMDScope
			Filter._recycleScope=function(scope):void {
				//var out = scope.getValue("out");
				//out.recycle();
				//var src = scope.getValue("src");
				//src.recycle();
				scope.recycle();
				//tmpTarget.recycle();
			}
			
			[IF-SCRIPT-END]*/
		}
		
	}
	
}
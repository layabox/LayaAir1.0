package laya.filters.webgl
{
	import laya.display.Sprite;
	import laya.filters.ColorFilter;
	import laya.filters.IFilterActionGL;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMDScope;
	
	public class ColorFilterActionGL extends FilterActionGL implements IFilterActionGL
	{
		public var data:ColorFilter;
		public function ColorFilterActionGL(){}
		
		override public function setValue(shader:*):void
		{
			shader.u_colorMatrix=  data._elements;
		}
		/*
		override public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):*
		{
			var b:Rectangle=scope.getValue("bounds");
			var shaderValue:Value2D=Value2D.createShderValue(ShaderDefines2D.TEXTURE2D,sprite.filters);
			context.ctx.drawTarget(scope,0,0,b.width+20,b.height+20,Matrix.EMPTY,"src",shaderValue);
		}*/
	}
}
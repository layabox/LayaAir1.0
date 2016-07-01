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
		public function ColorFilterActionGL() { }
		
		override public function setValue(shader:*):void
		{
			shader.colorMat = data._mat;
			shader.colorAlpha = data._alpha;
		}
		
		override public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):*
		{
			var b:Rectangle=scope.getValue("bounds");
			var shaderValue:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			shaderValue.setFilters([data]);
			var tMatrix:Matrix = Matrix.EMPTY;
			tMatrix.identity();
			context.ctx.drawTarget(scope,0,0,b.width,b.height,tMatrix,"src",shaderValue);
		}
	}
}
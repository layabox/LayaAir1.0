package laya.filters.webgl
{
	import laya.display.Sprite;
	import laya.filters.IFilterActionGL;
	import laya.renders.RenderContext;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMDScope;
	
	public class FilterActionGL implements IFilterActionGL
	{
		public function FilterActionGL()
		{
		}
		
		public function get typeMix():int
		{
			return 0;
		}
		
		public function setValue(shader:*):void{}
		
		public function setValueMix(shader:Value2D):void{}
		
		public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):*{return null;}
		
		public function apply(srcCanvas:*):*{return null;}
	}
}
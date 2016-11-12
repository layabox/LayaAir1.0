package laya.filters
{
	import laya.display.Sprite;
	import laya.renders.RenderContext;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMDScope;

	public interface IFilterActionGL extends IFilterAction
	{
		
		function get typeMix():int;
		
		function setValue(shader:*):void;
		
		function setValueMix(shader:Value2D):void;
		
		function apply3d(scope:SubmitCMDScope,sprite:Sprite,context:RenderContext,x:Number,y:Number):*;
	}
}
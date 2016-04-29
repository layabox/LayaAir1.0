package laya.filters
{
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.system.System;

	/**
	 * webgl ok ,canvas unok
	 * 
	 */
	public class BlurFilter extends Filter
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public var _blurX:int;
		public var _blurY:int;
		public var strength:Number;
		public function BlurFilter(strength:Number=4)
		{
			WebGLFilter.enable();
			super();
			this.strength=strength;
			_action=System.createFilterAction(BLUR);
			_action.data=this;
		}
		
		override public function get action():IFilterAction
		{
			return _action;
		}
		
		override public function get type():int
		{
			return BLUR;
		}
	}
}
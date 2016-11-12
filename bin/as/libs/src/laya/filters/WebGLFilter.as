package laya.filters
{
	import laya.filters.webgl.BlurFilterActionGL;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.filters.webgl.GlowFilterActionGL;
	import laya.renders.Render;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 */
	public class WebGLFilter
	{
		private static var isInit:Boolean = false;
		
		BlurFilterActionGL;
		ColorFilterActionGL;
		GlowFilterActionGL;
		Render;
		RunDriver;

		/*[IF-SCRIPT-BEGIN]
		{
			RunDriver.createFilterAction = function(type:int):IFilterAction
			{
				var action:IFilterAction;
				switch (type)
				{
				case Filter.BLUR: 
					action = new FilterAction();
					break;
				case Filter.GLOW: 
					action = new FilterAction();
					break;
				case Filter.COLOR: 
					action = new ColorFilterAction();
					break;
				}
				return action;
			}
		}
		
		[IF-SCRIPT-END]*/
		public static function enable():void
		{
			if (isInit) return;
			isInit = true;
			if (!Render.isWebGL) return;
			/*[IF-SCRIPT-BEGIN]
			RunDriver.createFilterAction = function(type)
			{
				var action:IFilterAction;
				switch (type)
				{
				case Filter.COLOR: 
					action = new ColorFilterActionGL();
					break;
				case Filter.BLUR: 
					action = new BlurFilterActionGL();
					break;
				case Filter.GLOW: 
					action = new GlowFilterActionGL();
					break;
				}
				return action;
			}
			[IF-SCRIPT-END]*/
		}
	
	}

}
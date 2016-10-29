package laya.debug.tools.enginehook 
{
	import laya.debug.tools.CacheAnalyser;
	import laya.debug.tools.RenderAnalyser;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.utils.Browser;
	import laya.utils.Stat;

	/**
	 * ...
	 * @author ww
	 */
	public class SpriteRenderHook 
	{
		
		public function SpriteRenderHook() 
		{
			
		}
		public static var I:SpriteRenderHook;
		public static function init():void
		{
			I = new SpriteRenderHook();
			setRenderHook();
		}
		public static function setRenderHook():void
		{
			Sprite["prototype"]["render"]=I.render;
		}
		/** @private */
		protected var _repaint:int = 1;
		public var _renderType:int = 1;
		public var _x:int;
		public var _y:int;
		/**
		 * 更新、呈现显示对象。
		 * @param	context 渲染的上下文引用。
		 * @param	x X轴坐标。
		 * @param	y Y轴坐标。
		 */
		public function render(context:RenderContext, x:Number, y:Number):void {
			if ((this as Stage) == Laya.stage)
			{
				CacheAnalyser.renderLoopBegin();
			}
			var preTime:int;
			preTime = Browser.now();
			Stat.spriteCount++;
			RenderSprite.renders[_renderType]._fun(this, context, x + _x, y + _y);
			_repaint = 0;
			RenderAnalyser.I.render(this as Sprite, Browser.now() - preTime);
		}
		
		
	}

}
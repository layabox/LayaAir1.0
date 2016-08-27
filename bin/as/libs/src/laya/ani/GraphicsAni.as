package laya.ani 
{
	import laya.display.Graphics;
	import laya.renders.Render;
	/**
	 * ...
	 * @author 
	 */
	public class GraphicsAni extends Graphics
	{
		
		public function GraphicsAni() 
		{
			super();
		}
		
		/**
		 * @private
		 * 画自定义蒙皮动画
		 * @param	skin
		 */
		public function drawSkin(skin:*):void
		{
			var arr:Array = [skin];
			_saveToCmd(Render._context._drawSkin, arr);
		}
		
	}

}
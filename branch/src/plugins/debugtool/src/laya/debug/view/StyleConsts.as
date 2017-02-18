package laya.debug.view 
{
	import laya.display.Sprite;
	import laya.utils.Browser;
	/**
	 * ...
	 * @author ww
	 */
	public class StyleConsts 
	{
		
		public function StyleConsts() 
		{
			
		}
		public static var PanelScale:Number = Browser.onPC?1:Browser.pixelRatio;
		public static function setViewScale(view:Sprite):void
		{
			view.scaleX = view.scaleY = PanelScale;
		}
	}

}
package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;

	public class SmartScale_SIZE_FULL_WIDTH
	{
		private var rect:Sprite;
		
		public function SmartScale_SIZE_FULL_WIDTH()
		{
			Laya.init(Browser.width, Browser.height);
			
			Laya.stage.sizeMode = Stage.SIZE_FULL_WIDTH;
			
			createCantralRect();
		}
		
		private function createCantralRect():void 
		{
			rect = new Sprite();
			rect.graphics.drawRect(-100, -100, 200, 200, "gray");
			Laya.stage.addChild(rect);
			
			updateRectPos();
			Laya.stage.on("resize", this, updateRectPos);
		}
		
		private function updateRectPos():void
		{
			rect.x = Browser.clientWidth / 2;
			rect.y = Browser.clientHeight / 2;
		}
	}
}
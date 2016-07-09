package 
{
	import laya.display.Sprite;
	import laya.display.Stage;

	public class SmartScale_Scale_SHOW_ALL 
	{
		private var rect:Sprite;
		
		public function SmartScale_Scale_SHOW_ALL() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			createCantralRect();
		}
		
		private function createCantralRect():void 
		{
			rect = new Sprite();
			rect.graphics.drawRect(-100, -100, 200, 200, "gray");
			Laya.stage.addChild(rect);
			
			updateRectPos();
		}
		
		private function updateRectPos():void
		{
			rect.x = Laya.stage.width / 2;
			rect.y = Laya.stage.height / 2;
		}
	}

}
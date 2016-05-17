package 
{
	import laya.display.Stage;
	import laya.ui.Button;
	import laya.utils.Handler;
	
	public class UI_Button
	{
		private const COLUMNS:int = 2;
		private const BUTTON_WIDTH:int = 147;
		private const BUTTON_HEIGHT:int = 165 / 3;
		private const HORIZONTAL_SPACING:int = 200;
		private const VERTICAL_SPACING:int = 100;

		private var xOffset:int;
		private var yOffset:int;

		private var skins:Array;

		public function UI_Button()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			skins = [
				"res/ui/button-1.png", "res/ui/button-2.png", "res/ui/button-3.png", 
				"res/ui/button-4.png", "res/ui/button-5.png", "res/ui/button-6.png"
				];

			// 计算将Button至于舞台中心的偏移量
			xOffset = (Laya.stage.width - HORIZONTAL_SPACING * (COLUMNS - 1) - BUTTON_WIDTH) / 2;
			yOffset = (Laya.stage.height - VERTICAL_SPACING * (skins.length / COLUMNS - 1) - BUTTON_HEIGHT) / 2;

			Laya.loader.load(skins, Handler.create(this, onUIAssertLoaded));
		}
		
		private function onUIAssertLoaded():void
		{
			for(var i:int = 0, len = skins.length; i < len; ++i)
			{
				var btn:Button = createButton(skins[i]);
				var x:Number = i % COLUMNS * HORIZONTAL_SPACING + xOffset;
				var y:Number = (i / COLUMNS | 0) * VERTICAL_SPACING + yOffset;
				btn.pos(x, y);
			}
		}

		private function createButton(skin:String):Button
		{
			var btn:Button = new Button(skin);
			Laya.stage.addChild(btn);
			return btn;
		}
	}
}
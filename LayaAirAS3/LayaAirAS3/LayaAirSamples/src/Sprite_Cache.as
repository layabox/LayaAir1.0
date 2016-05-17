package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.utils.Stat;
	
	public class Sprite_Cache
	{
		
		public function Sprite_Cache()
		{
			Laya.init(Browser.width, Browser.height);
			Stat.show();
			
			init();
		}
		
		private function init():void 
		{
			var scaleFactory:Number = Browser.pixelRatio;
			var textBox:Sprite = new Sprite();
			
			// 随机摆放文本
			var text:Text;
			for (var i:int = 0; i < 1000; i++)
			{
				text = new Text();
				text.fontSize = 20;
				text.text = (Math.random() * 100).toFixed(0);
				text.rotation = Math.random() * 360;
				text.color = "#CCCCCC";
				
				text.x = Math.random() * Laya.stage.width / scaleFactory;
				text.y = Math.random() * Laya.stage.height / scaleFactory;
				
				textBox.addChild(text);
			}
			
			//缓存为静态图像
			textBox.cacheAsBitmap = true;
			textBox.scale(scaleFactory, scaleFactory);
			
			Laya.stage.addChild(textBox);
		}
	}
}
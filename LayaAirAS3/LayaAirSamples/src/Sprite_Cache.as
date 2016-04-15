package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Stat;
	
	public class Sprite_Cache
	{
		
		public function Sprite_Cache()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Stat.show();
			
			var textBox:Sprite = new Sprite();
			//textBox.size(550, 400);
			
			// 5000个随机摆放的文本
			var text:Text;
			for (var i:int = 0; i < 5000; i++)
			{
				text = new Text();
				text.text = (Math.random() * 100).toFixed(0);
				text.color = "#CCCCCC";
				
				text.x = Math.random() * 550;
				text.y = Math.random() * 400;
				
				textBox.addChild(text);
			}
			
			//缓存为静态图像
			textBox.cacheAsBitmap = true;
			
			Laya.stage.addChild(textBox);
		}
	}
}
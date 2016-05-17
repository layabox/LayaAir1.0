/// <reference path="../../libs/LayaAir.d.ts" />
module laya 
{
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import Text = laya.display.Text;
	import Browser = laya.utils.Browser;
	import Stat = laya.utils.Stat;

	export class Sprite_Cache 
	{
		constructor() 
		{
			Laya.init(Browser.width, Browser.height);
			Stat.show();

			this.init();
		}

		private init(): void 
		{
			var scaleFactory: number = Browser.pixelRatio;
			var textBox: Sprite = new Sprite();

			// 随机摆放文本
			var text: Text;
			for (var i: number = 0; i < 1000; i++) 
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
new laya.Sprite_Cache();
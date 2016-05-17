(function()
{
	var Sprite = Laya.Sprite;
	var Text = Laya.Text;

	Laya.init(Browser.width, Browser.height);
	Laya.Stat.show();

	init();

	function init()
	{
		var scaleFactory = Browser.pixelRatio;
		var textBox = new Sprite();

		// 随机摆放文本
		var text;
		for (var i = 0; i < 1000; i++)
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
})();
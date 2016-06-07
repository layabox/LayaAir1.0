(function()
{
	var Stage       = Laya.Stage;
	var ProgressBar = Laya.ProgressBar;
	var Handler     = Laya.Handler;
	var WebGL       = Laya.WebGL;

	var progressBar;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(800, 600, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(["res/ui/progressBar.png", "res/ui/progressBar$bar.png"], Handler.create(this, onLoadComplete));
	})();

	function onLoadComplete()
	{
		progressBar = new ProgressBar("res/ui/progressBar.png");

		progressBar.width = 400;

		progressBar.x = (Laya.stage.width - progressBar.width) / 2;
		progressBar.y = Laya.stage.height / 2;

		progressBar.sizeGrid = "5,5,5,5";
		progressBar.changeHandler = new Handler(this, onChange);
		Laya.stage.addChild(progressBar);

		Laya.timer.loop(100, this, changeValue);
	}

	function changeValue()
	{

		if (progressBar.value >= 1)
			progressBar.value = 0;
		progressBar.value += 0.05;
	}

	function onChange(value)
	{
		console.log("进度：" + Math.floor(value * 100) + "%");
	}
})();
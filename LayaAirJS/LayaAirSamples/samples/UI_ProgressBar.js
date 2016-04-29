var progressBar;

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.loader.load(["res/ui/progressBar.png", "res/ui/progressBar$bar.png"], Laya.Handler.create(this, onLoadComplete));

function onLoadComplete()
{
	progressBar = new Laya.ProgressBar("res/ui/progressBar.png");
	progressBar.pos(75, 150); 

	progressBar.width = 400;

	progressBar.sizeGrid = "5,5,5,5";
	progressBar.changeHandler = new Laya.Handler(this, onChange);
	Laya.stage.addChild(progressBar);

	Laya.timer.loop(100, this, changeValue);
}
function changeValue()
{
	progressBar.value += 0.05;

	if (progressBar.value == 1)
		progressBar.value = 0;
}
function onChange(value)
{
	console.log("进度：" + Math.floor(value * 100) + "%");
}
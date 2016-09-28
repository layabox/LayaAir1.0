(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Shake   = Laya.Shake;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;

	var picW = 824;
	var picH = 484;
	var console;
	
	var shakeCount = 0;
	(function()
	{
		Laya.init(picW, Browser.height * picW / Browser.width);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		
		showShakePic();
		showConsoleText();
		startShake();
	})();
	function showShakePic()
	{
		var shakePic = new Sprite();
		shakePic.loadImage("../../res/inputDevice/shake.png");
		Laya.stage.addChild(shakePic);
	}
	function showConsoleText()
	{
		console = new Text();
		Laya.stage.addChild(console);
		
		console.y = picH + 10;
		console.width = Laya.stage.width;
		console.height = Laya.stage.height - console.y;
		console.color = "#FFFFFF";
		console.fontSize = 50;
		console.align = "center";
		console.valign = 'middle';
		console.leading = 10;
	}
	
	function startShake() 
	{
		Shake.instance.start(5, 500);
		Shake.instance.on(Laya.Event.CHANGE, this, onShake);
		console.text = '开始接收设备摇动\n';
	}
	
	function onShake()
	{
		shakeCount++;
		
		console.text += "设备摇晃了" + shakeCount + "次\n";
		
		if (shakeCount >= 3)
		{
			Shake.instance.stop();
			
			console.text += "停止接收设备摇动";
		}
	}
})();
		
		
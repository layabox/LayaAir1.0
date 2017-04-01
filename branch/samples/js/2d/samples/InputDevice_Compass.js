(function()
{
	var Sprite       = Laya.Sprite;
	var Stage        = Laya.Stage;
	var Text         = Laya.Text;
	var Gyroscope    = Laya.Gyroscope;
	var RotationInfo = Laya.RotationInfo;
	var Browser      = Laya.Browser;
	var Handler      = Laya.Handler;
	var WebGL        = Laya.WebGL;
	var Event        = Laya.Event;

	var compassImgPath = "../../res/inputDevice/kd.png";
	var compassImg;
	var degreesText;
	var directionIndicator;
	var firstTime = true;
	
	(function()
	{
		Laya.init(700, 1024, WebGL);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.alignH = Stage.ALIGN_CENTER;
		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		
		Laya.loader.load(compassImgPath, Handler.create(this, init));
	})();
	function init()
	{
		// 创建罗盘
		createCompass();
		// 创建方位指示器
		createDirectionIndicator();
		// 画出其他UI
		drawUI();
		// 创建显示角度的文本
		createDegreesText();
		
		Gyroscope.instance.on(Event.CHANGE, this, onOrientationChange);
	}
	function createCompass()
	{
		compassImg = new Sprite();
		Laya.stage.addChild(compassImg);
		compassImg.loadImage(compassImgPath);
		
		compassImg.pivot(compassImg.width / 2, compassImg.height / 2);
		compassImg.pos(Laya.stage.width / 2, 400);
	}
			
	function drawUI()
	{
		var canvas = new Sprite();
		Laya.stage.addChild(canvas);
		
		canvas.graphics.drawLine(compassImg.x, 50, compassImg.x, 182, "#FFFFFF", 3);
		
		canvas.graphics.drawLine(-140 + compassImg.x, compassImg.y, 140 + compassImg.x, compassImg.y, "#AAAAAA", 1);
		canvas.graphics.drawLine(compassImg.x, -140 + compassImg.y, compassImg.x, 140 + compassImg.y, "#AAAAAA", 1);
	}
			
	function createDegreesText()
	{
		degreesText = new Text();
		Laya.stage.addChild(degreesText);
		
		degreesText.align = "center";
		degreesText.size(Laya.stage.width, 100);
		degreesText.pos(0, compassImg.y + 400);
		degreesText.fontSize = 100;
		degreesText.color = "#FFFFFF";
	}
			
			// 方位指示器指向当前所朝方位。
	function createDirectionIndicator()
	{
		directionIndicator = new Sprite();
		Laya.stage.addChild(directionIndicator);
		
		directionIndicator.alpha = 0.8;
		
		directionIndicator.graphics.drawCircle(0, 0, 70, "#343434");
		directionIndicator.graphics.drawLine(-40, 0, 40, 0, "#FFFFFF", 3);
		directionIndicator.graphics.drawLine(0, -40, 0, 40, "#FFFFFF", 3);
		
		directionIndicator.x = compassImg.x;
		directionIndicator.y = compassImg.y;
	}
			
	function onOrientationChange(absolute, info)
	{
		if (info.alpha === null)
		{
			alert("当前设备不支持陀螺仪。");
		}
		else if (firstTime && !absolute && !Browser.onIOS)
		{
			firstTime = false;
			alert("在当前设备中无法获取地球坐标系，使用设备坐标系，你可以继续观赏，但是提供的方位并非正确方位。");
		}
		
		// 更新角度显示
		degreesText.text = 360 - Math.floor(info.alpha) + "°";
		compassImg.rotation = info.alpha;
		
		// 更新方位指示器
		directionIndicator.x = -1 * Math.floor(info.gamma) / 90 * 70 + compassImg.x;
		directionIndicator.y = -1 * Math.floor(info.beta) / 90 * 70 + compassImg.y;
	}
})()

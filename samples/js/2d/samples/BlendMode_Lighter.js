(function()
{
	var Animation = Laya.Animation;
	var Stage     = Laya.Stage;
	var Browser   = Laya.Browser;
	var Handler   = Laya.Handler;
	var Tween     = Laya.Tween;
	var WebGL     = Laya.WebGL;

	// 一只凤凰的分辨率是550 * 400
	var phoenixWidth = 550;
	var phoenixHeight = 400;

	var bgColorTweener = new Tween();
	var gradientInterval = 2000;
	var bgColorChannels = {
		r: 99,
		g: 0,
		b: 0xFF
	};

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(phoenixWidth * 2, phoenixHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		createPhoenixes();

		// 动态背景渲染
		evalBgColor();
		Laya.timer.frameLoop(1, this, renderBg);
	}

	function createPhoenixes()
	{
		var scaleFactor = Math.min(
			Laya.stage.width / (phoenixWidth * 2),
			Laya.stage.height / phoenixHeight);

		// 加了混合模式的凤凰
		var blendedPhoenix = createAnimation();
		blendedPhoenix.blendMode = "lighter";
		blendedPhoenix.scale(scaleFactor, scaleFactor);
		blendedPhoenix.y = (Laya.stage.height - phoenixHeight * scaleFactor) / 2;

		// 正常模式的凤凰
		var normalPhoenix = createAnimation();
		normalPhoenix.scale(scaleFactor, scaleFactor);
		normalPhoenix.x = phoenixWidth * scaleFactor;
		normalPhoenix.y = (Laya.stage.height - phoenixHeight * scaleFactor) / 2;
	}

	function createAnimation()
	{
		var frames = [];
		for (var i = 1; i <= 25; ++i)
		{
			frames.push("../../res/phoenix/phoenix" + preFixNumber(i, 4) + ".jpg");
		}

		var animation = new Animation();
		animation.loadImages(frames);
		Laya.stage.addChild(animation);

		var clips = animation.frames.concat();
		// 反转帧
		clips = clips.reverse();
		// 添加到已有帧末尾
		animation.frames = animation.frames.concat(clips);

		animation.play();

		return animation;
	}

	function preFixNumber(num, strLen)
	{
		return ("0000000000" + num).slice(-strLen);
	}
		

	function evalBgColor()
	{
		var color = Math.random() * 0xFFFFFF;
		var channels = getColorChannals(color);
		bgColorTweener.to(bgColorChannels,
		{
			r: channels[0],
			g: channels[1],
			b: channels[2]
		}, gradientInterval, null, Handler.create(this, onTweenComplete));
	}

	function getColorChannals(color)
	{
		var result = [];
		result.push(color >> 16);
		result.push(color >> 8 & 0xFF);
		result.push(color & 0xFF);
		return result;
	}

	function onTweenComplete()
	{
		evalBgColor();
	}

	function renderBg()
	{
		Laya.stage.graphics.clear();
		Laya.stage.graphics.drawRect(
			0, 0,
			phoenixWidth, phoenixHeight, getHexColorString());
	}

	function getHexColorString()
	{
		bgColorChannels.r = Math.floor(bgColorChannels.r);
		// 绿色通道使用0
		bgColorChannels.g = 0;
		//obj.g = Math.floor(obj.g);
		bgColorChannels.b = Math.floor(bgColorChannels.b);

		var r = bgColorChannels.r.toString(16);
		r = r.length == 2 ? r : "0" + r;
		var g = bgColorChannels.g.toString(16);
		g = g.length == 2 ? g : "0" + g;
		var b = bgColorChannels.b.toString(16);
		b = b.length == 2 ? b : "0" + b;
		return "#" + r + g + b;
	}
})();
(function()
{
	var Text = Laya.Text;
	var Media = Laya.Media;
	var Video = Laya.Video;
	var Render = Laya.Render;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;

	var video;

	Laya.init(Browser.width, Browser.height);

	if (Media.supported() === false)
		alert("当前浏览器不支持");
	else
	{
		showMessage();

		var options = {
			audio: true,
			video:
			{
				facingMode:
				{
					exact: "environment"
				}, // 后置摄像头，默认值就是，不设至也可以。
				width: Laya.stage.width,
				height: Laya.stage.height
			}
		};

		Media.getMedia(options, Handler.create(this, onSuccess), Handler.create(this, onError));
	}

	function showMessage()
	{
		var text = new Text();
		Laya.stage.addChild(text);
		text.text = "单击舞台播放和暂停";
		text.color = "#FFFFFF";
		text.fontSize = 100;
		text.valign = "middle";
		text.align = "center";
		text.size(Laya.stage.width, Laya.stage.height);
	}

	function onSuccess(url)
	{
		video = new Video(Laya.stage.width, Laya.stage.height);
		video.load(url);
		Laya.stage.addChild(video);

		Laya.stage.on('click', this, onStageClick);
	}

	function onError(error)
	{
		alert(error.message);
	}

	function onStageClick()
	{
		// 切换播放和暂停。
		if (!video.paused)
			video.pause();
		else
			video.play();
	}
})();
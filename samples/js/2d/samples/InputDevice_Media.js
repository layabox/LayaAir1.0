(function()
{
	var Media = Laya.Media;
	var Video = Laya.Video;
	var Text = Laya.Text;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;

	/**
	 * ...
	 * @author Survivor
	 */
	if (Media.supported() === false)
		alert("当前浏览器不支持");
	else
	{
		var options = {
			audio: false,
			video:
			{
				width: Browser.width,
				height: Browser.height
			}
		};

		Media.getMedia(options, Handler.create(this, onSuccess), Handler.create(this, onError));
	}

	function onSuccess(url)
	{
		var video = document.createElement("video");
		video.width = Browser.clientWidth;
		video.height = Browser.clientHeight;
		video.style.zIndex = 1E5;
		document.body.appendChild(video);
		video.controls = true;
		video.src = url;
		video.play();
	}

	function onError(error)
	{
		alert(error.name + ":" + error.message);
	}
})();
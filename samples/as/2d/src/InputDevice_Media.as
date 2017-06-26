package
{
	import laya.device.media.Media;
	import laya.device.media.Video;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class InputDevice_Media
	{
		public function InputDevice_Media()
		{
			if (Media.supported() === false)
				alert("当前浏览器不支持");
			else
			{
				var options:Object = {
					audio: false,
					video: 
						{
							width: Browser.width,
							height: Browser.height
						}
				};
				
				Media.getMedia(options, Handler.create(this, onSuccess), Handler.create(this, onError));
			}
		}
		
		private function onSuccess(url:String):void
		{
			var video = Browser.document.createElement("video");
			video.width = Browser.clientWidth;
			video.height = Browser.clientHeight;
			video.style.zIndex = 1E5;
			Browser.document.body.appendChild(video);
			video.controls = true;
			video.src = url;
			video.play();
		}
		
		private function onError(error:Error):void
		{
			alert(error.message);
		}
	}
}
module laya
{
	import Media = Laya.Media;
	import Video = Laya.Video;
	import Text = Laya.Text;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	
	/**
	 * ...
	 * @author Survivor
	 */
	export class InputDevice_Media
	{
		private video:Video;
		
		constructor()
		{
			if (Media.supported() === false)
				alert("当前浏览器不支持");
			else
			{
				var options:any = {
					audio: true,
					video: { 
						width: Browser.width,
						height:Browser.height
					}
				};
				
				Media.getMedia(options, Handler.create(this, this.onSuccess), Handler.create(this, this.onError));
			}
		}
		
		private onSuccess(url:string):void
		{
			var video:any = Browser.document.createElement("video");
			video.width = Browser.clientWidth;
			video.height = Browser.clientHeight;
			video.style.zIndex = 1E5;
			Browser.document.body.appendChild(video);
			video.controls = true;
			video.src = url;
			video.play();
		}
		
		private onError(error:Error):void
		{
			alert(error.name + ":" + error.message);
		}
	}
}
new laya.InputDevice_Media();
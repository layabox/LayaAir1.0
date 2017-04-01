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
		private var video:Video;
		
		public function InputDevice_Media()
		{
			Laya.init(Browser.width, Browser.height);
			
			if (Media.supported() === false)
				alert("当前浏览器不支持");
			else
			{
				showMessage();
				
				var options:Object = {
					audio: true,
					video: { 
						facingMode: { exact: "environment" },	// 后置摄像头，默认值就是，不设至也可以。
						width: Laya.stage.width,
						height:Laya.stage.height
					}
				};
				
				Media.getMedia(options, Handler.create(this, onSuccess), Handler.create(this, onError));
			}
		}
		
		private function showMessage():void 
		{
			var text:Text = new Text();
			Laya.stage.addChild(text);
			text.text = "单击舞台播放和暂停";
			text.color = "#FFFFFF";
			text.fontSize = 100;
			text.valign = "middle";
			text.align = "center";
			text.size(Laya.stage.width, Laya.stage.height);
		}
		
		private function onSuccess(url:String):void
		{
			video = new Video(Laya.stage.width, Laya.stage.height);
			video.load(url);
			Laya.stage.addChild(video);
			
			Laya.stage.on('click', this, onStageClick);
		}
		
		private function onError(error:Error):void
		{
			alert(error.message);
		}
		
		private function onStageClick():void
		{
			// 切换播放和暂停。
			if (!video.paused)
				video.pause();
			else
				video.play();
		}
	}
}
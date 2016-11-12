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
			Laya.init(Browser.width, Browser.height);
			
			if (Media.supported() === false)
				alert("当前浏览器不支持");
			else
			{
				this.showMessage();
				
				var options:Object = {
					audio: true,
					video: { 
						facingMode: { exact: "environment" },	// 后置摄像头，默认值就是，不设至也可以。
						width: Laya.stage.width,
						height:Laya.stage.height
					}
				};
				
				Media.getMedia(options, Handler.create(this, this.onSuccess), Handler.create(this, this.onError));
			}
		}
		
		private showMessage():void 
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
		
		private onSuccess(url:string):void
		{
			this.video = new Video(Laya.stage.width, Laya.stage.height);
			this.video.load(url);
			Laya.stage.addChild(this.video);
			
			Laya.stage.on('click', this, this.onStageClick);
		}
		
		private onError(error:Error):void
		{
			alert(error.message);
		}
		
		private onStageClick():void
		{
			// 切换播放和暂停。
			if (!this.video.paused)
				this.video.pause();
			else
				this.video.play();
		}
	}
}
new laya.InputDevice_Media();
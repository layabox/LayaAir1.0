module laya {
	import Stage =  Laya.Stage;
	import Sprite =  Laya.Sprite;
	import Text =  Laya.Text;
	import Event =  Laya.Event;
	import Video =  Laya.Video;
	import Rectangle =  Laya.Rectangle;
	import Loader =  Laya.Loader;
	import Render =  Laya.Render;
	import Texture =  Laya.Texture;
	import Button =  Laya.Button;
	import HSlider =  Laya.HSlider;
	import Slider =  Laya.Slider;
	import TextInput =  Laya.TextInput;
	import Browser =  Laya.Browser;
	import Handler =  Laya.Handler;
	import StringKey =  Laya.StringKey;

	export class InputDevice_Video {
		private BackgroundSkin:string = "../../res/inputDevice/videoPlayer/background.png";
		private TimeLineBoxSkin:string = "../../res/inputDevice/videoPlayer/time line-box.png";
		private TimeLineSkin:string = "../../res/inputDevice/videoPlayer/time line.png";
		private ColorTimelineSkin:string = "../../res/inputDevice/videoPlayer/color time line.png";
		private PauseButtonSkin:string = "../../res/inputDevice/videoPlayer/pause button.png";
		private PlayButtonSkin:string = "../../res/inputDevice/videoPlayer/play button.png";
		private NormalSoundControlSkin:string = "../../res/inputDevice/videoPlayer/normal sound control.png";
		private SoundBgControlSkin:string = "../../res/inputDevice/videoPlayer/sound bg.png";
		private MuteButtonSkin:string = "../../res/inputDevice/videoPlayer/mute.png";
		private VolumnLineSkin:string = "../../res/inputDevice/videoPlayer/light-blue.png";
		private VolumeSliderSkin:string = "../../res/inputDevice/videoPlayer/volumeSlider.png";
		private PlayHeadSliderSkin:string = "../../res/inputDevice/videoPlayer/playHeadSlider.png";
		
		private video:Video;
		
		// UI
		private togglePlayButton:Button;
		private colorTimeline:Sprite;
		private volumeControl:Sprite;
		private playHeadSlider:Sprite;
		private timelineBox:Sprite;
		private volumeLine:Sprite;

		// 音量条和播放进度条的
		private volumeScrollRect:Rectangle;
		private playProgressScrollRect:Rectangle;

		 constructor()
		 {
			Laya.init(650, 350);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#FFFFFF";
			
			Laya.loader.load(
				[this.BackgroundSkin, this.TimeLineBoxSkin, this.TimeLineSkin, this.ColorTimelineSkin, this.PauseButtonSkin, this.PlayButtonSkin, this.NormalSoundControlSkin, this.SoundBgControlSkin, this.MuteButtonSkin, this.VolumnLineSkin, this.VolumeSliderSkin, this.PlayHeadSliderSkin], 
				Handler.create(this, this.setupUI));
		 }
		 // 以下是UI创建
		
		private setupUI():void
		{
			this.showGUI();
			this.createVideo();
		}
		
		private showGUI():void
		{
			this.showBackground();
			this.showTimelineControls();
			this.showSoundControl();
		}
		
		private showBackground():void
		{
			var background:Sprite = new Sprite();
			Laya.stage.addChild(background);
			background.loadImage(this.BackgroundSkin);
			background.y = 25;
		}
		
		private showTimelineControls():void
		{
			this.showTimelineBox();
			this.showPlaybackControls();
			this.showTimeline();
			this.showColorTimeline();
			this.showPlayHeadSlider();
		}
		
		private showTimelineBox():void
		{
			this.timelineBox = new Sprite();
			Laya.stage.addChild(this.timelineBox);
			this.timelineBox.loadImage(this.TimeLineBoxSkin);
			this.timelineBox.pos(108, 280);
		}
		
		private showPlaybackControls():void
		{
			this.togglePlayButton = new Button();
			this.togglePlayButton.skin = this.PlayButtonSkin;
			Laya.stage.addChild(this.togglePlayButton);
			this.togglePlayButton.pos(110, 290);
			this.togglePlayButton.on(Event.CLICK, this, this.onTogglePlay);
		}
		
		private showTimeline():void 
		{
			var timeline:Sprite = new Sprite();
			Laya.stage.addChild(timeline);
			timeline.loadImage(this.TimeLineSkin);
			timeline.pos(143, 295);
		}
		
		private showColorTimeline():void 
		{
			var texture:Texture = Loader.getRes(this.ColorTimelineSkin);
			this.colorTimeline = new Sprite();
			Laya.stage.addChild(this.colorTimeline);
			this.colorTimeline.graphics.drawTexture(texture, 0, 0);
			this.colorTimeline.size(texture.width, texture.height);
			this.colorTimeline.pos(143, 296);
			
			this.playProgressScrollRect = new Rectangle(0, 0, 0, 8);
			this.colorTimeline.scrollRect = this.playProgressScrollRect;
		}
		
		private showPlayHeadSlider():void 
		{
			this.playHeadSlider = new Sprite();
			this.playHeadSlider.loadImage(this.PlayHeadSliderSkin);
			Laya.stage.addChild(this.playHeadSlider);
			this.playHeadSlider.pos(143, 292);
			this.playHeadSlider.pivotX =this.playHeadSlider.width / 2;
			
			var prevX:number;
			this.timelineBox.on(Event.MOUSE_DOWN, this,function():void
			{
				if (!this.video.paused)
					this.pause();
				
				Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.on(Event.MOUSE_UP, this, endDrag);
				
				prevX = Laya.stage.mouseX;
			});
			
			function moveSlider():void
			{
				var dx:number = Laya.stage.mouseX - prevX;
				this.playHeadSlider.x += dx;
				prevX = Laya.stage.mouseX;
				
				if (this.playHeadSlider.x < 143)
					this.playHeadSlider.x = 143;
				else if (this.playHeadSlider.x > 143 + this.colorTimeline.width)
					this.playHeadSlider.x = 143 + this.colorTimeline.width;
					
				this.video.currentTime = this.video.duration * (this.playHeadSlider.x - 143) / this.colorTimeline.width;
				console.log(this.video.currentTime);
				this.playProgressScrollRect.width = this.video.currentTime / this.video.duration * this.colorTimeline.width;	
			}
			function endDrag():void
			{
				Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.off(Event.MOUSE_UP, this, endDrag);
				
				this.play();
			}
		}
		
		private showSoundControl():void 
		{
			this.showNormalSoundControl();
			this.createVolumeControl();
			this.createVolumeLine();
			this.createVolumeSlider();
			this.createMuteButton();
		}
		
		private showNormalSoundControl():void 
		{
			var soundContorl:Sprite = new Sprite();
			Laya.stage.addChild(soundContorl);
			soundContorl.loadImage(this.NormalSoundControlSkin);
			soundContorl.pos(68, 280);
			soundContorl.on(Event.CLICK, this, function():void
			{
				if (this.volumeControl.parent)
					Laya.stage.removeChild(this.volumeControl);
				else
					Laya.stage.addChild(this.volumeControl);
			});
		}
		private createVolumeControl():void 
		{
			this.volumeControl = new Sprite();
			this.volumeControl.loadImage(this.SoundBgControlSkin);
			this.volumeControl.pos(68, 176);
		}
		
		private createVolumeLine():void 
		{
			this.volumeLine = new Sprite();
			this.volumeControl.addChild(this.volumeLine);
			this.volumeLine.loadImage(this.VolumnLineSkin);
			this.volumeLine.pos(15, 12);
			
			this.volumeScrollRect = new Rectangle(0, 0, 7, 55);
			this.volumeLine.scrollRect = this.volumeScrollRect;
		}
		
		private createVolumeSlider():void 
		{
			var volumeSlider:Sprite = new Sprite();
			this.volumeControl.addChild(volumeSlider);
			volumeSlider.loadImage(this.VolumeSliderSkin);
			volumeSlider.pos(12, 8);
			
			var prevY:number;
			this.volumeControl.on(Event.MOUSE_DOWN, this, function():void
			{
				Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.on(Event.MOUSE_UP, this, endDrag);
				
				prevY = Laya.stage.mouseY;
			});
			
			function moveSlider():void
			{
				var dy:number = Laya.stage.mouseY - prevY;
				prevY = Laya.stage.mouseY;
				volumeSlider.y += dy;
				
				if (volumeSlider.y < 8)
					volumeSlider.y = 8;
				else if (volumeSlider.y > 8 + 50)
					volumeSlider.y = 8 + 50;
					
				this.video.volume = 1 - (volumeSlider.y - 8) / 50;
				this.volumeLine.y = volumeSlider.y - 8 + 12;
				this.volumeScrollRect.y = volumeSlider.y - 8;
			}
			function endDrag():void
			{
				Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.off(Event.MOUSE_UP, this, endDrag);
			}
		}
		private createMuteButton():void 
		{
			var muteButton:Sprite = new Sprite();
			this.volumeControl.addChild(muteButton);
			muteButton.loadImage(this.MuteButtonSkin);
			muteButton.y = -(muteButton.height + 3);
			
			muteButton.on(Event.CLICK, this, function():void
			{
				this.video.muted = !this.video.muted;
			});
		}
		
		
		// 以上是UI创建

		// 创建Video
		private createVideo():void
		{
			this.video = new Video();
		
			// 检查浏览器兼容性
			if (this.video.canPlayType(Video.MP4) == Video.SUPPORT_NO && this.video.canPlayType(Video.OGG) == Video.SUPPORT_NO)
			{
				alert("当前浏览器不支持播放本视频");
			}
			
			this.video.on('loadedmetadata', this, this.onVideoReady);
			this.video.on('complete', this, this.onVideoPlayEnded);
			
			// 设置视频源
			this.video.load("../../res/av/mov_bbb.mp4");
			
			Laya.stage.addChild(this.video);
		}
		
		private onTogglePlay(e:Event):void
		{
			if (this.video.paused)
				this.play();
			else
				this.pause();
		}
		
		private play():void
		{
			this.video.play();
			this.togglePlayButton.skin = this.PauseButtonSkin;
			Laya.timer.frameLoop(1, this, this.loop);
		}
		
		private pause():void
		{
			Laya.timer.clear(this, this.loop);
			this.video.pause();
			this.togglePlayButton.skin = this.PlayButtonSkin;
		}
		
		private onVideoPlayEnded(e:Event):void
		{
			this.togglePlayButton.skin = this.PlayButtonSkin;
			Laya.timer.clear(this, this.loop);
		}
		
		private onVideoReady():void
		{
			if (this.video.readyState == 0)
				return;
				
			console.log("当前使用源：" + this.video.currentSrc);
			
			this.video.width = this.video.videoWidth;
			this.video.height = this.video.videoHeight;
			
			this.video.x = (Laya.stage.width - this.video.width) / 2;
			this.video.y = 65;
		}
		
		private loop():void
		{
			this.playProgressScrollRect.width = this.video.currentTime / this.video.duration * this.colorTimeline.width;
			this.playHeadSlider.x = 143 + this.playProgressScrollRect.width;
		}
	}
}
new laya.InputDevice_Video();
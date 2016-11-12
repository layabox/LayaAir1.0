package
{
	import laya.device.media.Video;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.ui.Button;
	import laya.utils.Handler;
	import laya.utils.Stat;
	public class InputDevice_Video
	{
		private const BackgroundSkin:String = "../../../../res/inputDevice/videoPlayer/background.png";
		private const TimeLineBoxSkin:String = "../../../../res/inputDevice/videoPlayer/time line-box.png";
		private const TimeLineSkin:String = "../../../../res/inputDevice/videoPlayer/time line.png";
		private const ColorTimelineSkin:String = "../../../../res/inputDevice/videoPlayer/color time line.png";
		private const PauseButtonSkin:String = "../../../../res/inputDevice/videoPlayer/pause button.png";
		private const PlayButtonSkin:String = "../../../../res/inputDevice/videoPlayer/play button.png";
		private const NormalSoundControlSkin:String = "../../../../res/inputDevice/videoPlayer/normal sound control.png";
		private const SoundBgControlSkin:String = "../../../../res/inputDevice/videoPlayer/sound bg.png";
		private const MuteButtonSkin:String = "../../../../res/inputDevice/videoPlayer/mute.png";
		private const VolumnLineSkin:String = "../../../../res/inputDevice/videoPlayer/light-blue.png";
		private const VolumeSliderSkin:String = "../../../../res/inputDevice/videoPlayer/volumeSlider.png";
		private const PlayHeadSliderSkin:String = "../../../../res/inputDevice/videoPlayer/playHeadSlider.png";
		
		private var video:Video;
		
		// UI
		private var togglePlayButton:Button;
		private var colorTimeline:Sprite;
		private var volumeControl:Sprite;
		private var playHeadSlider:Sprite;
		private var timelineBox:Sprite;
		private var volumeLine:Sprite;

		// 音量条和播放进度条的
		private var volumeScrollRect:Rectangle;
		private var playProgressScrollRect:Rectangle;
		
		public function InputDevice_Video()
		{
			Laya.init(650, 350);
			Stat.show();

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#FFFFFF";
			Laya.loader.load(
				[BackgroundSkin, TimeLineBoxSkin, TimeLineSkin, ColorTimelineSkin, PauseButtonSkin, PlayButtonSkin, NormalSoundControlSkin, SoundBgControlSkin, MuteButtonSkin, VolumnLineSkin, VolumeSliderSkin, PlayHeadSliderSkin], 
				Handler.create(this, setupUI));
		}
		
		// 以下是UI创建
		
		private function setupUI():void
		{
			showGUI();
			createVideo();
		}
		
		private function showGUI():void
		{
			showBackground();
			showTimelineControls();
			showSoundControl();
		}
		
		private function showBackground():void
		{
			var background:Sprite = new Sprite();
			Laya.stage.addChild(background);
			background.loadImage(BackgroundSkin);
			background.y = 25;
		}
		
		private function showTimelineControls():void
		{
			showTimelineBox();
			showPlaybackControls();
			showTimeline();
			showColorTimeline();
			showPlayHeadSlider();
		}
		
		private function showTimelineBox():void
		{
			timelineBox = new Sprite();
			Laya.stage.addChild(timelineBox);
			timelineBox.loadImage(TimeLineBoxSkin);
			timelineBox.pos(108, 280);
		}
		
		private function showPlaybackControls():void
		{
			togglePlayButton = new Button();
			togglePlayButton.skin = PlayButtonSkin;
			Laya.stage.addChild(togglePlayButton);
			togglePlayButton.pos(110, 290);
			togglePlayButton.on(Event.CLICK, this, onTogglePlay);
		}
		
		private function showTimeline():void 
		{
			var timeline:Sprite = new Sprite();
			Laya.stage.addChild(timeline);
			timeline.loadImage(TimeLineSkin);
			timeline.pos(143, 295);
		}
		
		private function showColorTimeline():void 
		{
			var texture:Texture = Loader.getRes(ColorTimelineSkin);
			colorTimeline = new Sprite();
			Laya.stage.addChild(colorTimeline);
			colorTimeline.graphics.drawTexture(texture, 0, 0);
			colorTimeline.size(texture.width, texture.height);
			colorTimeline.pos(143, 296);
			
			playProgressScrollRect = new Rectangle(0, 0, 0, 8);
			colorTimeline.scrollRect = playProgressScrollRect;
		}
		
		private var prevX:int;
		private function showPlayHeadSlider():void 
		{
			playHeadSlider = new Sprite();
			playHeadSlider.loadImage(PlayHeadSliderSkin);
			Laya.stage.addChild(playHeadSlider);
			playHeadSlider.pos(143, 292);
			playHeadSlider.pivotX = playHeadSlider.width / 2;
			
			
			timelineBox.on(Event.MOUSE_DOWN, this, function():void
			{
				if (!video.paused)
					pause();
				
				Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.on(Event.MOUSE_UP, this, endDrag);
				
				prevX = Laya.stage.mouseX;
			});
			
			function moveSlider():void
			{
				var dx:int = Laya.stage.mouseX - prevX;
				playHeadSlider.x += dx;
				prevX = Laya.stage.mouseX;
				
				if (playHeadSlider.x < 143)
					playHeadSlider.x = 143;
				else if (playHeadSlider.x > 143 + colorTimeline.width)
					playHeadSlider.x = 143 + colorTimeline.width;
					
				video.currentTime = video.duration * (playHeadSlider.x - 143) / colorTimeline.width;
				trace(video.currentTime);
				playProgressScrollRect.width = video.currentTime / video.duration * colorTimeline.width;	
			}
			function endDrag():void
			{
				Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.off(Event.MOUSE_UP, this, endDrag);
				
				play();
			}
		}
		
		private function showSoundControl():void 
		{
			showNormalSoundControl();
			createVolumeControl();
			createVolumeLine();
			createVolumeSlider();
			createMuteButton();
		}
		
		private function showNormalSoundControl():void 
		{
			var soundContorl:Sprite = new Sprite();
			Laya.stage.addChild(soundContorl);
			soundContorl.loadImage(NormalSoundControlSkin);
			soundContorl.pos(68, 280);
			soundContorl.on(Event.CLICK, this, function():void
			{
				if (volumeControl.parent)
					Laya.stage.removeChild(volumeControl);
				else
					Laya.stage.addChild(volumeControl);
			});
		}
		private function createVolumeControl():void 
		{
			volumeControl = new Sprite();
			volumeControl.loadImage(SoundBgControlSkin);
			volumeControl.pos(68, 176);
		}
		
		private function createVolumeLine():void 
		{
			volumeLine = new Sprite();
			volumeControl.addChild(volumeLine);
			volumeLine.loadImage(VolumnLineSkin);
			volumeLine.pos(15, 12);
			
			volumeScrollRect = new Rectangle(0, 0, 7, 55);
			volumeLine.scrollRect = volumeScrollRect;
		}
		
		private var prevY:int;
		private function createVolumeSlider():void 
		{
			var volumeSlider:Sprite = new Sprite();
			volumeControl.addChild(volumeSlider);
			volumeSlider.loadImage(VolumeSliderSkin);
			volumeSlider.pos(12, 8);
			
			volumeControl.on(Event.MOUSE_DOWN, this, function():void
			{
				Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.on(Event.MOUSE_UP, this, endDrag);
				
				prevY = Laya.stage.mouseY;
			});
			
			function moveSlider():void
			{
				var dy:int = Laya.stage.mouseY - prevY;
				prevY = Laya.stage.mouseY;
				volumeSlider.y += dy;
				
				if (volumeSlider.y < 8)
					volumeSlider.y = 8;
				else if (volumeSlider.y > 8 + 50)
					volumeSlider.y = 8 + 50;
					
				video.volume = 1 - (volumeSlider.y - 8) / 50;
				volumeLine.y = volumeSlider.y - 8 + 12;
				volumeScrollRect.y = volumeSlider.y - 8;
			}
			function endDrag():void
			{
				Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
				Laya.stage.off(Event.MOUSE_UP, this, endDrag);
			}
		}
		private function createMuteButton():void 
		{
			var muteButton:Sprite = new Sprite();
			volumeControl.addChild(muteButton);
			muteButton.loadImage(MuteButtonSkin);
			muteButton.y = -(muteButton.height + 3);
			
			muteButton.on(Event.CLICK, this, function():void
			{
				video.muted = !video.muted;
			});
		}
		
		
		// 以上是UI创建

		// 创建Video
		private function createVideo():void
		{
			video = new Video();
		
			// 检查浏览器兼容性
			if (video.canPlayType(Video.MP4) == Video.SUPPORT_NO && video.canPlayType(Video.OGG) == Video.SUPPORT_NO)
			{
				alert("当前浏览器不支持播放本视频");
			}
			
			video.on('loadedmetadata', this, onVideoReady);
			video.on('complete', this, onVideoPlayEnded);
			
			// 加载视频源
			video.load("../../../../res/av/mov_bbb.mp4");
			
			Laya.stage.addChild(video);
		}
		
		private function onTogglePlay(e:Event):void
		{
			if (video.paused)
				play();
			else
				pause();
		}
		
		private function play():void
		{
			video.play();
			togglePlayButton.skin = PauseButtonSkin;
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function pause():void
		{
			Laya.timer.clear(this, loop);
			video.pause();
			togglePlayButton.skin = PlayButtonSkin;
		}
		
		private function onVideoPlayEnded(e:Event):void
		{
			togglePlayButton.skin = PlayButtonSkin;
			Laya.timer.clear(this, loop);
		}
		
		private function onVideoReady():void
		{
			if (video.readyState == 0)
				return;
				
			trace("当前使用源：" + video.currentSrc);
			
			video.width = video.videoWidth;
			video.height = video.videoHeight;
			
			video.x = (Laya.stage.width - video.width) / 2;
			video.y = 65;
		}
		
		private function loop():void
		{
			playProgressScrollRect.width = video.currentTime / video.duration * colorTimeline.width;
			playHeadSlider.x = 143 + playProgressScrollRect.width;
		}
	}

}
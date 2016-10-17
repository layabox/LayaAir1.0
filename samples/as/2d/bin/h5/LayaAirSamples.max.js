
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Button=laya.ui.Button,Event=laya.events.Event,Handler=laya.utils.Handler,Loader=laya.net.Loader;
	var Rectangle=laya.maths.Rectangle,Sprite=laya.display.Sprite,Stage=laya.display.Stage,Stat=laya.utils.Stat;
	var Texture=laya.resource.Texture,Video=laya.device.media.Video;
	//class InputDevice_Video
	var InputDevice_Video=(function(){
		function InputDevice_Video(){
			this.BackgroundSkin="../../../../res/inputDevice/videoPlayer/background.png";
			this.TimeLineBoxSkin="../../../../res/inputDevice/videoPlayer/time line-box.png";
			this.TimeLineSkin="../../../../res/inputDevice/videoPlayer/time line.png";
			this.ColorTimelineSkin="../../../../res/inputDevice/videoPlayer/color time line.png";
			this.PauseButtonSkin="../../../../res/inputDevice/videoPlayer/pause button.png";
			this.PlayButtonSkin="../../../../res/inputDevice/videoPlayer/play button.png";
			this.NormalSoundControlSkin="../../../../res/inputDevice/videoPlayer/normal sound control.png";
			this.SoundBgControlSkin="../../../../res/inputDevice/videoPlayer/sound bg.png";
			this.MuteButtonSkin="../../../../res/inputDevice/videoPlayer/mute.png";
			this.VolumnLineSkin="../../../../res/inputDevice/videoPlayer/light-blue.png";
			this.VolumeSliderSkin="../../../../res/inputDevice/videoPlayer/volumeSlider.png";
			this.PlayHeadSliderSkin="../../../../res/inputDevice/videoPlayer/playHeadSlider.png";
			this.video=null;
			this.togglePlayButton=null;
			this.colorTimeline=null;
			this.volumeControl=null;
			this.playHeadSlider=null;
			this.timelineBox=null;
			this.volumeLine=null;
			this.volumeScrollRect=null;
			this.playProgressScrollRect=null;
			this.prevX=0;
			this.prevY=0;
			Laya.init(650,350);
			Stat.show();
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#FFFFFF";
			Laya.loader.load(
			[this.BackgroundSkin,this.TimeLineBoxSkin,this.TimeLineSkin,this.ColorTimelineSkin,this.PauseButtonSkin,this.PlayButtonSkin,this.NormalSoundControlSkin,this.SoundBgControlSkin,this.MuteButtonSkin,this.VolumnLineSkin,this.VolumeSliderSkin,this.PlayHeadSliderSkin],
			Handler.create(this,this.setupUI));
		}

		__class(InputDevice_Video,'InputDevice_Video');
		var __proto=InputDevice_Video.prototype;
		// 以下是UI创建
		__proto.setupUI=function(){
			this.showGUI();
			this.createVideo();
		}

		__proto.showGUI=function(){
			this.showBackground();
			this.showTimelineControls();
			this.showSoundControl();
		}

		__proto.showBackground=function(){
			var background=new Sprite();
			Laya.stage.addChild(background);
			background.loadImage(this.BackgroundSkin);
			background.y=25;
		}

		__proto.showTimelineControls=function(){
			this.showTimelineBox();
			this.showPlaybackControls();
			this.showTimeline();
			this.showColorTimeline();
			this.showPlayHeadSlider();
		}

		__proto.showTimelineBox=function(){
			this.timelineBox=new Sprite();
			Laya.stage.addChild(this.timelineBox);
			this.timelineBox.loadImage(this.TimeLineBoxSkin);
			this.timelineBox.pos(108,280);
		}

		__proto.showPlaybackControls=function(){
			this.togglePlayButton=new Button();
			this.togglePlayButton.skin=this.PlayButtonSkin;
			Laya.stage.addChild(this.togglePlayButton);
			this.togglePlayButton.pos(110,290);
			this.togglePlayButton.on("click",this,this.onTogglePlay);
		}

		__proto.showTimeline=function(){
			var timeline=new Sprite();
			Laya.stage.addChild(timeline);
			timeline.loadImage(this.TimeLineSkin);
			timeline.pos(143,295);
		}

		__proto.showColorTimeline=function(){
			var texture=Loader.getRes(this.ColorTimelineSkin);
			this.colorTimeline=new Sprite();
			Laya.stage.addChild(this.colorTimeline);
			this.colorTimeline.graphics.drawTexture(texture,0,0);
			this.colorTimeline.size(texture.width,texture.height);
			this.colorTimeline.pos(143,296);
			this.playProgressScrollRect=new Rectangle(0,0,0,8);
			this.colorTimeline.scrollRect=this.playProgressScrollRect;
		}

		__proto.showPlayHeadSlider=function(){
			var _$this=this;
			this.playHeadSlider=new Sprite();
			this.playHeadSlider.loadImage(this.PlayHeadSliderSkin);
			Laya.stage.addChild(this.playHeadSlider);
			this.playHeadSlider.pos(143,292);
			this.playHeadSlider.pivotX=this.playHeadSlider.width / 2;
			this.timelineBox.on("mousedown",this,function(){
				if (!_$this.video.paused)
					_$this.pause();
				Laya.stage.on("mousemove",this,moveSlider);
				Laya.stage.on("mouseup",this,endDrag);
				_$this.prevX=Laya.stage.mouseX;
			});
			function moveSlider (){
				var dx=Laya.stage.mouseX-_$this.prevX;
				_$this.playHeadSlider.x+=dx;
				_$this.prevX=Laya.stage.mouseX;
				if (_$this.playHeadSlider.x < 143)
					_$this.playHeadSlider.x=143;
				else if (_$this.playHeadSlider.x > 143+_$this.colorTimeline.width)
				_$this.playHeadSlider.x=143+_$this.colorTimeline.width;
				_$this.video.currentTime=_$this.video.duration *(_$this.playHeadSlider.x-143)/ _$this.colorTimeline.width;
				console.log(_$this.video.currentTime);
				_$this.playProgressScrollRect.width=_$this.video.currentTime / _$this.video.duration *_$this.colorTimeline.width;
			}
			function endDrag (){
				Laya.stage.off("mousemove",_$this,moveSlider);
				Laya.stage.off("mouseup",_$this,endDrag);
				_$this.play();
			}
		}

		__proto.showSoundControl=function(){
			this.showNormalSoundControl();
			this.createVolumeControl();
			this.createVolumeLine();
			this.createVolumeSlider();
			this.createMuteButton();
		}

		__proto.showNormalSoundControl=function(){
			var _$this=this;
			var soundContorl=new Sprite();
			Laya.stage.addChild(soundContorl);
			soundContorl.loadImage(this.NormalSoundControlSkin);
			soundContorl.pos(68,280);
			soundContorl.on("click",this,function(){
				if (_$this.volumeControl.parent)
					Laya.stage.removeChild(_$this.volumeControl);
				else
				Laya.stage.addChild(_$this.volumeControl);
			});
		}

		__proto.createVolumeControl=function(){
			this.volumeControl=new Sprite();
			this.volumeControl.loadImage(this.SoundBgControlSkin);
			this.volumeControl.pos(68,176);
		}

		__proto.createVolumeLine=function(){
			this.volumeLine=new Sprite();
			this.volumeControl.addChild(this.volumeLine);
			this.volumeLine.loadImage(this.VolumnLineSkin);
			this.volumeLine.pos(15,12);
			this.volumeScrollRect=new Rectangle(0,0,7,55);
			this.volumeLine.scrollRect=this.volumeScrollRect;
		}

		__proto.createVolumeSlider=function(){
			var _$this=this;
			var volumeSlider=new Sprite();
			this.volumeControl.addChild(volumeSlider);
			volumeSlider.loadImage(this.VolumeSliderSkin);
			volumeSlider.pos(12,8);
			this.volumeControl.on("mousedown",this,function(){
				Laya.stage.on("mousemove",this,moveSlider);
				Laya.stage.on("mouseup",this,endDrag);
				_$this.prevY=Laya.stage.mouseY;
			});
			function moveSlider (){
				var dy=Laya.stage.mouseY-_$this.prevY;
				_$this.prevY=Laya.stage.mouseY;
				volumeSlider.y+=dy;
				if (volumeSlider.y < 8)
					volumeSlider.y=8;
				else if (volumeSlider.y > 8+50)
				volumeSlider.y=8+50;
				_$this.video.volume=1-(volumeSlider.y-8)/ 50;
				_$this.volumeLine.y=volumeSlider.y-8+12;
				_$this.volumeScrollRect.y=volumeSlider.y-8;
			}
			function endDrag (){
				Laya.stage.off("mousemove",_$this,moveSlider);
				Laya.stage.off("mouseup",_$this,endDrag);
			}
		}

		__proto.createMuteButton=function(){
			var _$this=this;
			var muteButton=new Sprite();
			this.volumeControl.addChild(muteButton);
			muteButton.loadImage(this.MuteButtonSkin);
			muteButton.y=-(muteButton.height+3);
			muteButton.on("click",this,function(){
				_$this.video.muted=!_$this.video.muted;
			});
		}

		// 创建Video
		__proto.createVideo=function(){
			this.video=new Video();
			if (this.video.canPlayType(Video.MP4)==Video.SUPPORT_NO && this.video.canPlayType(Video.OGG)==Video.SUPPORT_NO){
				alert("当前浏览器不支持播放本视频");
			}
			this.video.on('loadedmetadata',this,this.onVideoReady);
			this.video.on('complete',this,this.onVideoPlayEnded);
			this.video.load("../../../../res/av/mov_bbb.mp4");
			Laya.stage.addChild(this.video);
		}

		__proto.onTogglePlay=function(e){
			if (this.video.paused)
				this.play();
			else
			this.pause();
		}

		__proto.play=function(){
			this.video.play();
			this.togglePlayButton.skin=this.PauseButtonSkin;
			Laya.timer.frameLoop(1,this,this.loop);
		}

		__proto.pause=function(){
			Laya.timer.clear(this,this.loop);
			this.video.pause();
			this.togglePlayButton.skin=this.PlayButtonSkin;
		}

		__proto.onVideoPlayEnded=function(e){
			this.togglePlayButton.skin=this.PlayButtonSkin;
			Laya.timer.clear(this,this.loop);
		}

		__proto.onVideoReady=function(){
			if (this.video.readyState==0)
				return;
			console.log("当前使用源："+this.video.currentSrc);
			this.video.width=this.video.videoWidth;
			this.video.height=this.video.videoHeight;
			this.video.x=(Laya.stage.width-this.video.width)/ 2;
			this.video.y=65;
		}

		__proto.loop=function(){
			this.playProgressScrollRect.width=this.video.currentTime / this.video.duration *this.colorTimeline.width;
			this.playHeadSlider.x=143+this.playProgressScrollRect.width;
		}

		return InputDevice_Video;
	})()



	new InputDevice_Video();

})(window,document,Laya);

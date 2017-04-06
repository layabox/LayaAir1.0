(function()
{
	var Sprite = Laya.Sprite;
	var Stage = Laya.Stage;
	var Text = Laya.Text;
	var Event = Laya.Event;
	var Video = Laya.Video;
	var Rectangle = Laya.Rectangle;
	var Loader = Laya.Loader;
	var Render = Laya.Render;
	var Texture = Laya.Texture;
	var Button = Laya.Button;
	var HSlider = Laya.HSlider;
	var Slider = Laya.Slider;
	var TextInput = Laya.TextInput;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;
	var StringKey = Laya.StringKey;

	var BackgroundSkin = "../../res/inputDevice/videoPlayer/background.png";
	var TimeLineBoxSkin = "../../res/inputDevice/videoPlayer/time line-box.png";
	var TimeLineSkin = "../../res/inputDevice/videoPlayer/time line.png";
	var ColorTimelineSkin = "../../res/inputDevice/videoPlayer/color time line.png";
	var PauseButtonSkin = "../../res/inputDevice/videoPlayer/pause button.png";
	var PlayButtonSkin = "../../res/inputDevice/videoPlayer/play button.png";
	var NormalSoundControlSkin = "../../res/inputDevice/videoPlayer/normal sound control.png";
	var SoundBgControlSkin = "../../res/inputDevice/videoPlayer/sound bg.png";
	var MuteButtonSkin = "../../res/inputDevice/videoPlayer/mute.png";
	var VolumnLineSkin = "../../res/inputDevice/videoPlayer/light-blue.png";
	var VolumeSliderSkin = "../../res/inputDevice/videoPlayer/volumeSlider.png";
	var PlayHeadSliderSkin = "../../res/inputDevice/videoPlayer/playHeadSlider.png";

	var video;

	// UI
	var togglePlayButton;
	var colorTimeline;
	var volumeControl;
	var playHeadSlider;
	var timelineBox;
	var volumeLine;

	// 音量条和播放进度条的
	var volumeScrollRect;
	var playProgressScrollRect;
	(function()
	{
		Laya.init(650, 350, Laya.WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#FFFFFF";

		Laya.loader.load(
			[BackgroundSkin, TimeLineBoxSkin, TimeLineSkin, ColorTimelineSkin, PauseButtonSkin, PlayButtonSkin, NormalSoundControlSkin, SoundBgControlSkin, MuteButtonSkin, VolumnLineSkin, VolumeSliderSkin, PlayHeadSliderSkin],
			Handler.create(this, setupUI));
	})();
	// 以下是UI创建
	function setupUI()
	{
		showGUI();
		createVideo();
	}

	function showGUI()
	{
		showBackground();
		showTimelineControls();
		showSoundControl();
	}

	function showBackground()
	{
		var background = new Sprite();
		Laya.stage.addChild(background);
		background.loadImage(BackgroundSkin);
		background.y = 25;
	}

	function showTimelineControls()
	{
		showTimelineBox();
		showPlaybackControls();
		showTimeline();
		showColorTimeline();
		showPlayHeadSlider();
	}

	function showTimelineBox()
	{
		timelineBox = new Sprite();
		Laya.stage.addChild(timelineBox);
		timelineBox.loadImage(TimeLineBoxSkin);
		timelineBox.pos(108, 280);
	}

	function showPlaybackControls()
	{
		togglePlayButton = new Button();
		togglePlayButton.skin = PlayButtonSkin;
		Laya.stage.addChild(togglePlayButton);
		togglePlayButton.pos(110, 290);
		togglePlayButton.on(Event.CLICK, this, onTogglePlay);
	}

	function showTimeline()
	{
		var timeline = new Sprite();
		Laya.stage.addChild(timeline);
		timeline.loadImage(TimeLineSkin);
		timeline.pos(143, 295);
	}

	function showColorTimeline()
	{
		var texture = Loader.getRes(ColorTimelineSkin);
		colorTimeline = new Sprite();
		Laya.stage.addChild(colorTimeline);
		colorTimeline.graphics.drawTexture(texture, 0, 0);
		colorTimeline.size(texture.width, texture.height);
		colorTimeline.pos(143, 296);

		playProgressScrollRect = new Rectangle(0, 0, 0, 8);
		colorTimeline.scrollRect = playProgressScrollRect;
	}

	function showPlayHeadSlider()
	{
		playHeadSlider = new Sprite();
		playHeadSlider.loadImage(PlayHeadSliderSkin);
		Laya.stage.addChild(playHeadSlider);
		playHeadSlider.pos(143, 292);
		playHeadSlider.pivotX = playHeadSlider.width / 2;

		var prevX;
		timelineBox.on(Event.MOUSE_DOWN, this, function()
		{
			if (!video.paused)
				pause();

			Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
			Laya.stage.on(Event.MOUSE_UP, this, endDrag);

			prevX = Laya.stage.mouseX;
		});

		function moveSlider()
		{
			var dx = Laya.stage.mouseX - prevX;
			playHeadSlider.x += dx;
			prevX = Laya.stage.mouseX;

			if (playHeadSlider.x < 143)
				playHeadSlider.x = 143;
			else if (playHeadSlider.x > 143 + colorTimeline.width)
				playHeadSlider.x = 143 + colorTimeline.width;

			video.currentTime = video.duration * (playHeadSlider.x - 143) / colorTimeline.width;
			console.log(video.currentTime);
			playProgressScrollRect.width = video.currentTime / video.duration * colorTimeline.width;
		}

		function endDrag()
		{
			Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
			Laya.stage.off(Event.MOUSE_UP, this, endDrag);

			play();
		}
	}

	function showSoundControl()
	{
		showNormalSoundControl();
		createVolumeControl();
		createVolumeLine();
		createVolumeSlider();
		createMuteButton();
	}

	function showNormalSoundControl()
	{
		var soundContorl = new Sprite();
		Laya.stage.addChild(soundContorl);
		soundContorl.loadImage(NormalSoundControlSkin);
		soundContorl.pos(68, 280);
		soundContorl.on(Event.CLICK, this, function()
		{
			if (volumeControl.parent)
				Laya.stage.removeChild(volumeControl);
			else
				Laya.stage.addChild(volumeControl);
		});
	}

	function createVolumeControl()
	{
		volumeControl = new Sprite();
		volumeControl.loadImage(SoundBgControlSkin);
		volumeControl.pos(68, 176);
	}

	function createVolumeLine()
	{
		volumeLine = new Sprite();
		volumeControl.addChild(volumeLine);
		volumeLine.loadImage(VolumnLineSkin);
		volumeLine.pos(15, 12);

		volumeScrollRect = new Rectangle(0, 0, 7, 55);
		volumeLine.scrollRect = volumeScrollRect;
	}

	function createVolumeSlider()
	{
		var volumeSlider = new Sprite();
		volumeControl.addChild(volumeSlider);
		volumeSlider.loadImage(VolumeSliderSkin);
		volumeSlider.pos(12, 8);

		var prevY;
		volumeControl.on(Event.MOUSE_DOWN, this, function()
		{
			Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
			Laya.stage.on(Event.MOUSE_UP, this, endDrag);

			prevY = Laya.stage.mouseY;
		});

		function moveSlider()
		{
			var dy = Laya.stage.mouseY - prevY;
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

		function endDrag()
		{
			Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
			Laya.stage.off(Event.MOUSE_UP, this, endDrag);
		}
	}

	function createMuteButton()
	{
		var muteButton = new Sprite();
		volumeControl.addChild(muteButton);
		muteButton.loadImage(MuteButtonSkin);
		muteButton.y = -(muteButton.height + 3);

		muteButton.on(Event.CLICK, this, function()
		{
			video.muted = !video.muted;
		});
	}


	// 以上是UI创建

	// 创建Video
	function createVideo()
	{
		video = new Video();

		// 检查浏览器兼容性
		if (video.canPlayType(Video.MP4) == Video.SUPPORT_NO && video.canPlayType(Video.OGG) == Video.SUPPORT_NO)
		{
			alert("当前浏览器不支持播放本视频");
		}

		video.on('loadedmetadata', this, onVideoReady);
		video.on('ended', this, onVideoPlayEnded);

		// 加载视频源
		video.load("../../res/av/mov_bbb.mp4");

		Laya.stage.addChild(video);
	}

	function onTogglePlay(e)
	{
		if (video.paused)
			play();
		else
			pause();
	}

	function play()
	{
		video.play();
		togglePlayButton.skin = PauseButtonSkin;
		Laya.timer.frameLoop(1, this, loop);
	}

	function pause()
	{
		Laya.timer.clear(this, loop);
		video.pause();
		togglePlayButton.skin = PlayButtonSkin;
	}

	function onVideoPlayEnded(e)
	{
		togglePlayButton.skin = PlayButtonSkin;
		Laya.timer.clear(this, loop);
	}

	function onVideoReady()
	{
		if (video.readyState == 0)
			return;

		console.log("当前使用源：" + video.currentSrc);

		video.width = video.videoWidth;
		video.height = video.videoHeight;

		video.x = (Laya.stage.width - video.width) / 2;
		video.y = 65;
	}

	function loop()
	{
		playProgressScrollRect.width = video.currentTime / video.duration * colorTimeline.width;
		playHeadSlider.x = 143 + playProgressScrollRect.width;
	}
})();
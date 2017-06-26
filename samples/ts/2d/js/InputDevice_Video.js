var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Sprite = Laya.Sprite;
    var Event = Laya.Event;
    var Video = Laya.Video;
    var Rectangle = Laya.Rectangle;
    var Loader = Laya.Loader;
    var Button = Laya.Button;
    var Handler = Laya.Handler;
    var InputDevice_Video = (function () {
        function InputDevice_Video() {
            this.BackgroundSkin = "../../res/inputDevice/videoPlayer/background.png";
            this.TimeLineBoxSkin = "../../res/inputDevice/videoPlayer/time line-box.png";
            this.TimeLineSkin = "../../res/inputDevice/videoPlayer/time line.png";
            this.ColorTimelineSkin = "../../res/inputDevice/videoPlayer/color time line.png";
            this.PauseButtonSkin = "../../res/inputDevice/videoPlayer/pause button.png";
            this.PlayButtonSkin = "../../res/inputDevice/videoPlayer/play button.png";
            this.NormalSoundControlSkin = "../../res/inputDevice/videoPlayer/normal sound control.png";
            this.SoundBgControlSkin = "../../res/inputDevice/videoPlayer/sound bg.png";
            this.MuteButtonSkin = "../../res/inputDevice/videoPlayer/mute.png";
            this.VolumnLineSkin = "../../res/inputDevice/videoPlayer/light-blue.png";
            this.VolumeSliderSkin = "../../res/inputDevice/videoPlayer/volumeSlider.png";
            this.PlayHeadSliderSkin = "../../res/inputDevice/videoPlayer/playHeadSlider.png";
            Laya.init(650, 350);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#FFFFFF";
            Laya.loader.load([this.BackgroundSkin, this.TimeLineBoxSkin, this.TimeLineSkin, this.ColorTimelineSkin, this.PauseButtonSkin, this.PlayButtonSkin, this.NormalSoundControlSkin, this.SoundBgControlSkin, this.MuteButtonSkin, this.VolumnLineSkin, this.VolumeSliderSkin, this.PlayHeadSliderSkin], Handler.create(this, this.setupUI));
        }
        // 以下是UI创建
        InputDevice_Video.prototype.setupUI = function () {
            this.showGUI();
            this.createVideo();
        };
        InputDevice_Video.prototype.showGUI = function () {
            this.showBackground();
            this.showTimelineControls();
            this.showSoundControl();
        };
        InputDevice_Video.prototype.showBackground = function () {
            var background = new Sprite();
            Laya.stage.addChild(background);
            background.loadImage(this.BackgroundSkin);
            background.y = 25;
        };
        InputDevice_Video.prototype.showTimelineControls = function () {
            this.showTimelineBox();
            this.showPlaybackControls();
            this.showTimeline();
            this.showColorTimeline();
            this.showPlayHeadSlider();
        };
        InputDevice_Video.prototype.showTimelineBox = function () {
            this.timelineBox = new Sprite();
            Laya.stage.addChild(this.timelineBox);
            this.timelineBox.loadImage(this.TimeLineBoxSkin);
            this.timelineBox.pos(108, 280);
        };
        InputDevice_Video.prototype.showPlaybackControls = function () {
            this.togglePlayButton = new Button();
            this.togglePlayButton.skin = this.PlayButtonSkin;
            Laya.stage.addChild(this.togglePlayButton);
            this.togglePlayButton.pos(110, 290);
            this.togglePlayButton.on(Event.CLICK, this, this.onTogglePlay);
        };
        InputDevice_Video.prototype.showTimeline = function () {
            var timeline = new Sprite();
            Laya.stage.addChild(timeline);
            timeline.loadImage(this.TimeLineSkin);
            timeline.pos(143, 295);
        };
        InputDevice_Video.prototype.showColorTimeline = function () {
            var texture = Loader.getRes(this.ColorTimelineSkin);
            this.colorTimeline = new Sprite();
            Laya.stage.addChild(this.colorTimeline);
            this.colorTimeline.graphics.drawTexture(texture, 0, 0);
            this.colorTimeline.size(texture.width, texture.height);
            this.colorTimeline.pos(143, 296);
            this.playProgressScrollRect = new Rectangle(0, 0, 0, 8);
            this.colorTimeline.scrollRect = this.playProgressScrollRect;
        };
        InputDevice_Video.prototype.showPlayHeadSlider = function () {
            this.playHeadSlider = new Sprite();
            this.playHeadSlider.loadImage(this.PlayHeadSliderSkin);
            Laya.stage.addChild(this.playHeadSlider);
            this.playHeadSlider.pos(143, 292);
            this.playHeadSlider.pivotX = this.playHeadSlider.width / 2;
            var prevX;
            this.timelineBox.on(Event.MOUSE_DOWN, this, function () {
                if (!this.video.paused)
                    this.pause();
                Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
                Laya.stage.on(Event.MOUSE_UP, this, endDrag);
                prevX = Laya.stage.mouseX;
            });
            function moveSlider() {
                var dx = Laya.stage.mouseX - prevX;
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
            function endDrag() {
                Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
                Laya.stage.off(Event.MOUSE_UP, this, endDrag);
                this.play();
            }
        };
        InputDevice_Video.prototype.showSoundControl = function () {
            this.showNormalSoundControl();
            this.createVolumeControl();
            this.createVolumeLine();
            this.createVolumeSlider();
            this.createMuteButton();
        };
        InputDevice_Video.prototype.showNormalSoundControl = function () {
            var soundContorl = new Sprite();
            Laya.stage.addChild(soundContorl);
            soundContorl.loadImage(this.NormalSoundControlSkin);
            soundContorl.pos(68, 280);
            soundContorl.on(Event.CLICK, this, function () {
                if (this.volumeControl.parent)
                    Laya.stage.removeChild(this.volumeControl);
                else
                    Laya.stage.addChild(this.volumeControl);
            });
        };
        InputDevice_Video.prototype.createVolumeControl = function () {
            this.volumeControl = new Sprite();
            this.volumeControl.loadImage(this.SoundBgControlSkin);
            this.volumeControl.pos(68, 176);
        };
        InputDevice_Video.prototype.createVolumeLine = function () {
            this.volumeLine = new Sprite();
            this.volumeControl.addChild(this.volumeLine);
            this.volumeLine.loadImage(this.VolumnLineSkin);
            this.volumeLine.pos(15, 12);
            this.volumeScrollRect = new Rectangle(0, 0, 7, 55);
            this.volumeLine.scrollRect = this.volumeScrollRect;
        };
        InputDevice_Video.prototype.createVolumeSlider = function () {
            var volumeSlider = new Sprite();
            this.volumeControl.addChild(volumeSlider);
            volumeSlider.loadImage(this.VolumeSliderSkin);
            volumeSlider.pos(12, 8);
            var prevY;
            this.volumeControl.on(Event.MOUSE_DOWN, this, function () {
                Laya.stage.on(Event.MOUSE_MOVE, this, moveSlider);
                Laya.stage.on(Event.MOUSE_UP, this, endDrag);
                prevY = Laya.stage.mouseY;
            });
            function moveSlider() {
                var dy = Laya.stage.mouseY - prevY;
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
            function endDrag() {
                Laya.stage.off(Event.MOUSE_MOVE, this, moveSlider);
                Laya.stage.off(Event.MOUSE_UP, this, endDrag);
            }
        };
        InputDevice_Video.prototype.createMuteButton = function () {
            var muteButton = new Sprite();
            this.volumeControl.addChild(muteButton);
            muteButton.loadImage(this.MuteButtonSkin);
            muteButton.y = -(muteButton.height + 3);
            muteButton.on(Event.CLICK, this, function () {
                this.video.muted = !this.video.muted;
            });
        };
        // 以上是UI创建
        // 创建Video
        InputDevice_Video.prototype.createVideo = function () {
            this.video = new Video();
            // 检查浏览器兼容性
            if (this.video.canPlayType(Video.MP4) == Video.SUPPORT_NO && this.video.canPlayType(Video.OGG) == Video.SUPPORT_NO) {
                alert("当前浏览器不支持播放本视频");
            }
            this.video.on('loadedmetadata', this, this.onVideoReady);
            this.video.on('ended', this, this.onVideoPlayEnded);
            // 设置视频源
            this.video.load("../../res/av/mov_bbb.mp4");
            Laya.stage.addChild(this.video);
        };
        InputDevice_Video.prototype.onTogglePlay = function (e) {
            if (this.video.paused)
                this.play();
            else
                this.pause();
        };
        InputDevice_Video.prototype.play = function () {
            this.video.play();
            this.togglePlayButton.skin = this.PauseButtonSkin;
            Laya.timer.frameLoop(1, this, this.loop);
        };
        InputDevice_Video.prototype.pause = function () {
            Laya.timer.clear(this, this.loop);
            this.video.pause();
            this.togglePlayButton.skin = this.PlayButtonSkin;
        };
        InputDevice_Video.prototype.onVideoPlayEnded = function (e) {
            this.togglePlayButton.skin = this.PlayButtonSkin;
            Laya.timer.clear(this, this.loop);
        };
        InputDevice_Video.prototype.onVideoReady = function () {
            if (this.video.readyState == 0)
                return;
            console.log("当前使用源：" + this.video.currentSrc);
            this.video.width = this.video.videoWidth;
            this.video.height = this.video.videoHeight;
            this.video.x = (Laya.stage.width - this.video.width) / 2;
            this.video.y = 65;
        };
        InputDevice_Video.prototype.loop = function () {
            this.playProgressScrollRect.width = this.video.currentTime / this.video.duration * this.colorTimeline.width;
            this.playHeadSlider.x = 143 + this.playProgressScrollRect.width;
        };
        return InputDevice_Video;
    }());
    laya.InputDevice_Video = InputDevice_Video;
})(laya || (laya = {}));
new laya.InputDevice_Video();

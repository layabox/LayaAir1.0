var laya;
(function (laya) {
    var Media = Laya.Media;
    var Video = Laya.Video;
    var Text = Laya.Text;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    /**
     * ...
     * @author Survivor
     */
    var InputDevice_Media = (function () {
        function InputDevice_Media() {
            Laya.init(Browser.width, Browser.height);
            if (Media.supported() === false)
                alert("当前浏览器不支持");
            else {
                this.showMessage();
                var options = {
                    audio: true,
                    video: {
                        facingMode: { exact: "environment" },
                        width: Laya.stage.width,
                        height: Laya.stage.height
                    }
                };
                Media.getMedia(options, Handler.create(this, this.onSuccess), Handler.create(this, this.onError));
            }
        }
        InputDevice_Media.prototype.showMessage = function () {
            var text = new Text();
            Laya.stage.addChild(text);
            text.text = "单击舞台播放和暂停";
            text.color = "#FFFFFF";
            text.fontSize = 100;
            text.valign = "middle";
            text.align = "center";
            text.size(Laya.stage.width, Laya.stage.height);
        };
        InputDevice_Media.prototype.onSuccess = function (url) {
            this.video = new Video(Laya.stage.width, Laya.stage.height);
            this.video.load(url);
            Laya.stage.addChild(this.video);
            Laya.stage.on('click', this, this.onStageClick);
        };
        InputDevice_Media.prototype.onError = function (error) {
            alert(error.message);
        };
        InputDevice_Media.prototype.onStageClick = function () {
            // 切换播放和暂停。
            if (!this.video.paused)
                this.video.pause();
            else
                this.video.play();
        };
        return InputDevice_Media;
    }());
    laya.InputDevice_Media = InputDevice_Media;
})(laya || (laya = {}));
new laya.InputDevice_Media();

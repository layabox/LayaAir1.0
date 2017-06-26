var laya;
(function (laya) {
    var Media = Laya.Media;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    /**
     * ...
     * @author Survivor
     */
    var InputDevice_Media = (function () {
        function InputDevice_Media() {
            if (Media.supported() === false)
                alert("当前浏览器不支持");
            else {
                var options = {
                    audio: true,
                    video: {
                        width: Browser.width,
                        height: Browser.height
                    }
                };
                Media.getMedia(options, Handler.create(this, this.onSuccess), Handler.create(this, this.onError));
            }
        }
        InputDevice_Media.prototype.onSuccess = function (url) {
            var video = Browser.document.createElement("video");
            video.width = Browser.clientWidth;
            video.height = Browser.clientHeight;
            video.style.zIndex = 1E5;
            Browser.document.body.appendChild(video);
            video.controls = true;
            video.src = url;
            video.play();
        };
        InputDevice_Media.prototype.onError = function (error) {
            alert(error.message);
        };
        return InputDevice_Media;
    }());
    laya.InputDevice_Media = InputDevice_Media;
})(laya || (laya = {}));
new laya.InputDevice_Media();

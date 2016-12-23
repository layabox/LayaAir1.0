var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Event = Laya.Event;
    var HttpRequest = Laya.HttpRequest;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Network_GET = (function () {
        function Network_GET() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.connect();
            this.showLogger();
        }
        Network_GET.prototype.connect = function () {
            this.hr = new HttpRequest();
            this.hr.once(Event.PROGRESS, this, this.onHttpRequestProgress);
            this.hr.once(Event.COMPLETE, this, this.onHttpRequestComplete);
            this.hr.once(Event.ERROR, this, this.onHttpRequestError);
            this.hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');
        };
        Network_GET.prototype.showLogger = function () {
            this.logger = new Text();
            this.logger.fontSize = 30;
            this.logger.color = "#FFFFFF";
            this.logger.align = 'center';
            this.logger.valign = 'middle';
            this.logger.size(Laya.stage.width, Laya.stage.height);
            this.logger.text = "等待响应...\n";
            Laya.stage.addChild(this.logger);
        };
        Network_GET.prototype.onHttpRequestError = function (e) {
            console.log(e);
        };
        Network_GET.prototype.onHttpRequestProgress = function (e) {
            console.log(e);
        };
        Network_GET.prototype.onHttpRequestComplete = function (e) {
            this.logger.text += "收到数据：" + this.hr.data;
        };
        return Network_GET;
    }());
    laya.Network_GET = Network_GET;
})(laya || (laya = {}));
new laya.Network_GET();

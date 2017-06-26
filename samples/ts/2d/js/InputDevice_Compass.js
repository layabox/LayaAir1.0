var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Gyroscope = Laya.Gyroscope;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Event = Laya.Event;
    var InputDevice_Compasss = (function () {
        function InputDevice_Compasss() {
            this.compassImgPath = "../../res/inputDevice/kd.png";
            this.firstTime = true;
            Laya.init(700, 1024, WebGL);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.loader.load(this.compassImgPath, Handler.create(this, this.init));
        }
        InputDevice_Compasss.prototype.init = function () {
            // 创建罗盘
            this.createCompass();
            // 创建方位指示器
            this.createDirectionIndicator();
            // 画出其他UI
            this.drawUI();
            // 创建显示角度的文本
            this.createDegreesText();
            Gyroscope.instance.on(Event.CHANGE, this, this.onOrientationChange);
        };
        InputDevice_Compasss.prototype.createCompass = function () {
            this.compassImg = new Sprite();
            Laya.stage.addChild(this.compassImg);
            this.compassImg.loadImage(this.compassImgPath);
            this.compassImg.pivot(this.compassImg.width / 2, this.compassImg.height / 2);
            this.compassImg.pos(Laya.stage.width / 2, 400);
        };
        InputDevice_Compasss.prototype.drawUI = function () {
            var canvas = new Sprite();
            Laya.stage.addChild(canvas);
            canvas.graphics.drawLine(this.compassImg.x, 50, this.compassImg.x, 182, "#FFFFFF", 3);
            canvas.graphics.drawLine(-140 + this.compassImg.x, this.compassImg.y, 140 + this.compassImg.x, this.compassImg.y, "#AAAAAA", 1);
            canvas.graphics.drawLine(this.compassImg.x, -140 + this.compassImg.y, this.compassImg.x, 140 + this.compassImg.y, "#AAAAAA", 1);
        };
        InputDevice_Compasss.prototype.createDegreesText = function () {
            this.degreesText = new Text();
            Laya.stage.addChild(this.degreesText);
            this.degreesText.align = "center";
            this.degreesText.size(Laya.stage.width, 100);
            this.degreesText.pos(0, this.compassImg.y + 400);
            this.degreesText.fontSize = 100;
            this.degreesText.color = "#FFFFFF";
        };
        // 方位指示器指向当前所朝方位。
        InputDevice_Compasss.prototype.createDirectionIndicator = function () {
            this.directionIndicator = new Sprite();
            Laya.stage.addChild(this.directionIndicator);
            this.directionIndicator.alpha = 0.8;
            this.directionIndicator.graphics.drawCircle(0, 0, 70, "#343434");
            this.directionIndicator.graphics.drawLine(-40, 0, 40, 0, "#FFFFFF", 3);
            this.directionIndicator.graphics.drawLine(0, -40, 0, 40, "#FFFFFF", 3);
            this.directionIndicator.x = this.compassImg.x;
            this.directionIndicator.y = this.compassImg.y;
        };
        InputDevice_Compasss.prototype.onOrientationChange = function (absolute, info) {
            if (info.alpha === null) {
                alert("当前设备不支持陀螺仪。");
            }
            else if (this.firstTime && !absolute && !Browser.onIOS) {
                this.firstTime = false;
                alert("在当前设备中无法获取地球坐标系，使用设备坐标系，你可以继续观赏，但是提供的方位并非正确方位。");
            }
            // 更新角度显示
            this.degreesText.text = 360 - Math.floor(info.alpha) + "°";
            this.compassImg.rotation = info.alpha;
            // 更新方位指示器
            this.directionIndicator.x = -1 * Math.floor(info.gamma) / 90 * 70 + this.compassImg.x;
            this.directionIndicator.y = -1 * Math.floor(info.beta) / 90 * 70 + this.compassImg.y;
        };
        return InputDevice_Compasss;
    }());
    laya.InputDevice_Compasss = InputDevice_Compasss;
})(laya || (laya = {}));
new laya.InputDevice_Compasss();

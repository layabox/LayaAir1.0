var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Image = Laya.Image;
    var WebGL = Laya.WebGL;
    var SmartScale_T = (function () {
        function SmartScale_T() {
            //所有适配模式
            this.modes = ["noscale", "exactfit", "showall", "noborder", "full", "fixedwidth", "fixedheight"];
            //当前适配模式索引
            this.index = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(1136, 640, WebGL);
            //设置适配模式
            Laya.stage.scaleMode = "noscale";
            //设置横竖屏
            Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
            //设置水平对齐
            Laya.stage.alignH = "center";
            //设置垂直对齐
            Laya.stage.alignV = "middle";
            //实例一个背景
            var bg = new Image();
            bg.skin = "../../res/bg.jpg";
            Laya.stage.addChild(bg);
            //实例一个文本
            this.txt = new Text();
            this.txt.text = "点击我切换适配模式(noscale)";
            this.txt.bold = true;
            this.txt.pos(0, 200);
            this.txt.fontSize = 30;
            this.txt.on("click", this, this.onTxtClick);
            Laya.stage.addChild(this.txt);
            //实例一个小人，放到右上角，并相对布局
            var boy1 = new Image();
            boy1.skin = "../../res/cartoonCharacters/1.png";
            boy1.top = 0;
            boy1.right = 0;
            boy1.on("click", this, this.onBoyClick);
            Laya.stage.addChild(boy1);
            //实例一个小人，放到右下角，并相对布局
            var boy2 = new Image();
            boy2.skin = "../../res/cartoonCharacters/2.png";
            boy2.bottom = 0;
            boy2.right = 0;
            boy2.on("click", this, this.onBoyClick);
            Laya.stage.addChild(boy2);
            //侦听点击事件，输出坐标信息
            Laya.stage.on("click", this, this.onClick);
            Laya.stage.on("resize", this, this.onResize);
        }
        SmartScale_T.prototype.onBoyClick = function (e) {
            //点击后小人会放大缩小
            var boy = e.target;
            if (boy.scaleX === 1) {
                boy.scale(1.2, 1.2);
            }
            else {
                boy.scale(1, 1);
            }
        };
        SmartScale_T.prototype.onTxtClick = function (e) {
            //点击后切换适配模式
            e.stopPropagation();
            this.index++;
            if (this.index >= this.modes.length)
                this.index = 0;
            Laya.stage.scaleMode = this.modes[this.index];
            this.txt.text = "点击我切换适配模式" + "(" + this.modes[this.index] + ")";
        };
        SmartScale_T.prototype.onClick = function (e) {
            //输出坐标信息
            console.log("mouse:", Laya.stage.mouseX, Laya.stage.mouseY);
        };
        SmartScale_T.prototype.onResize = function () {
            //输出当前适配模式下的stage大小
            console.log("size:", Laya.stage.width, Laya.stage.height);
        };
        return SmartScale_T;
    }());
    laya.SmartScale_T = SmartScale_T;
})(laya || (laya = {}));
new laya.SmartScale_T();

var laya;
(function (laya) {
    var Input = Laya.Input;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var WebGL = Laya.WebGL;
    var Text_Restrict = (function () {
        function Text_Restrict() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 300, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createTexts();
        }
        Text_Restrict.prototype.createTexts = function () {
            this.createLabel("只允许输入数字：").pos(50, 20);
            var input = this.createInput();
            input.pos(50, 50);
            input.restrict = "0-9";
            this.createLabel("只允许输入字母：").pos(50, 100);
            input = this.createInput();
            input.pos(50, 130);
            input.restrict = "a-zA-Z";
            this.createLabel("只允许输入中文字符：").pos(50, 180);
            input = this.createInput();
            input.pos(50, 210);
            input.restrict = "\u4e00-\u9fa5";
        };
        Text_Restrict.prototype.createLabel = function (text) {
            var label = new Text();
            label.text = text;
            label.color = "white";
            label.fontSize = 20;
            Laya.stage.addChild(label);
            return label;
        };
        Text_Restrict.prototype.createInput = function () {
            var input = new Input();
            input.size(200, 30);
            input.borderColor = "#FFFF00";
            input.bold = true;
            input.fontSize = 20;
            input.color = "#FFFFFF";
            input.padding = [0, 4, 0, 4];
            Laya.stage.addChild(input);
            return input;
        };
        return Text_Restrict;
    }());
    laya.Text_Restrict = Text_Restrict;
})(laya || (laya = {}));
new laya.Text_Restrict();

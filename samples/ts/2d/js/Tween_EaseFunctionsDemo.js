var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var laya;
(function (laya) {
    var Input = Laya.Input;
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Event = Laya.Event;
    var List = Laya.List;
    var Ease = Laya.Ease;
    var Handler = Laya.Handler;
    var Tween = Laya.Tween;
    var WebGL = Laya.WebGL;
    var Tween_EaseFunctionsDemo = (function () {
        function Tween_EaseFunctionsDemo() {
            this.duration = 2000;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Tween_EaseFunctionsDemo.prototype.setup = function () {
            this.createCharacter();
            this.createEaseFunctionList();
            this.createDurationCrontroller();
        };
        Tween_EaseFunctionsDemo.prototype.createCharacter = function () {
            this.character = new Sprite();
            this.character.loadImage("../../res/cartoonCharacters/1.png");
            this.character.pos(100, 50);
            Laya.stage.addChild(this.character);
        };
        Tween_EaseFunctionsDemo.prototype.createEaseFunctionList = function () {
            var easeFunctionsList = new List();
            easeFunctionsList.itemRender = ListItemRender;
            easeFunctionsList.pos(5, 5);
            easeFunctionsList.repeatX = 1;
            easeFunctionsList.repeatY = 20;
            easeFunctionsList.vScrollBarSkin = '';
            easeFunctionsList.selectEnable = true;
            easeFunctionsList.selectHandler = new Handler(this, this.onEaseFunctionChange, [easeFunctionsList]);
            easeFunctionsList.renderHandler = new Handler(this, this.renderList);
            Laya.stage.addChild(easeFunctionsList);
            var data = [];
            data.push('backIn', 'backOut', 'backInOut');
            data.push('bounceIn', 'bounceOut', 'bounceInOut');
            data.push('circIn', 'circOut', 'circInOut');
            data.push('cubicIn', 'cubicOut', 'cubicInOut');
            data.push('elasticIn', 'elasticOut', 'elasticInOut');
            data.push('expoIn', 'expoOut', 'expoInOut');
            data.push('linearIn', 'linearOut', 'linearInOut');
            data.push('linearNone');
            data.push('QuadIn', 'QuadOut', 'QuadInOut');
            data.push('quartIn', 'quartOut', 'quartInOut');
            data.push('quintIn', 'quintOut', 'quintInOut');
            data.push('sineIn', 'sineOut', 'sineInOut');
            data.push('strongIn', 'strongOut', 'strongInOut');
            easeFunctionsList.array = data;
        };
        Tween_EaseFunctionsDemo.prototype.renderList = function (item) {
            item.setLabel(item.dataSource);
        };
        Tween_EaseFunctionsDemo.prototype.onEaseFunctionChange = function (list) {
            this.character.pos(100, 50);
            this.tween && this.tween.clear();
            this.tween = Tween.to(this.character, { x: 350, y: 250 }, this.duration, Ease[list.selectedItem]);
        };
        Tween_EaseFunctionsDemo.prototype.createDurationCrontroller = function () {
            var durationInput = this.createInputWidthLabel("Duration:", '2000', 400, 10);
            durationInput.on(Event.INPUT, this, function () {
                this.duration = parseInt(durationInput.text);
            });
        };
        Tween_EaseFunctionsDemo.prototype.createInputWidthLabel = function (label, prompt, x, y) {
            var text = new Text();
            text.text = label;
            text.color = "white";
            Laya.stage.addChild(text);
            text.pos(x, y);
            var input = new Input();
            input.size(50, 20);
            input.text = prompt;
            input.align = 'center';
            Laya.stage.addChild(input);
            input.color = "#FFFFFF";
            input.borderColor = "#FFFFFF";
            input.pos(text.x + text.width + 10, text.y - 3);
            input.inputElementYAdjuster = 1;
            return input;
        };
        return Tween_EaseFunctionsDemo;
    }());
    laya.Tween_EaseFunctionsDemo = Tween_EaseFunctionsDemo;
})(laya || (laya = {}));
var ListItemRender = (function (_super) {
    __extends(ListItemRender, _super);
    function ListItemRender() {
        _super.call(this);
        this.size(100, 20);
        this.label = new Label();
        this.label.fontSize = 12;
        this.label.color = "#FFFFFF";
        this.addChild(this.label);
    }
    ListItemRender.prototype.setLabel = function (value) {
        this.label.text = value;
    };
    return ListItemRender;
}(Box));
new laya.Tween_EaseFunctionsDemo();

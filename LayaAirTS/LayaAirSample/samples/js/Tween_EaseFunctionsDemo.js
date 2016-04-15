var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Sprite = laya.display.Sprite;
    var Event = laya.events.Event;
    var List = laya.ui.List;
    var Ease = laya.utils.Ease;
    var Handler = laya.utils.Handler;
    var Tween = laya.utils.Tween;
    var EaseFunctionsDemo = (function () {
        function EaseFunctionsDemo() {
            this.duration = 2000;
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#3D3D3D";
            Laya.loader.load("res/ui/vscroll.png", Handler.create(this, this.init));
        }
        EaseFunctionsDemo.prototype.init = function () {
            this.createCharacter();
            this.createEaseFunctionList();
            this.createDurationCrontroller();
        };
        EaseFunctionsDemo.prototype.createCharacter = function () {
            this.character = new Sprite();
            this.character.loadImage("res/cartoonCharacters/1.png");
            this.character.pos(100, 50);
            Laya.stage.addChild(this.character);
        };
        EaseFunctionsDemo.prototype.createEaseFunctionList = function () {
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
        EaseFunctionsDemo.prototype.renderList = function (item) {
            item.setLabel(item.dataSource);
        };
        EaseFunctionsDemo.prototype.onEaseFunctionChange = function (list) {
            this.character.pos(100, 50);
            this.tween && this.tween.clear();
            this.tween = Tween.to(this.character, { x: 350, y: 250 }, this.duration, Ease[list.selectedItem]);
        };
        EaseFunctionsDemo.prototype.createDurationCrontroller = function () {
            var durationInput = this.createInputWidthLabel("Duration:", '2000', 400, 10);
            durationInput.on(Event.INPUT, this, function () {
                this.duration = parseInt(durationInput.text);
            });
        };
        EaseFunctionsDemo.prototype.createInputWidthLabel = function (label, prompt, x, y) {
            var text = new laya.display.Text();
            text.text = label;
            text.color = "white";
            Laya.stage.addChild(text);
            text.pos(x, y);
            var input = new laya.display.Input();
            input.size(50, 20);
            input.text = prompt;
            Laya.stage.addChild(input);
            input.color = "white";
            input.borderColor = "white";
            input.pos(text.x + text.width + 10, text.y - 3);
            input.inputElementYAdjuster = 1;
            return input;
        };
        return EaseFunctionsDemo;
    }());
    ui.EaseFunctionsDemo = EaseFunctionsDemo;
})(ui || (ui = {}));
var Box = laya.ui.Box;
var Label = laya.ui.Label;
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
new ui.EaseFunctionsDemo();

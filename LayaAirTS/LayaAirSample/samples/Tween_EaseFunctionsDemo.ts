/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import Input=laya.display.Input;
    import Sprite=laya.display.Sprite;
    import Text=laya.display.Text;
    import Event=laya.events.Event;

    import List=laya.ui.List;
    import Ease=laya.utils.Ease;
    import Handler=laya.utils.Handler;
    import Tween=laya.utils.Tween;

    export class EaseFunctionsDemo {
        private  character:Sprite;
        private  duration:number = 2000;
        private  tween:Tween;

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#3D3D3D";

            Laya.loader.load("res/ui/vscroll.png", Handler.create(this, this.init));
        }

        private  init():void {
            this.createCharacter();
            this.createEaseFunctionList();
            this.createDurationCrontroller();
        }

        private  createCharacter():void {
            this.character = new Sprite();
            this.character.loadImage("res/cartoonCharacters/1.png");
            this.character.pos(100, 50);
            Laya.stage.addChild(this.character);
        }

        private  createEaseFunctionList():void {
            var easeFunctionsList:List = new List();
            easeFunctionsList.itemRender = ListItemRender;
            easeFunctionsList.pos(5, 5);
            easeFunctionsList.repeatX = 1;
            easeFunctionsList.repeatY = 20;
            easeFunctionsList.vScrollBarSkin = '';
            easeFunctionsList.selectEnable = true;
            easeFunctionsList.selectHandler = new Handler(this, this.onEaseFunctionChange, [easeFunctionsList]);
            easeFunctionsList.renderHandler = new Handler(this, this.renderList);
            Laya.stage.addChild(easeFunctionsList);
            var data:Array<any> = [];
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
        }

        private  renderList(item:ListItemRender):void {
            item.setLabel(item.dataSource);
        }

        private  onEaseFunctionChange(list:List):void {
            this.character.pos(100, 50);

            this.tween && this.tween.clear();
            this.tween = Tween.to(this.character, {x: 350, y: 250}, this.duration, Ease[list.selectedItem]);
        }

        private  createDurationCrontroller():void {
            var durationInput:Input = this.createInputWidthLabel("Duration:", '2000', 400, 10);
            durationInput.on(Event.INPUT, this, function ():void {
                this.duration = parseInt(durationInput.text);
            });
        }

        private  createInputWidthLabel(label:string, prompt:string, x:number, y:number):laya.display.Input {
            var text:laya.display.Text = new laya.display.Text();
            text.text = label;
            text.color = "white";
            Laya.stage.addChild(text);
            text.pos(x, y);

            var input:laya.display.Input = new laya.display.Input();
            input.size(50, 20);
            input.text = prompt;
            Laya.stage.addChild(input);
            input.color = "white";
            input.borderColor = "white";
            input.pos(text.x + text.width + 10, text.y - 3);
            input.inputElementYAdjuster = 1;

            return input
        }
    }
}
import Box=laya.ui.Box;
import Label=laya.ui.Label;
class ListItemRender extends Box {
    private  label:Label;
    constructor(){
        super();
        this.size(100, 20);
        this.label = new Label();
        this.label.fontSize = 12;
        this.label.color = "#FFFFFF";
        this.addChild(this.label);
    }
    public  setLabel(value:string):void {
        this.label.text = value;
    }
}
new ui.EaseFunctionsDemo();
Laya.init(600, 400);
Laya.stage.alignH = Laya.Stage.ALIGN_CENTER;
Laya.stage.alignV = Laya.Stage.ALIGN_MIDDLE;
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
Laya.stage.bgColor = "#FFFFFF";

this.form = new Laya.Sprite();
this.form.size(250,120);
this.form.pos((Laya.stage.width - this.form.width) / 2, (Laya.stage.height - this.form.height) / 2);
Laya.stage.addChild(this.form);

this.rowHeight = 30;
this.rowSpacing = 10;
var rowHeightDelta = this.rowSpacing + this.rowHeight;

// 显示左侧标签
showLabel("邮箱", 0, rowHeightDelta * 0);
showLabel("出生日期", 0, rowHeightDelta * 1);
showLabel("密码", 0, rowHeightDelta * 2);

// 显示右侧输入框
var emailInput = createInputElement();
var birthdayInput = createInputElement();
var passwordInput = createInputElement();

birthdayInput.type = "date";
passwordInput.type = "password";

Laya.stage.on(Laya.Event.RESIZE, this, fitDOMElements, [emailInput, birthdayInput, passwordInput]);

function showLabel(label,x,y){
    var t = new Laya.Text();
    t.height = this.rowHeight;
    t.valign = "middle";
    t.fontSize = 15;
    t.font = "SimHei";
    t.text = label;
    t.pos(x, y);
    this.form.addChild(t);
}
function createInputElement(){
    var input = Laya.Browser.createElement("input");
    input.style.zIndex = Laya.Render.canvas.zIndex + 1;
    input.style.width = "100px";
    Laya.Browser.document.body.appendChild(input);
    return input;
}
function fitDOMElements(){
    for (var i = 0; i < arguments.length; i++)
    {
        var dom = arguments[i];
        Laya.Utils.fitDOMElementInArea(dom, this.form, 100, i * (this.rowSpacing + this.rowHeight), 150, this.rowHeight);
    }
}
var skin = "res/ui/textarea.png";

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.loader.load(skin, Laya.Handler.create(this, onLoadComplete));
 
function onLoadComplete()
{
    var ta = new Laya.TextArea("");
    ta.skin = skin;
     
    ta.inputElementXAdjuster = -2;
    ta.inputElementYAdjuster = -1;
     
    ta.font = "Arial";
    ta.fontSize = 20;
    ta.bold = true;
     
    ta.color = "#3d3d3d";
     
    ta.pos(100, 15);
    ta.size(375, 355);
    
    ta.padding = "70,8,8,8";
     
    Laya.stage.addChild(ta);
}
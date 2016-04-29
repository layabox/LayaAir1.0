var SPACING = 150;
var X_OFFSET = 60;
var Y_OFFSET = 120;

var skins;

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

skins = ["res/ui/radioButton (1).png", "res/ui/radioButton (2).png", "res/ui/radioButton (3).png"];
Laya.loader.load(skins, Laya.Handler.create(this, initRadioGroups));

function initRadioGroups()
{
	for (var i = 0; i < skins.length;++i)
	{
		var rg = createRadioGroup(skins[i]);
		rg.selectedIndex = i;
		rg.x = i * SPACING + X_OFFSET;
		rg.y = Y_OFFSET;
	}
}

function createRadioGroup(skin)
{
	var rg = new Laya.RadioGroup();
	rg.skin = skin;
	
	rg.space = 70;
	rg.direction = "v";
		
	rg.labels = "Item1, Item2, Item3";
	rg.labelSize = 20;
	rg.labelBold = true;
	rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
	rg.labelPadding = "5,0,0,5";
	
	rg.selectHandler = new Laya.Handler(this, onSelectChange);
	Laya.stage.addChild(rg);

	return rg;
}

function onSelectChange(index)
{
	console.log("你选择了第 " + (index + 1) + " 项");
}
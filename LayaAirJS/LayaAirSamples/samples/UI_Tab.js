var skins = ["res/ui/tab1.png", "res/ui/tab2.png"];

Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

Laya.stage.bgColor = "#3d3d3d";
Laya.loader.load(skins, Laya.Handler.create(this, onSkinLoaded));

function onSkinLoaded()
{
	var tabA = createTab(skins[0]);
	tabA.pos(40, 120);
	tabA.labelColors = "#000000,#d3d3d3,#333333";
	
	var tabB = createTab(skins[1]);
	tabB.pos(40, 220);
	tabB.labelColors = "#FFFFFF,#8FB299,#FFFFFF";
}

function createTab(skin)
{
	var tab = new Laya.Tab();
	tab.skin = skin;
	
	tab.labelBold = true;
	tab.labelSize = 20;
	tab.labelColors = "#FFFFFF,#8FB299,#5E5E5E";
	tab.labelStrokeColor = "#000000";
	
	tab.labels = "Tab Control 1,Tab Control 2,Tab Control 3";
	tab.labelPadding = "0,0,0,0";

	tab.selectedIndex = 1;

	onSelect(tab.selectedIndex);
	tab.selectHandler = new Laya.Handler(this, onSelect);
	
	Laya.stage.addChild(tab);
	
	return tab;
}

function onSelect(index)
{
	console.log("当前选择的标签页索引为 " + index);
}
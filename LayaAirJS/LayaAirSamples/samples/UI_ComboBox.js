var skin = "res/ui/combobox.png";

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.loader.load(skin, laya.utils.Handler.create(this, onLoadComplete));

function onLoadComplete()
{
	var cb = createComboBox(skin);
	cb.pos(100, 100);
}

function createComboBox(skin)
{
	var comboBox = new laya.ui.ComboBox(skin, "item0,item1,item2,item3,item4,item5");
	comboBox.labelSize = 30;
	comboBox.itemSize = 25;
	comboBox.selectHandler = new laya.utils.Handler(this, onSelect, [comboBox]);
	Laya.stage.addChild(comboBox);
	
	return comboBox;
}

function onSelect(cb)
{
	console.log("选中了： " + cb.selectedLabel);
}
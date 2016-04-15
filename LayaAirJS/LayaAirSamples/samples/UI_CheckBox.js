var COL_AMOUNT = 2;
var ROW_AMOUNT = 3;
var HORIZONTAL_SPACING = 200;
var VERTICAL_SPACING = 100;
var X_OFFSET = 100;
var Y_OFFSET = 50;

Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var skins = ["res/ui/checkbox (1).png", "res/ui/checkbox (2).png", "res/ui/checkbox (3).png", "res/ui/checkbox (4).png", "res/ui/checkbox (5).png", "res/ui/checkbox (6).png"];

Laya.loader.load(skins, laya.utils.Handler.create(this,onCheckBoxSkinLoaded));

function onCheckBoxSkinLoaded() 
{
	var cb;
	for (var i = 0; i < COL_AMOUNT; ++i)
	{
		for (var j = 0; j < ROW_AMOUNT; ++j)
		{
			cb = createCheckBox(skins[i * ROW_AMOUNT + j]);
			cb.selected = true;
			
			cb.x = HORIZONTAL_SPACING * i + X_OFFSET;
			cb.y += VERTICAL_SPACING * j + Y_OFFSET;
			
			// 给左边的三个CheckBox添加事件使其能够切换标签
			if (i == 0)
			{
				cb.y += 20;
				cb.on("change", this, updateLabel, [cb]);
				updateLabel(cb);
			}
		}
	}
}

function createCheckBox(skin)
{
	var cb = new laya.ui.CheckBox(skin);
	Laya.stage.addChild(cb);

	cb.labelColors = "white";
	cb.labelSize = 20;
	cb.labelFont = "SimHei";
	cb.labelPadding = "5,0,0,5";
	
	return cb;
}

function updateLabel(checkBox) 
{
	checkBox.label = checkBox.selected ? "已选中" : "未选中";
}

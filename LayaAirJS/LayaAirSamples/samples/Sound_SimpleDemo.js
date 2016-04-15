//声明一个信息文本
var txtInfo;
Laya.init(550, 400);

//创建一个Sprite充当音效播放按钮
var spBtnSound = new laya.display.Sprite();
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

//绘制按钮
spBtnSound.graphics.drawRect(0, 0, 110, 51, "#ff0000", "#ff0000", 1);
spBtnSound.graphics.fillText("播放音效", 10, 10, "", "#ffffff", "left");

spBtnSound.pos(17, 18);
spBtnSound.size(100, 100);

//设置接受鼠标事件
spBtnSound.mouseEnabled = true;

Laya.stage.addChild(spBtnSound);

//创建一个Sprite充当音乐播放按钮
var spBtnMusic = new laya.display.Sprite();

//绘制按钮
spBtnMusic.graphics.drawRect(0, 0, 110, 51, "#0000ff", "#0000ff", 1);
spBtnMusic.graphics.fillText("播放音乐", 10, 10, "", "#ffffff", "left");

spBtnMusic.pos(170, 18);
spBtnMusic.size(100, 100);

//设置接受鼠标事件
spBtnMusic.mouseEnabled = true;

Laya.stage.addChild(spBtnMusic);

//创建一个信息文本，用来显示当前播放信息
txtInfo = new laya.display.Text();

txtInfo.fontSize = 40;
txtInfo.color = "#ffffff";

txtInfo.size(300, 50);
txtInfo.pos(17, 86);

//添加进显示列表
Laya.stage.addChild(txtInfo);

spBtnSound.on(laya.events.Event.CLICK, this, onPlaySound);
spBtnMusic.on(laya.events.Event.CLICK, this, onPlayMusic);

function onPlayMusic(e) 
{
	//显示播放音乐信息
	txtInfo.text = "播放音乐";
	laya.media.SoundManager.playMusic("res/sounds/bgm.mp3", 1, new laya.utils.Handler(this, onComplete));
}

function onPlaySound(e) 
{
	//显示播放音效信息
	txtInfo.text = "播放音效";
	laya.media.SoundManager.playSound("res/sounds/btn.mp3", 1, new laya.utils.Handler(this, onComplete));
}

function onComplete() 
{
	txtInfo.text = "播放完成";
}
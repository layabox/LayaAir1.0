package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.media.SoundManager;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	public class Sound_SimpleDemo
	{
		//声明一个信息文本
		private var txtInfo:Text;
		public function Sound_SimpleDemo() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			//创建一个Sprite充当音效播放按钮
			var spBtnSound:Sprite = new Sprite();
			
			//绘制按钮
			spBtnSound.graphics.drawRect(0, 0, 110, 51, "#ff0000", "#ff0000", 1);
			spBtnSound.graphics.fillText("播放音效", 10, 10, "", "#ffffff", "left");
			
			spBtnSound.pos(17, 18);
			spBtnSound.size(100, 100);
			
			//设置接受鼠标事件
			spBtnSound.mouseEnabled = true;
			
			Laya.stage.addChild(spBtnSound);
			
			//创建一个Sprite充当音乐播放按钮
			var spBtnMusic:Sprite = new Sprite();
			
			//绘制按钮
			spBtnMusic.graphics.drawRect(0, 0, 110, 51, "#0000ff", "#0000ff", 1);
			spBtnMusic.graphics.fillText("播放音乐", 10, 10, "", "#ffffff", "left");
			
			spBtnMusic.pos(170, 18);
			spBtnMusic.size(100, 100);
			
			//设置接受鼠标事件
			spBtnMusic.mouseEnabled = true;
			
			Laya.stage.addChild(spBtnMusic);
			
			//创建一个信息文本，用来显示当前播放信息
			txtInfo = new Text();
			
			txtInfo.fontSize = 40;
			txtInfo.color = "#ffffff";
			
			txtInfo.size(300, 50);3
			txtInfo.pos(17, 86);
			
			//添加进显示列表
			Laya.stage.addChild(txtInfo);
			
			spBtnSound.on(Event.CLICK, this, onPlaySound);
			spBtnMusic.on(Event.CLICK, this, onPlayMusic);
			
		}
		
		private function onPlayMusic(e:Event):void 
		{
			//显示播放音乐信息
			txtInfo.text = "播放音乐";
			SoundManager.playMusic("res/sounds/bgm.mp3", 1, new Handler(this, onComplete));
		}
		
		private function onPlaySound(e:Event):void 
		{
			//显示播放音效信息
			txtInfo.text = "播放音效";
			SoundManager.playSound("res/sounds/btn.mp3", 1, new Handler(this, onComplete));
		}
		
		private function onComplete():void 
		{
			txtInfo.text = "播放完成";
		}
	}
}
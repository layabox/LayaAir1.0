package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.media.SoundManager;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Sound_SimpleDemo
	{
		//声明一个信息文本
		private var txtInfo:Text;
		public function Sound_SimpleDemo() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			setup();
		}

		private function setup():void
		{
			var gap:int = 10;

			//创建一个Sprite充当音效播放按钮
			var soundButton:Sprite = createButton("播放音效");
			soundButton.x = (Laya.stage.width - soundButton.width * 2 + gap) / 2;
			soundButton.y = (Laya.stage.height - soundButton.height) / 2;
			Laya.stage.addChild(soundButton);
			
			//创建一个Sprite充当音乐播放按钮
			var musicButton:Sprite = createButton("播放音乐");
			musicButton.x = soundButton.x + gap + soundButton.width;
			musicButton.y = soundButton.y;
			Laya.stage.addChild(musicButton);

			soundButton.on(Event.CLICK, this, onPlaySound);
			musicButton.on(Event.CLICK, this, onPlayMusic);
		}

		private function createButton(label:String):Sprite
		{
			var w:int = 110;
			var h:int = 40;

			var button:Sprite = new Sprite();
			button.size(w, h);
			button.graphics.drawRect(0, 0, w, h, "#FF7F50");
			button.graphics.fillText(label, w / 2 , 8, "25px SimHei", "#FFFFFF", "center");
			Laya.stage.addChild(button);
			return button;
		}
		
		private function onPlayMusic(e:Event=null):void 
		{
			trace("播放音乐");
			SoundManager.playMusic("../../../../res/sounds/bgm.mp3", 1, new Handler(this, onComplete));
		}
		
		private function onPlaySound(e:Event=null):void 
		{
			trace("播放音效");
			SoundManager.playSound("../../../../res/sounds/btn.mp3", 1, new Handler(this, onComplete));
		}
		
		private function onComplete():void 
		{
			trace("播放完成");
		}
	}
}
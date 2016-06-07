package
{
	import laya.display.Animation;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Tween;
	import laya.webgl.WebGL;
	
	public class BlendMode_Lighter
	{
		// 一只凤凰的分辨率是550 * 400
		private const phoenixWidth:int = 550;
		private const phoenixHeight:int = 400;
		
		private var bgColorTweener:Tween = new Tween();
		private var gradientInterval:int = 2000;
		private var bgColorChannels:Object = {r: 99, g: 0, b: 0xFF};

		public function BlendMode_Lighter()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(phoenixWidth * 2, phoenixHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			setup();
		}
		
		private function setup():void
		{
			createPhoenixes();
			
			// 动态背景渲染
			evalBgColor();
			Laya.timer.frameLoop(1, this, renderBg);
		}

		private function createPhoenixes():void
		{
			var scaleFactor:Number = Math.min(
				Laya.stage.width / (phoenixWidth * 2), 
				Laya.stage.height / phoenixHeight);

			// 加了混合模式的凤凰
			var blendedPhoenix:Animation = createAnimation();
			blendedPhoenix.blendMode = "lighter";
			blendedPhoenix.scale(scaleFactor, scaleFactor);
			blendedPhoenix.y = (Laya.stage.height - phoenixHeight * scaleFactor) / 2;

			// 正常模式的凤凰
			var normalPhoenix:Animation = createAnimation();
			normalPhoenix.scale(scaleFactor, scaleFactor);
			normalPhoenix.x = phoenixWidth * scaleFactor;
			normalPhoenix.y = (Laya.stage.height - phoenixHeight * scaleFactor) / 2;
		}
		
		private function createAnimation():Animation
		{
			var frames:Array = [];
			for (var i:int = 1; i <= 25; ++i)
			{
				frames.push("res/phoenix/phoenix" + preFixNumber(i, 4) + ".jpg");
			}
			
			var animation:Animation = new Animation();
			animation.loadImages(frames);
			Laya.stage.addChild(animation);
			
			var clips:Array = animation.frames.concat();
			// 反转帧
			clips = clips.reverse();
			// 添加到已有帧末尾
			animation.frames = animation.frames.concat(clips);
			
			animation.play();
			
			return animation;
		}

		private function preFixNumber(num:int, strLen:int):String
		{
			return ("0000000000" + num).slice(-strLen);
		}
		
		private function evalBgColor():void
		{
			var color:int = Math.random() * 0xFFFFFF;
			var channels:Array = getColorChannals(color);
			bgColorTweener.to(bgColorChannels, {r: channels[0], g: channels[1], b: channels[2]}, gradientInterval, null, Handler.create(this, onTweenComplete));
		}
		
		private function getColorChannals(color:int):Array
		{
			var result:Array = [];
			result.push(color >> 16);
			result.push(color >> 8 & 0xFF);
			result.push(color & 0xFF);
			return result;
		}
		
		private function onTweenComplete():void
		{
			evalBgColor();
		}
		
		private function renderBg():void
		{
			Laya.stage.graphics.clear();
			Laya.stage.graphics.drawRect(
				0, (Laya.stage.height - phoenixHeight * Browser.pixelRatio) / 2, 
				phoenixWidth, phoenixHeight, getHexColorString());
		}
		
		private function getHexColorString():String
		{
			bgColorChannels.r = Math.floor(bgColorChannels.r);
			// 绿色通道使用0
			bgColorChannels.g = 0;
			//obj.g = Math.floor(obj.g);
			bgColorChannels.b = Math.floor(bgColorChannels.b);
			
			var r:String = bgColorChannels.r.toString(16);
			r = r.length == 2 ? r : "0" + r;
			var g:String = bgColorChannels.g.toString(16);
			g = g.length == 2 ? g : "0" + g;
			var b:String = bgColorChannels.b.toString(16);
			b = b.length == 2 ? b : "0" + b;
			return "#" + r + g + b;
		}
	}
}
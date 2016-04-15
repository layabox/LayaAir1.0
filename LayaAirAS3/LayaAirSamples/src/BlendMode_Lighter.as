package
{
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.utils.Handler;
	import laya.utils.Tween;
	import laya.utils.Utils;
	
	public class BlendMode_Lighter
	{
		private var w:int = 1000;
		private var h:int = 400;
		private var tween:Tween = new Tween();
		private var duration:int = 2000;
		private var obj:Object = {r: 99, g: 0, b: 0xFF};
		
		public function BlendMode_Lighter()
		{
			Laya.init(w, h);
			
			// 加了混合模式的凤凰
			createAnimation().blendMode = "lighter";
			// 正常模式的凤凰
			createAnimation().pos(500, 0);
			
			
			evalBgColor();
			
			Laya.timer.frameLoop(1, this, renderBg);
		}
		
		private function createAnimation():Animation
		{
			var animation:Animation = Animation.fromUrl("res/phoenix/phoenix{0001}.jpg", 25);
			Laya.stage.addChild(animation);
			
			var clips:Array = animation.frames.concat();
			// 反转帧
			clips = clips.reverse();
			// 添加到已有帧末尾
			animation.frames = animation.frames.concat(clips);
			
			animation.play();
			
			return animation;
		}
		
		private function evalBgColor():void
		{
			var color:int = Math.random() * 0xFFFFFF;
			var channels:Array = getColorChannals(color);
			tween.to(obj, {r: channels[0], g: channels[1], b: channels[2]}, duration, null, Handler.create(this, onTweenComplete));
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
			Laya.stage.graphics.drawRect(0, 0, w, h, getColor());
		}
		
		private function getColor():String
		{
			obj.r = Math.floor(obj.r);
			// 绿色通道使用0
			obj.g = 0;
			//obj.g = Math.floor(obj.g);
			obj.b = Math.floor(obj.b);
			
			var r:String = obj.r.toString(16);
			r = r.length == 2 ? r : "0" + r;
			var g:String = obj.g.toString(16);
			g = g.length == 2 ? g : "0" + g;
			var b:String = obj.b.toString(16);
			b = b.length == 2 ? b : "0" + b;
			return "#" + r + g + b;
		}
	
	}
}
package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Handler;
	import laya.events.Event;
	
	public class Interaction_MousePenetrate
	{
		private var txt:Text;
		
		public function Interaction_MousePenetrate()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#ffeecc";
			
			// 紫色矩形
			var purpleRect:Sprite = new Sprite();
			//绘制矩形
			purpleRect.graphics.drawRect(0, 0, 350, 500, "#ff0ffe");
			//接受鼠标事件
			purpleRect.mouseEnabled = true;
			//为true时，点击空白区域可以穿透
			purpleRect.mouseThrough = true;
			
			purpleRect.size(500, 500);
			//设置名称
			purpleRect.name = "紫色容器";
			
			Laya.stage.addChild(purpleRect);
			
			purpleRect.on(Event.MOUSE_DOWN, this, onDown);
			
			// 设置蓝色矩形
			var blurRect:Sprite = new Sprite();
			blurRect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
			//设置名称
			blurRect.name = "蓝色矩形";
			blurRect.pos(100, 80);
			//设置宽高（要接收鼠标事件必须设置宽高，否则不会被命中）  
			blurRect.size(100, 100);
			
			purpleRect.addChild(blurRect);
			
			blurRect.on(Event.MOUSE_DOWN, this, onDown);
			
			// 设置蓝色圆形
			var blurCircle:Sprite = new Sprite();
			blurCircle.graphics.drawCircle(0, 100, 100, "#00eeff");
			//设置名称
			blurCircle.name = "蓝色圆形"
			blurCircle.pos(350, 80);
			purpleRect.addChild(blurCircle);
			
			blurCircle.on(Event.MOUSE_DOWN, this, onDown);
			
			// 设置舞台
			Laya.stage.name = "舞台"
			Laya.stage.on(Event.MOUSE_DOWN, this, onDown);
			
			//添加提示文本
			createTxt();
		}
		
		/**侦听处理方法*/
		private function onDown(e:Event):void
		{
			txt.text = "点击的是：" + e.target.name;
		}
		
		/**添加提示文本*/
		private function createTxt():void
		{
			txt = new Text();
			txt.text = "点击图形查看点击目标";
			txt.pos(30, 30);
			txt.size(500, 40);
			txt.fontSize = 30;
			txt.color = "#000000";
			Laya.stage.addChild(txt);
		}
	}

}
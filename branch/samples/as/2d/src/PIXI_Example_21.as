package
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	/**
	 * ...
	 * @author Survivor
	 * 
	 * 
	 */
	public class PIXI_Example_21
	{
		private var colors:Array = ["#5D0776", "#EC8A49", "#AF3666", "#F6C84C", "#4C779A"];
		private var colorCount:int = 0;
		private var isDown:Boolean = false;
		private var path:Array = [];
		private var color:String = colors[0];
		private var liveGraphics:Graphics;
		private var canvasGraphics:Graphics;
		
		public function PIXI_Example_21()
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			Laya.stage.bgColor = "#3da8bb";
			
			createCanvases();
			
			Laya.timer.frameLoop(1, this, animate);
			
			Laya.stage.on('mousedown', this, onMouseDown);
			Laya.stage.on('mousemove', this, onMouseMove);
			Laya.stage.on('mouseup', this, onMouseUp);
		}
		
		private function createCanvases():void 
		{
			var graphicsCanvas:Sprite = new Sprite();
			Laya.stage.addChild(graphicsCanvas);
			var liveGraphicsCanvas:Sprite = new Sprite();
			Laya.stage.addChild(liveGraphicsCanvas);
			
			liveGraphics = liveGraphicsCanvas.graphics;
			canvasGraphics = graphicsCanvas.graphics;
		}
		
		private function onMouseDown(e:*=null):void
		{
			isDown = true;
			color = colors[colorCount++ % colors.length];
			path.length = 0;
		}
		
		private function onMouseMove(e:*=null):void
		{
			if (!isDown) return;
			
			path.push(Laya.stage.mouseX);
			path.push(Laya.stage.mouseY);
		}
		
		private function onMouseUp(e:*=null):void
		{
			isDown = false;
			canvasGraphics.drawPoly(0, 0, path.concat() , color);
		}
		
		private function animate():void
		{
			liveGraphics.clear();
			liveGraphics.drawPoly(0, 0, path, color);
		}
	}
}
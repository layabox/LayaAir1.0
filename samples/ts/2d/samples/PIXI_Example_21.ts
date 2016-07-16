module laya {
	import Graphics = laya.display.Graphics;
	import Sprite = laya.display.Sprite;
	import Browser = laya.utils.Browser;
	import WebGL = laya.webgl.WebGL;
	
	export class PIXI_Example_21
	{
		private colors:Array<string> = ["#5D0776", "#EC8A49", "#AF3666", "#F6C84C", "#4C779A"];
		private colorCount:number = 0;
		private isDown:Boolean = false;
		private path:Array<number> = [];
		private color:String = this.colors[0];
		private liveGraphics:Graphics;
		private canvasGraphics:Graphics;
		
		constructor()
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			Laya.stage.bgColor = "#3da8bb";
			
			this.createCanvases();
			
			Laya.timer.frameLoop(1, this, this.animate);
			
			Laya.stage.on('mousedown', this, this.onMouseDown);
			Laya.stage.on('mousemove', this, this.onMouseMove);
			Laya.stage.on('mouseup', this, this.onMouseUp);
		}
		
		private createCanvases():void 
		{
			var graphicsCanvas:Sprite = new Sprite();
			Laya.stage.addChild(graphicsCanvas);
			var liveGraphicsCanvas:Sprite = new Sprite();
			Laya.stage.addChild(liveGraphicsCanvas);
			
			this.liveGraphics = liveGraphicsCanvas.graphics;
			this.canvasGraphics = graphicsCanvas.graphics;
		}
		
		private onMouseDown():void
		{
			this.isDown = true;
			this.color = this.colors[this.colorCount++ % this.colors.length];
			this.path.length = 0;
		}
		
		private onMouseMove():void
		{
			if (!this.isDown) return;
			
			this.path.push(Laya.stage.mouseX);
			this.path.push(Laya.stage.mouseY);
		}
		
		private onMouseUp():void
		{
			this.isDown = false;
			this.canvasGraphics.drawPoly(0, 0, this.path.concat() , this.color);
		}
		
		private animate():void
		{
			this.liveGraphics.clear();
			this.liveGraphics.drawPoly(0, 0, this.path, this.color);
		}
	}
}
new laya.PIXI_Example_21();
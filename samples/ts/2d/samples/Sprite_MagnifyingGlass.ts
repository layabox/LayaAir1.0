/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya
{
	import Sprite  = laya.display.Sprite;
	import Stage   = laya.display.Stage;
	import Browser = laya.utils.Browser;
	import Handler = laya.utils.Handler;
	import WebGL   = laya.webgl.WebGL;
	
	export class Sprite_MagnifyingGlass
	{
		private maskSp:Sprite;
		private bg2:Sprite;

		constructor()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(1136, 640, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load("res/bg2.png", Handler.create(this, this.setup));
		}

		private setup():void
		{
			var bg:Sprite = new Sprite();
			bg.loadImage("res/bg2.png");
			Laya.stage.addChild(bg);

			this.bg2 = new Sprite();
			this.bg2.loadImage("res/bg2.png");
			Laya.stage.addChild(this.bg2);
			this.bg2.scale(3, 3);
			
			//创建mask
			this.maskSp = new Sprite();
			this.maskSp.loadImage("res/mask.png");
			this.maskSp.pivot(50, 50);

			//设置mask
			this.bg2.mask = this.maskSp;

			Laya.stage.on("mousemove", this, this.onMouseMove);
		}

		private onMouseMove():void
		{
			this.bg2.x = -Laya.stage.mouseX * 2;
			this.bg2.y = -Laya.stage.mouseY * 2;

			this.maskSp.x = Laya.stage.mouseX;
			this.maskSp.y = Laya.stage.mouseY;
		}
	}
}	
new laya.Sprite_MagnifyingGlass();
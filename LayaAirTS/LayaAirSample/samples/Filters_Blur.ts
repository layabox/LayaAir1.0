/// <reference path="../../libs/LayaAir.d.ts" />
module laya
{
	import Sprite = laya.display.Sprite;
	import BlurFilter = laya.filters.BlurFilter;
	import WebGL = laya.webgl.WebGL;
	
	export class Filters_Blur 
	{
		constructor()
		{
			Laya.init(550, 400, WebGL);
			
			var ape:Sprite = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			ape.pos(200, 100);
			Laya.stage.addChild(ape);
			
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.strength = 5;
			ape.filters = [blurFilter];
		}
	}
}
new laya.Filters_Blur();
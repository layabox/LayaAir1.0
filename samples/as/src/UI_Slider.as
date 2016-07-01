package
{
	import laya.display.Stage;
	import laya.ui.HSlider;
	import laya.ui.VSlider;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_Slider
	{
		public function UI_Slider()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 400, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
				
			var skins:Array = [];
			skins.push("res/ui/hslider.png", "res/ui/hslider$bar.png");
			skins.push("res/ui/vslider.png", "res/ui/vslider$bar.png");
			Laya.loader.load(skins, Handler.create(this, onLoadComplete));
		}
		
		private function onLoadComplete(e:*=null):void
		{
			placeHSlider();
			placeVSlider();
		}
		
		private function placeHSlider():void 
		{
			var hs:HSlider = new HSlider();
			hs.skin = "res/ui/hslider.png";
			
			hs.width = 300;
			hs.pos(50, 170);
			hs.min = 0;
			hs.max = 100;
			hs.value = 50;
			hs.tick = 1;
			
			hs.changeHandler = new Handler(this, onChange);
			Laya.stage.addChild(hs);
		}
		
		private function placeVSlider():void
		{
			var vs:VSlider = new VSlider();
			
			vs.skin = "res/ui/vslider.png";
			
			vs.height = 300;
			vs.pos(400, 50);
			vs.min = 0;
			vs.max = 100;
			vs.value = 50;
			vs.tick = 1;
			
			vs.changeHandler = new Handler(this, onChange);
			Laya.stage.addChild(vs);
		}
		
		private function onChange(value:Number):void
		{
			trace("滑块的位置：" + value);
		}
	}
}
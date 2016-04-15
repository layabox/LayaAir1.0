package
{
	import laya.display.Stage;
	import laya.ui.HScrollBar;
	import laya.ui.VScrollBar;
	import laya.utils.Handler;

	public class UI_ScrollBar
	{
		public function UI_ScrollBar()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var skins:Array = [];
			skins.push("res/ui/hscroll.png", "res/ui/hscroll$bar.png", "res/ui/hscroll$down.png", "res/ui/hscroll$up.png");
			skins.push("res/ui/vscroll.png", "res/ui/vscroll$bar.png", "res/ui/vscroll$down.png", "res/ui/vscroll$up.png");
			Laya.loader.load(skins, Handler.create(this, onSkinLoadComplete));
		}

		private function onSkinLoadComplete():void
		{
			placeHScroller();
			placeVScroller();
		}
		
		private function placeHScroller():void 
		{
			var hs:HScrollBar = new HScrollBar();
			hs.skin = "res/ui/hscroll.png";
			hs.width = 300;
			hs.pos(50, 170);
			
			hs.min = 0;
			hs.max = 100;
			
			hs.changeHandler = new Handler(this, onChange);
			Laya.stage.addChild(hs);
		}
		
		private function placeVScroller():void 
		{
			var vs:VScrollBar = new VScrollBar();
			vs.skin = "res/ui/vscroll.png";
			vs.height = 300;
			vs.pos(400, 50);
			
			vs.min = 0;
			vs.max = 100;
			
			vs.changeHandler = new Handler(this, onChange);
			Laya.stage.addChild(vs);
		}

		private function onChange(value:Number):void 
		{
			trace("滚动条的位置： value=" + value);
		}
	}
}
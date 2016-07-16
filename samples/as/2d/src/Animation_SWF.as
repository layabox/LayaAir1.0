package 
{
	import laya.ani.swf.MovieClip;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Animation_SWF 
	{
		private const SWFPath:String = "../../../../res/swf/dragon.swf";
		
		private const MCWidth:int = 318;
		private const MCHeight:int = 406;
		
		public function Animation_SWF() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			createMovieClip();
		}
		
		private function createMovieClip():void
		{
			var mc:MovieClip = new MovieClip();
			mc.load(SWFPath);
			
			mc.x = (Laya.stage.width - MCWidth) / 2;
			mc.y = (Laya.stage.height - MCHeight) / 2;
			
			Laya.stage.addChild(mc);
		}
	}
}
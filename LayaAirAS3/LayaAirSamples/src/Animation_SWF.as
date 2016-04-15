package 
{
	import laya.ani.swf.MovieClip;
	import laya.display.Stage;
	
	public class Animation_SWF 
	{
		public function Animation_SWF() 
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#ffeecc";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var mc:MovieClip = new MovieClip();
			mc.load("res/swf/H5.swf");
			
			mc.scale(0.5, 0.5);
			mc.pos(100, -10);
			
			Laya.stage.addChild(mc);
			
			Laya.timer.frameLoop(1, this, function():void
			{
				trace(mc.getBounds());
			});
		}
	}
}
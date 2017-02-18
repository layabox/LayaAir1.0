package
{
import laya.display.Animation;
	import laya.display.Stage;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;

	public class Animation_Altas
	{
		private const AniConfPath:String = "C:\\Users\\Survivor\\Desktop\\out\\22003_stand.json";
		
		public function Animation_Altas()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(AniConfPath, Handler.create(this, createAnimation), null, Loader.ATLAS);
		}
		
		private function createAnimation(_e:*=null):void
		{
			var ani:Animation = new Animation();
			ani.loadAtlas(AniConfPath);			// 加载图集动画
			ani.interval = 30;					// 设置播放间隔（单位：毫秒）
			ani.index = 1;						// 当前播放索引
			ani.play();							// 播放图集动画
			
			// 获取动画的边界信息
			var bounds:Rectangle = ani.getGraphicBounds();
			ani.pivot(bounds.width / 2, bounds.height / 2);
			
			ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);
			
			Laya.stage.addChild(ani);
		}
	}
}
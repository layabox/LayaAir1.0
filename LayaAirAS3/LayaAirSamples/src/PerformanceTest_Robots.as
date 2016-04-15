package
{
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class PerformanceTest_Robots
	{
		private var robotDataPath:String = "res/robot/data.bin";
		private var robotTexturePath:String = "res/robot/texture.png";
		
		private var robotAmount:int = 90;
		private var colAmount:int = 15;
		private var robotScale:Number = 0.3;
		private var rowAmount:int = Math.ceil(robotAmount / colAmount);
		private var textureWidth:int;
		private var textureHeight:int;
		
		public function PerformanceTest_Robots()
		{
			Laya.init(Browser.width,Browser.height, WebGL);
			Laya.stage.bgColor = "#000000";
			
			Stat.show();
			
			var assets:Array = [];
			assets.push( { url:robotDataPath, type:Loader.BUFFER } );
			assets.push( { url:robotTexturePath, type:Loader.IMAGE } );
			Laya.loader.load(assets, Handler.create(this, onAssetsLoaded));
		}
		
		private function onAssetsLoaded():void
		{
			var data:* = Loader.getRes(robotDataPath);
			var img:* = Loader.getRes(robotTexturePath);
			var temp:Templet = new Templet(data, img);
			
			textureWidth = temp.textureWidth;
			textureHeight = temp.textureHeight;
			
			var horizontalGap:int = (Laya.stage.width - textureWidth * robotScale) / colAmount;
			var verticalGap:int = (Laya.stage.height - textureHeight * robotScale) / rowAmount;
		
			for (var i:int = 0; i < robotAmount; i++)
			{
				var col:int = i % colAmount;
				var row:int = i / colAmount | 0;
				
				var robot:Skeleton = createRobot(temp);
				
				robot.pos(horizontalGap * col, verticalGap * row);
				
				robot.stAnimName("Walk");
				robot.play();
			}
		}
		
		private function createRobot(templet:Templet):Skeleton
		{
			var sk:Skeleton = new Skeleton(templet);
			sk.pivot( -textureWidth, -textureHeight);
			sk.scaleX = sk.scaleY = robotScale;
			
			Laya.stage.addChild(sk);
			
			return sk;
		}
	}
}

package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.filters.ColorFilter;
	
	public class Filters_Color
	{
		public function Filters_Color()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			//由 20 个项目（排列成 4 x 5 矩阵）组成的数组，红色
			var redMat:Array = 
				[1, 0, 0, 0, 0, 0, //R
					0, 0, 0, 0, 0, 0, //G
					0, 0, 0, 0, 0, 0, //B
					1, 0, 0, 0, 0, 0];//A
			
			//由 20 个项目（排列成 4 x 5 矩阵）组成的数组，灰图
			var grayscaleMat:Array = [0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0];
			
			//创建一个颜色滤镜对象,红色
			var redFilter:ColorFilter = new ColorFilter(redMat);
			//创建一个颜色滤镜对象，灰图
			var grayscaleFilter:ColorFilter = new ColorFilter(grayscaleMat);
			
			// 猩猩原图
			var originalApe:Sprite = createApe();
			originalApe.pos(50, 100);
			// 赤化猩猩
			var redApe:Sprite = createApe();
			redApe.filters = [redFilter];
			redApe.pos(220, 100);
			// 灰度猩猩
			var grayApe:Sprite = createApe();
			grayApe.filters = [grayscaleFilter];
			grayApe.pos(380, 100);
		}
		
		private function createApe():Sprite
		{
			var ape:Sprite = new Sprite();
			ape.loadImage("res/apes/monkey2.png");
			Laya.stage.addChild(ape);
			
			return ape;
		}
	}
}
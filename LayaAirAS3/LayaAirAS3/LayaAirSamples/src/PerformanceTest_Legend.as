package
{
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.ComboBox;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class PerformanceTest_Legend
	{
		private var players:Array = [];
		private var width:int = Browser.width;
		private var height:int = Browser.height;
		
		public function PerformanceTest_Legend()
		{
			Laya.init(width, height, WebGL);
			Stat.show()
			Laya.stage.bgColor = "#000000";
			initHandler();
		}
		
		private function initHandler():void
		{
			// 资源加载
			for (var i:int = 1; i <= 6; i++)
			{
				Laya.loader.load("res/legend/bitmap2/" + i + ".png");
			}
			for (var j:int = 1; j <= 6; j++)
			{
				Laya.loader.load("res/legend/bitmap3/" + j + ".png");
			}
			for (var k:int = 1; k <= 6; k++)
			{
				Laya.loader.load("res/legend/bitmap4/" + k + ".png");
			}
			
			Laya.loader.once(Event.COMPLETE, this, loadPlayerRes);
			
			// 显示背景
			var background:Sprite = new Sprite();
			background.loadImage("res/legend/map.jpg", 0, 0);
			background.scale(width / 600, height / 600);
			Laya.stage.addChild(background);
		}
		
		private function loadPlayerRes():void
		{
			createPlayers();
			Laya.timer.frameLoop(1, this, animateHandler);
		}
		
		private function animateHandler():void
		{
			var ani:Animation;
			for (var i:int = 0; i < players.length; i++)
			{
				ani = players[i];
				ani.x += ani["speed"];
				if (ani.x > width)
				{
					ani.x = -100;
				}
			}
		}
		
		private function createPlayers():void
		{
			var playerList:Array = [];
			var player1:Array = [];
			for (var i:int = 1; i <= 6; i++)
			{
				player1.push("res/legend/bitmap2" + "/" + i + ".png");
			}
			playerList.push(player1);
			var player2:Array = [];
			for (var i:int = 1; i <= 6; i++)
			{
				player2.push("res/legend/bitmap3" + "/" + i + ".png");
			}
			playerList.push(player2);
			var player3:Array = [];
			for (var i:int = 1; i <= 6; i++)
			{
				player3.push("res/legend/bitmap4" + "/" + i + ".png");
			}
			playerList.push(player3);
			for (var j:int = 0; j < 500; j++)
			{
				var ani:Animation = new Animation();
				//加载图片地址集合，组成动画
				ani.loadImages(playerList[parseInt((Math.random() * 3).toString())]);
				//设置位置
				ani.pos(Math.random() * width, Math.random() * height);
				ani.zOrder = ani.y;
				ani["speed"] = Math.random() + 0.2;
				//设置播放间隔（单位：毫秒）
				ani.interval = 100;
				//当前播放索引
				ani.index = 1;
				//播放图集动画
				ani.play();
				Laya.stage.addChild(ani);
				players.push(ani);
			}
		}
	}
}
package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	

	public class PIXI_Example_05
	{
		private var n:int = 5000;
		private var d:int = 1;
		private var current:int = 0;
		private var objs:int = 17;
		private var vx:int = 0;
		private var vy:int = 0;
		private var vz:int = 0;
		private var points1:Array = [];
		private var points2:Array = [];
		private var points3:Array = [];
		private var tpoint1:Array = [];
		private var tpoint2:Array = [];
		private var tpoint3:Array = [];
		private var balls:Array = [];
		
		public function PIXI_Example_05()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.width, Browser.height, WebGL);
			Stat.show();
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			
			setup();
		}
		
		private function setup():void
		{
			Laya.stage.on(Event.RESIZE, this, onResize);
			
			makeObject(0);
			
			for (var i:int = 0; i < n; i++)
			{
				tpoint1[i] = points1[i];
				tpoint2[i] = points2[i];
				tpoint3[i] = points3[i];
				
				var tempBall:Sprite = new Sprite();
				tempBall.loadImage('res/pixi/pixel.png');
				tempBall.pivot(3, 3);
				tempBall.alpha = 0.5;
				balls[i] = tempBall;
				
				Laya.stage.addChild(tempBall);
			}
			
			onResize();
			
			Laya.timer.loop(5000, this, nextObject);
			Laya.timer.frameLoop(1, this, update);
		}
		
		private function nextObject():void
		{
			current++;
			
			if (current > objs)
			{
				current = 0;
			}
			
			makeObject(current);
		}
		
		private function makeObject(t):void
		{
			var xd:int;
			var i:int;
			
			switch (t)
			{
			case 0:
				for (i = 0; i < n; i++)
				{
					points1[i] = -50 + Math.round(Math.random() * 100);
					points2[i] = 0;
					points3[i] = 0;
				}
				break;
			
			case 1:
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 2:
				for (i = 0; i < n; i++)
				{
					xd = -90 + (Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 3:
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 4:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 5:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					
					
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 6:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 7:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 8:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 9:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 10:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 11:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 12:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 13:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 14:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.sin(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 15:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			
			case 16:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;
			
			case 17:
				
				for (i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
			}
		
		}
		
		private function onResize():void
		{
		
		}
		
		private function update():void
		{
			var x3d:Number, y3d:Number, z3d:Number, tx:Number, ty:Number, tz:Number, ox:Number;
			
			if (d < 200)
			{
				d++;
			}
			
			vx += 0.0075;
			vy += 0.0075;
			vz += 0.0075;
			
			for (var i:int = 0; i < n; i++)
			{
				if (points1[i] > tpoint1[i])
				{
					tpoint1[i] = tpoint1[i] + 1;
				}
				if (points1[i] < tpoint1[i])
				{
					tpoint1[i] = tpoint1[i] - 1;
				}
				if (points2[i] > tpoint2[i])
				{
					tpoint2[i] = tpoint2[i] + 1;
				}
				if (points2[i] < tpoint2[i])
				{
					tpoint2[i] = tpoint2[i] - 1;
				}
				if (points3[i] > tpoint3[i])
				{
					tpoint3[i] = tpoint3[i] + 1;
				}
				if (points3[i] < tpoint3[i])
				{
					tpoint3[i] = tpoint3[i] - 1;
				}
				
				x3d = tpoint1[i];
				y3d = tpoint2[i];
				z3d = tpoint3[i];
				
				ty = (y3d * Math.cos(vx)) - (z3d * Math.sin(vx));
				tz = (y3d * Math.sin(vx)) + (z3d * Math.cos(vx));
				tx = (x3d * Math.cos(vy)) - (tz * Math.sin(vy));
				tz = (x3d * Math.sin(vy)) + (tz * Math.cos(vy));
				ox = tx;
				tx = (tx * Math.cos(vz)) - (ty * Math.sin(vz));
				ty = (ox * Math.sin(vz)) + (ty * Math.cos(vz));
				
				balls[i].x = (512 * tx) / (d - tz) + Laya.stage.width / 2;
				balls[i].y = (Laya.stage.height / 2) - (512 * ty) / (d - tz);
			}
		}
	}
}
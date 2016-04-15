package {
	import laya.display.Sprite;
	import laya.utils.Ease;
	import laya.utils.Tween;
	import laya.textures.Texture;
	
		public function Async() 
		{
			Laya.init(1000, 400);
			
			//异步加载一个资源
			var img:Texture, img2:Texture;
			img = await::load("res/async/plane2.png");
			img2 = await::load("res/async/boy.png");
			
			//加载完毕后，创建第一个精灵			
			var plane:Sprite = new Sprite();
			plane.graphics.drawTexture(img, 0, 0);
			plane.pos(100, 100);
			Laya.stage.addChild(plane);
			
			//等待500毫秒
			await::sleep(500);
			
			//创建第二个精灵
			var boy:Sprite = new Sprite();
			boy.graphics.drawTexture(img2, 0, 0);
			boy.pos(50, -10);
			boy.alpha = 0;
			plane.addChild(boy);
			Tween.to(boy, {alpha: 1}, 1000, Ease.linearNone);
			
			//等待1000毫秒
			await::sleep(1000);
			
			//开动飞机
			Tween.to(plane, {x: 750}, 3000, Ease.sineOut);
		}
	}
}
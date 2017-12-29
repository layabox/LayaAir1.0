package {
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	public class Loader_ClearTextureRes {
		private var spBg:Sprite;
		private var aniFly:Animation;
		private var btn:Sprite;
		private var txt:Text;
		private var isDestroyed:Boolean = false;
		private const PathBg:String = "../../../../res/bg2.png";
		private const PathFly:String = "../../../../res/fighter/fighter.atlas";

		/**
		 * Tips:
		 * 1. 引擎初始化后，会占用16M内存，用来存放文字图集资源，所以即便舞台没有任何对象，也会占用这部分内存；
		 * 2. 销毁 Texture 使用的图片资源后，会保留 Texture 壳，当下次渲染时，发现 Texture 使用的图片资源不存在，则自动恢复。
		 */
		public function Loader_ClearTextureRes() {
			//初始化引擎
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			init();

			//显示性能统计信息
			Stat.show();
		}

		/**
		 * 初始化场景
		 */
		private function init():void {
			//创建背景
			spBg = Sprite.fromImage(PathBg);
			Laya.stage.addChild(spBg);

			//创建动画
			aniFly = new Animation();
			aniFly.loadAtlas(PathFly);
			aniFly.play();
			aniFly.pos(250, 100);
			Laya.stage.addChild(aniFly);

			//创建按钮
			btn = new Sprite().size(205, 55);
			btn.graphics.drawRect(0, 0, btn.width, btn.height, "#057AFB");
			txt = new Text();
			txt.text = "销毁";
			txt.pos(75, 15);
			txt.fontSize = 25;
			txt.color = "#FF0000";
			btn.addChild(txt);
			btn.pos(20, 160);
			btn.mouseEnabled = true;
			btn.name = "btnBg";
			Laya.stage.addChild(btn);

			//添加侦听
			btn.on(Event.MOUSE_UP, this, onMouseUp);
		}

		/**
		 * 鼠标事件响应函数
		 */
		private function onMouseUp(evt:Event):void {
			if (isDestroyed) {
				//通过设置 visible=true ，来触发渲染，然后引擎会自动恢复资源
				spBg.visible = true;
				aniFly.visible = true;

				isDestroyed = false;
				txt.text = "销毁";
			} else {
				//通过设置 visible=false ，来停止渲染对象
				spBg.visible = false;
				aniFly.visible = false;

				//销毁 Texture 使用的图片资源
				Laya.loader.clearTextureRes(PathBg);
				Laya.loader.clearTextureRes(PathFly);

				isDestroyed = true;
				txt.text = "恢复";
			}
		}
	}
}
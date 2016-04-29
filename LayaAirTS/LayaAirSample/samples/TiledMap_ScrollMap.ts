/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Stage = laya.display.Stage;
	import TiledMap = laya.map.TiledMap;
	import Rectangle = laya.maths.Rectangle;
	import Browser = laya.utils.Browser;
	import Handler = laya.utils.Handler;
	import Stat = laya.utils.Stat;

	export class TiledMap_SimpleDemo {
		private tiledMap: TiledMap;
		private mLastMouseX: number = 0;
		private mLastMouseY: number = 0;

		private mX: number = 0;
		private mY: number = 0;

		constructor() {
			Laya.init(Browser.width, Browser.height);
			Laya.stage.bgColor = "#666666";
			Stat.show(10, 10);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			this.createMap();
			Laya.stage.on(laya.events.Event.MOUSE_DOWN, this, this.mouseDown);//注册鼠标事件
			Laya.stage.on(laya.events.Event.MOUSE_UP, this, this.mouseUp);
		}

		//创建地图
		private createMap() {
			//创建地图对象
			this.tiledMap = new TiledMap();

			this.mX = this.mY = 0;
			//创建地图，适当的时候调用destory销毁地图
			this.tiledMap.createMap("res/tiledMap/desert.json", new Rectangle(0, 0, Browser.width, Browser.height), new Handler(this, this.completeHandler));
		}

		/**
		 * 地图加载完成的回调
		 */
		private completeHandler(): void {
			console.log("地图创建完成");
			console.log("ClientW:" + Browser.clientWidth + " ClientH:" + Browser.clientHeight);
			Laya.stage.on(laya.events.Event.RESIZE, this, this.resize);
			this.resize();
		}

		//鼠标按下拖动地图
		private mouseDown(): void {
			this.mLastMouseX = Laya.stage.mouseX;
			this.mLastMouseY = Laya.stage.mouseY;
			Laya.stage.on(laya.events.Event.MOUSE_MOVE, this, this.mouseMove);
		}

		private mouseMove(): void {
			//移动地图视口
			this.tiledMap.moveViewPort(this.mX - (Laya.stage.mouseX - this.mLastMouseX), this.mY - (Laya.stage.mouseY - this.mLastMouseY));
		}

		private mouseUp(): void {
			this.mX = this.mX - (Laya.stage.mouseX - this.mLastMouseX);
			this.mY = this.mY - (Laya.stage.mouseY - this.mLastMouseY);
			Laya.stage.off(laya.events.Event.MOUSE_MOVE, this, this.mouseMove);
		}

		// 窗口大小改变，把地图的视口区域重设下
		private resize(): void {
			//改变地图视口大小
			this.tiledMap.changeViewPort(this.mX, this.mY, Browser.width, Browser.height);
		}
	}
}
new laya.TiledMap_SimpleDemo();
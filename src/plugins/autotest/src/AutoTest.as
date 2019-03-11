package {
	import laya.display.Sprite;
	import laya.events.MouseManager;
	import laya.maths.Point;
	import laya.utils.Browser;
	
	/**
	 * 自动化测试
	 * @author yung
	 */
	public class AutoTest {
		static private var manager:MouseManager;
		private static var nodes:Array = [];
		private static var timerId:int = 0;
		
		public function AutoTest() {
			//start();
		}
		
		public static function start():void {
			trace("----------开始测试-----------");
			if (!manager) {
				manager = MouseManager.instance;
				manager.list = [{clientX: 0, clientY: 0}];
				manager.runEvent();
			}
			randomClick();
			
			var erralert:int = 0;
			Browser.window.onerror = function(msg:String, url:String, line:String, column:String, detail:*):void {
				if (erralert++ < 5 && detail) {
					console.log("报错了");
					alert("出错啦，请把此信息截图给研发商\n" + msg + "\n" + detail.stack);
				}
				stop();
				//停止渲染				
				//Laya.stage._loop = function() {
				//};
			}
		}
		
		private static function randomClick():void {
			nodes.length = 0;
			findNodes(Laya.stage);
			
			//随机找一个
			var round:int = Math.round((nodes.length - 1) * Math.random());
			var target:Sprite = nodes[round];
			
			var p:Point = new Point(target.x + 1, target.y + 1);
			target.parent.localToGlobal(p);
			
			if (Laya.stage.transform) {
				p = Laya.stage.transform.transformPoint(p);
			}
			
			manager._tTouchID = 1000;
			manager._isLeftMouse = true;
			showMosue(p.x, p.y);
			manager.check(Laya.stage, p.x, p.y, manager.onMouseDown);
			setTimeout(function() {
				manager.check(Laya.stage, p.x, p.y, manager.onMouseUp)
			}, 200);
			
			timerId = setTimeout(randomClick, 500);
		}
		
		private static function findNodes(root:Sprite):void {
			var numChildren:int = root.numChildren;
			var flag:Boolean = true;
			for (var i:int = 0; i < numChildren; i++) {
				var child:Sprite = root.getChildAt(i);
				if (child.mouseEnabled) {
					if (child.numChildren > 0) {
						findNodes(child);
						flag = false;
					} else {
						nodes.push(child);
					}
				}
			}
			if (flag) {
				nodes.push(root);
			}
		}
		
		public static function stop():void {
			trace("----------停止测试-----------");
			Browser.window.clearTimeout(timerId);
		}
		
		private static var _sp:Sprite;
		public static function showMosue(x:Number, y:Number):void {
			if (!_sp) {				
				var sp:Sprite = _sp = new Sprite();
				sp.graphics.drawCircle(10, 10, 10, 10, "#ff0000");
				sp.zOrder = 1000000;
				if (Laya.LayerManager.stage) {
					Laya.LayerManager.stage.addChild(sp);
					Laya.CanvasSprite.setSpriteCanvasRender(sp,300,false)
				}else {
					Laya.stage.addChild(sp);
				}				
			}
			_sp.pos(x, y);
		}
	}
}
package laya.debug.tools {

	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.ui.Component;
	import laya.ui.Label;
	import laya.ui.UIEvent;
	import laya.utils.Handler;
	
	/**鼠标提示管理类*/
	public class TipManagerForDebug extends Component {
		public static var offsetX:int = 10;
		public static var offsetY:int = 15;
		public static var tipTextColor:String = "#ffffff";
		public static var tipBackColor:String = "#111111";
		public static var tipDelay:Number = 200;
		private var _tipBox:Component;
		private var _tipText:Text;
		private var _defaultTipHandler:Function;
		
		public function TipManagerForDebug() {
			super();
			_tipBox = new Component();
			_tipBox.addChild(_tipText = new Text());
			_tipText.x = _tipText.y = 5;
			_tipText.color = tipTextColor;
			_defaultTipHandler = showDefaultTip;
			Laya.stage.on(UIEvent.SHOW_TIP,this, onStageShowTip);
			Laya.stage.on(UIEvent.HIDE_TIP, this,onStageHideTip);
			
		}
		
		
		private function onStageHideTip(e:UIEvent):void {
			Laya.timer.clear(this, showTip);
			closeAll();
			this.removeSelf();
		}
		
		private function onStageShowTip(data:Object):void {
			Laya.timer.once(tipDelay, this,showTip, [data],true);
		}
		
		private function showTip(tip:Object):void {
			if (tip is String) {
				var text:String = String(tip);
				if (Boolean(text)) {
					_defaultTipHandler(text);
				}
			} else if (tip is Handler) {
				(tip as Handler).run();
			} else if (tip is Function) {
				(tip as Function).apply();
			}
			if (true) {
				Laya.stage.on(Event.MOUSE_MOVE, this,onStageMouseMove);
				Laya.stage.on(Event.MOUSE_DOWN, this,onStageMouseDown);
			}
			
			onStageMouseMove(null);
		}
		
		private function onStageMouseDown(e:Event):void {
			closeAll();
		}
		
		private function onStageMouseMove(e:Event):void {
			showToStage(this,offsetX,offsetY);
		}
		
		public function showToStage(dis:Sprite, offX:int = 0, offY:int = 0):void
		{
			var rec:Rectangle = dis.getBounds();
			dis.x = Laya.stage.mouseX + offX;
			dis.y = Laya.stage.mouseY + offY;
			if (dis.x + rec.width > Laya.stage.width)
			{
				dis.x -= rec.width + offX;
			}
			if (dis.y + rec.height > Laya.stage.height)
			{
				dis.y -= rec.height + offY;
			}
		}
		/**关闭所有鼠标提示*/
		public function closeAll():void {
			Laya.timer.clear(this, showTip);
			Laya.stage.off(Event.MOUSE_MOVE, this,onStageMouseMove);
			Laya.stage.off(Event.MOUSE_DOWN, this, onStageMouseDown);
			this.removeChildren();
		}
		public function showDisTip(tip:Sprite):void
		{
			addChild(tip);
			showToStage(this);
			Laya.stage.addChild(this);
		}
		private function showDefaultTip(text:String):void {
			_tipText.text = text;
			var g:Graphics = _tipBox.graphics;
			g.clear();	
			g.drawRect(0, 0, _tipText.width + 10, _tipText.height + 10, tipBackColor);
			addChild(_tipBox);
			showToStage(this);
			Laya.stage.addChild(this);
		}
		
		/**默认鼠标提示函数*/
		public function get defaultTipHandler():Function {
			return _defaultTipHandler;
		}
		
		public function set defaultTipHandler(value:Function):void {
			_defaultTipHandler = value;
		}
	}
}
package laya.ui {

	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.ui.Component;
	import laya.ui.UIEvent;
	import laya.utils.Handler;
	
	
	/**鼠标提示管理类*/
	public class TipManager extends Component {
		public static var offsetX:int = 10;
		public static var offsetY:int = 15;
		public static var tipTextColor:String = "#ffffff";
		public static var tipBackColor:String = "#111111";
		public static var tipDelay:Number = 200;
		private var _tipBox:Component;
		private var _tipText:Text;
		private var _defaultTipHandler:Function;
		
		public function TipManager() {
			super();
			_tipBox = new Component();
			_tipBox.addChild(_tipText = new Text());
			_tipText.x = _tipText.y = 5;
			_tipText.color = tipTextColor;
			_defaultTipHandler = _showDefaultTip;
			Laya.stage.on(UIEvent.SHOW_TIP,this, _onStageShowTip);
			Laya.stage.on(UIEvent.HIDE_TIP, this,_onStageHideTip);
			
		}
		
		/**
		 * @private
		 */
		private function _onStageHideTip(e:*):void {
			Laya.timer.clear(this, _showTip);
			closeAll();
			this.removeSelf();
		}
		
		/**
		 * @private
		 */
		private function _onStageShowTip(data:Object):void {
			Laya.timer.once(tipDelay, this,_showTip, [data],true);
		}
		
		/**
		 * @private
		 */
		private function _showTip(tip:Object):void {
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
				Laya.stage.on(Event.MOUSE_MOVE, this,_onStageMouseMove);
				Laya.stage.on(Event.MOUSE_DOWN, this,_onStageMouseDown);
			}
			
			_onStageMouseMove(null);
		}
		
		/**
		 * @private
		 */
		private function _onStageMouseDown(e:Event):void {
			closeAll();
		}
		
		/**
		 * @private
		 */
		private function _onStageMouseMove(e:Event):void {
			_showToStage(this,offsetX,offsetY);
		}
		
		/**
		 * @private
		 */
		private function _showToStage(dis:Sprite, offX:int = 0, offY:int = 0):void
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
			Laya.timer.clear(this, _showTip);
			Laya.stage.off(Event.MOUSE_MOVE, this,_onStageMouseMove);
			Laya.stage.off(Event.MOUSE_DOWN, this, _onStageMouseDown);
			this.removeChildren();
		}
		
		/**
		 * 显示显示对象类型的tip
		 */
		public function showDislayTip(tip:Sprite):void
		{
			addChild(tip);
			_showToStage(this);
			Laya.stageBox.addChild(this);
		}
		
		/**
		 * @private
		 */
		private function _showDefaultTip(text:String):void {
			_tipText.text = text;
			var g:Graphics = _tipBox.graphics;
			g.clear();	
			g.drawRect(0, 0, _tipText.width + 10, _tipText.height + 10, tipBackColor);
			addChild(_tipBox);
			_showToStage(this);
			Laya.stageBox.addChild(this);
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
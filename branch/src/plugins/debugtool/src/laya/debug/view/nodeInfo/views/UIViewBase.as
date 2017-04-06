package laya.debug.view.nodeInfo.views 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.Component;
	import laya.utils.Handler;
	import laya.debug.tools.debugUI.DButton;
	import laya.debug.tools.debugUI.DInput;
	import laya.debug.tools.DisControlTool;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	/**
	 * ...
	 * @author ww
	 */
	public class UIViewBase extends Component
	{
		
		public function UIViewBase() 
		{
			dis = this;
			minHandler = new Handler(this, close);
			maxHandler = new Handler(this, show);
			createPanel();
			if (dis)
			{
				dis.on(Event.MOUSE_DOWN, this, bringToTop);
			    dis.cacheAsBitmap = true;
			}
			
		}
		public var minHandler:Handler;
		public var maxHandler:Handler;
		public var isFirstShow:Boolean = true;
		public var dis:Sprite;
		public function show():void
		{
			DebugInfoLayer.I.setTop();
			DebugInfoLayer.I.popLayer.addChild(dis);
			if (isFirstShow)
			{
				firstShowFun();
				isFirstShow = false;
			}
			
		}
		public function firstShowFun():void
		{
			dis.x = (Laya.stage.width - dis.width)*0.5;
			dis.y = (Laya.stage.height - dis.height) * 0.5;
			DisControlTool.intFyDisPos(dis);
		}
		private function bringToTop():void
		{
			DisControlTool.setTop(dis);
		}
		public function switchShow():void
		{
			if (dis.parent)
			{
				close();
			}else
			{
				show();
			}
		}
		public function close():void
		{
			dis.removeSelf();
		}
		public function createPanel():void
		{
			
		}
		public function getInput():DInput
		{
			var input:DInput;
			
			input = new DInput();
			input.size(200, 30);
			input.fontSize = 30;
			return input;
		}
		public function getButton():DButton
		{
			var btn:DButton;
			btn = new DButton();
			btn.size(40, 30);
			btn.fontSize = 30;
			
			return btn;
		}
	}

}
package laya.debug.view.nodeInfo.views 
{
	import laya.display.Input;
	import laya.events.Event;
	import laya.debug.tools.debugUI.DButton;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	/**
	 * ...
	 * @author ww
	 */
	public class TxtInfoView extends UIViewBase 
	{
		
		public function TxtInfoView() 
		{
			super();
			
		}
		private var input:Input;
		private var btn:DButton;
		override public function createPanel():void 
		{
			input = new Input();
			input.size(200, 400);
			input.multiline = true;
			input.bgColor = "#ff00ff";
			input.fontSize = 12;
			input.wordWrap = true;
			addChild(input);
			
			btn = getButton();
			btn.text = "关闭";
			btn.size(50, 20);
			btn.align = "center";
			btn.on(Event.MOUSE_DOWN, this, onCloseBtn);
			btn.pos(5,input.height+5);
			addChild(btn);
		}
		public function showInfo(txt:String):void
		{
			input.text = txt;
			show();
		}
		override public function show():void 
		{
			DebugInfoLayer.I.setTop();
			DebugInfoLayer.I.popLayer.addChild(this);
			this.x = (Laya.stage.width - this.width);
			this.y= 0;
		}
		private function onCloseBtn():void
		{
			close();
		}
	}

}
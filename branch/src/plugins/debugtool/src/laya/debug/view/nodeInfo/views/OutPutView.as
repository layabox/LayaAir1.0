package laya.debug.view.nodeInfo.views 
{
	import laya.display.Text;
	import laya.events.Event;
	import laya.debug.DebugTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.view.nodeInfo.nodetree.OutPut;
	import laya.debug.view.StyleConsts;
	/**
	 * ...
	 * @author ww
	 */
	public class OutPutView extends UIViewBase
	{
		
		public function OutPutView() 
		{
			DebugTool._logFun = log;
		}
		private static var _I:OutPutView;
		public static function get I():OutPutView
		{
			if (!_I) _I = new OutPutView();
			return _I;
		}
		public var view:OutPut;
		override public function createPanel():void
		{

			view = new OutPut();		
			DisControlTool.setDragingItem(view.txt, view);
			DisControlTool.setDragingItem(view.bg, view);
			//view.txt.editable = false;
			StyleConsts.setViewScale(view);
			view.txt.textField.overflow = Text.SCROLL;
			view.txt.textField.wordWrap = true;
			view.on(Event.MOUSE_WHEEL, this, mouseWheel);
			view.txt.text = "";
			DisControlTool.setResizeAbleEx(view);
			view.closeBtn.on(Event.CLICK, this, close);
			view.clearBtn.on(Event.CLICK, this, onClearBtn);
			dis = view;
		}
		private function onClearBtn():void
		{
			clearText();
		}
		
		private function mouseWheel(e:Event):void
		{
			//trace("mouseWheel:",e.delta);
			view.txt.textField.scrollY -= e.delta*10;
		}
		public function showTxt(str:String):void
		{
			view.txt.text = str;
			show();
			view.txt.textField.scrollY = view.txt.textField.maxScrollY;
		}
		public function clearText():void
		{
			view.txt.text = "";
		}
		public function dTrace(...arg):void
		{
			if (view.txt.textField.scrollY > 1000)
			{
				view.txt.text = "";
			}
			var str:String;
			var i:int, len:int;
			len = arg.length;
			str = arg[0];
			for (i = 1; i < len; i++)
			{
				str += " "+arg[i];
			}
			addStr(str);
		}
		public function addStr(str:String):void
		{
			view.txt.text += "\n" + str;
			show();
			view.txt.textField.scrollY = view.txt.textField.maxScrollY;
		}
		public static function log(str:String):void
		{
			I.addStr(str);
		}
	}

}
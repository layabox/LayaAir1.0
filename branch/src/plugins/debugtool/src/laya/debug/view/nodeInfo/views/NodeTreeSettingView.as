package laya.debug.view.nodeInfo.views 
{
	import laya.display.Node;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.debug.tools.DisControlTool;
	import laya.debug.view.nodeInfo.NodeConsts;
	import laya.debug.view.nodeInfo.nodetree.NodeTreeSetting;
	import laya.debug.view.StyleConsts;
	/**
	 * ...
	 * @author ww
	 */
	public class NodeTreeSettingView extends UIViewBase 
	{
		private static var _I:NodeTreeSettingView;
		public static function get I():NodeTreeSettingView
		{
			if (!_I) _I = new NodeTreeSettingView();
			return _I;
		}
		public function NodeTreeSettingView() 
		{
			super();
			
		}
		override public function createPanel():void 
		{
			super.createPanel();
			view = new NodeTreeSetting();
			StyleConsts.setViewScale(view);
			addChild(view);
			inits();
			dis = view;
		}
		private var view:NodeTreeSetting;
		override public function show():void 
		{	
			super.show();
		}
		private var _handler:Handler;
		public function showSetting(filters:Array, callBack:Handler,tar:Object=null):void
		{
			if (tar is Node)
			{
				view.showTxt.text = NodeConsts.defaultFitlerStr.split(",").join("\n");
			}else
			{
				view.showTxt.text = filters.join("\n");
			}
			
			_handler = callBack;
			show();
		}
		private function inits():void
		{
			view.okBtn.on(Event.CLICK, this, onOkBtn);
			view.closeBtn.on(Event.CLICK, this, onCloseBtn);
			
			DisControlTool.setDragingItem(view.bg, view);
			dis = view;
		}
		private function onCloseBtn():void
		{	
			close();
		}
		private function onOkBtn():void
		{
			close();
			var showArr:Array;
			showArr = view.showTxt.text.split("\n");
			if (_handler)
			{
				_handler.runWith([showArr]);
				_handler=null
			}
			
		}
	}

}
package laya.debug.view.nodeInfo.views 
{
	import laya.events.Event;
	import laya.debug.DebugTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.StringTool;
	import laya.debug.view.nodeInfo.nodetree.FindNodeSmall;
	import laya.debug.view.nodeInfo.nodetree.NodeTree;
	import laya.debug.view.nodeInfo.ToolPanel;
	import laya.debug.view.StyleConsts;
	/**
	 * ...
	 * @author ww
	 */
	public class FindSmallView extends UIViewBase 
	{
		
		public function FindSmallView() 
		{
			super();
			
		}
		private static var _I:FindSmallView;
		public static function get I():FindSmallView
		{
			if (!_I) _I = new FindSmallView();
			return _I;
		}
		public var view:FindNodeSmall;
		override public function createPanel():void
		{

			view = new FindNodeSmall();		
			StyleConsts.setViewScale(view);
			DisControlTool.setDragingItem(view.bg, view);
			view.typeSelect.selectedIndex = 1;
			view.closeBtn.on(Event.CLICK, this, close);
			view.findBtn.on(Event.CLICK, this, onFind);
			//view.result.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			dis = view;
		}
		
        private function onFind():void
		{
			var key:String;
			key = view.findTxt.text;
			key = StringTool.trimSide(key);
			var nodeList:Array;
			if (view.typeSelect.selectedIndex == 0)
			{
				nodeList = DebugTool.findNameHas(key, false);
			}else
			{
				nodeList = DebugTool.findClassHas(Laya.stage, key);
			}
			//NodeTree.I.showNodeList(nodeList);
			ToolPanel.I.showSelectItems(nodeList);
			close();
		}

	}

}
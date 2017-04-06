package laya.debug.view.nodeInfo.views 
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.debug.DebugTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.DisplayHook;
	import laya.debug.tools.MouseEventAnalyser;
	import laya.debug.tools.Notice;
	import laya.debug.uicomps.ContextMenuItem;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.nodetree.DebugPage;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.ToolPanel;
	import laya.debug.view.StyleConsts;
	
	/**
	 * ...
	 * @author ww
	 */
	public class DebugPanelView extends UIViewBase 
	{
		
		public function DebugPanelView() 
		{
			super();
			_selectTip.setBounds(new Rectangle(0, 0, 0, 0 ));
		}
		private static var _I:DebugPanelView;
		public static function get I():DebugPanelView
		{
			if (!_I) _I = new DebugPanelView();
			return _I;
		}
		public var view:DebugPage;
		
		private var dragIcon:Sprite;
		override public function createPanel():void
		{

			view = new DebugPage();		
			//DisControlTool.setDragingItem(view.txt, view);
			
			dis = view;
			view.minBtn.minHandler = this.minHandler;
			view.minBtn.maxHandler = this.maxHandler;
			view.minBtn.tar = view;
			DisControlTool.setDragingItem(view.bg, view);
			DisControlTool.setDragingItem(view.tab, view);
			DisControlTool.setDragingItem(view.clearBtn, view);
			clickSelectChange();
			view.selectWhenClick.on(Event.CHANGE, this, clickSelectChange);
			Notice.listen(DisplayHook.ITEM_CLICKED, this, itemClicked);
			StyleConsts.setViewScale(view);
			dragIcon = view.dragIcon;
			dragIcon.removeSelf();
			
			view.mouseAnalyseBtn.on(Event.MOUSE_DOWN, this, mouseAnalyserMouseDown);
			dragIcon.on(Event.DRAG_END, this, mouseAnalyserDragEnd);
			
			view.clearBtn.on(Event.MOUSE_DOWN, this, clearBtnClick);
		}
		private function clearBtnClick():void
		{
			DebugTool.clearDebugLayer();
		}
		private static var tempPos:Point=new Point();
		private function mouseAnalyserMouseDown():void
		{
			var gPos:Point = tempPos;
			gPos.setTo(0, 0);
			gPos = view.mouseAnalyseBtn.localToGlobal(gPos);
			dragIcon.pos(gPos.x, gPos.y);
			dragIcon.mouseEnabled = false;
			Laya.stage.addChild(dragIcon);
			dragIcon.startDrag();
			
		}
		private function mouseAnalyserDragEnd():void
		{
			dragIcon.removeSelf();
			selectTarget(DisplayHook.instance.getDisUnderMouse());
			NodeToolView.I.showByNode(DisplayHook.instance.getDisUnderMouse(), false);
			//if (NodeToolView.I.target)
			//{
				//MouseEventAnalyser.analyseNode(NodeToolView.I.target);
			//}
		}
		public function switchToTree():void
		{
			view.tab.selectedIndex = 0;
		}
		public function swichToSelect():void
		{
			view.tab.selectedIndex = 1;
		}
		public static var ignoreDebugTool:Boolean=true;
		private function itemClicked(tar:Sprite):void
		{
			if (!isClickSelectState) return;
			if (ignoreDebugTool)
			{
				if (DebugInfoLayer.I.isDebugItem(tar)) return;
			}
			if (tar is ContextMenuItem || tar.parent is ContextMenuItem)
			{
				return ;
			}
			//ToolPanel.I.showNodeTree(tar);
			//NodeToolView.I.showByNode(tar);
			ToolPanel.I.showSelectInStage(tar);
			NodeToolView.I.showByNode(tar, false);
			view.selectWhenClick.selected = false;
			DebugTool.showDisBound(tar);
			clickSelectChange();
		}
		private function selectTarget(tar:Sprite):void
		{
			if (!tar) return;
			ToolPanel.I.showSelectInStage(tar);
			DebugTool.showDisBound(tar);
		}
		public static var isClickSelectState:Boolean = false;
		private function clickSelectChange():void
		{
			isClickSelectState = view.selectWhenClick.selected;
			
			if (!Browser.onPC) return;
			tSelectTar = null;
			clearSelectTip();
			if (isClickSelectState)
			{
				Laya.timer.loop(200, this, updateSelectTar, null, true);
			}else
			{
				Laya.timer.clear(this, updateSelectTar);
			}
		}
		private function clearSelectTip():void
		{
			_selectTip.removeSelf();
		}
		private var _selectTip:Sprite=new Sprite();
		private var tSelectTar:Sprite;
		private function updateSelectTar():void
		{
			clearSelectTip();
			tSelectTar = DisplayHook.instance.getDisUnderMouse();
			if (!tSelectTar)
			{
				return;
			} 
			if (DebugInfoLayer.I.isDebugItem(tSelectTar)) return;
			var g:Graphics;
			g = _selectTip.graphics;
			g.clear();
			var rec:Rectangle;
			rec = NodeUtils.getGRec(tSelectTar);
			DebugInfoLayer.I.popLayer.addChild(_selectTip);
			//_selectTip.alpha = 0.2;
			g.drawRect(0, 0, rec.width, rec.height, null,"#00ffff",2);
			_selectTip.pos(rec.x, rec.y);
		}
	}

}
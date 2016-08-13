package laya.debug.view.nodeInfo 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.debug.DebugTool;
	import laya.debug.tools.debugUI.DButton;
	import laya.debug.tools.debugUI.DInput;
	import laya.debug.tools.resizer.DisResizer;
	import laya.debug.tools.TipManagerForDebug;
	import laya.debug.uicomps.ContextMenu;
	import laya.debug.view.nodeInfo.nodetree.DebugPanel;
	import laya.debug.view.nodeInfo.nodetree.NodeTree;
	import laya.debug.view.nodeInfo.views.DebugPanelView;
	import laya.debug.view.nodeInfo.views.FilterView;
	import laya.debug.view.nodeInfo.views.FindView;
	import laya.debug.view.nodeInfo.views.NodeTreeView;
	import laya.debug.view.nodeInfo.views.OutPutView;
	import laya.debug.view.nodeInfo.views.SelectInfosView;
	import laya.debug.view.nodeInfo.views.ToolBarView;
	import laya.debug.view.nodeInfo.views.TxtInfoView;
	import laya.debug.view.nodeInfo.views.UIViewBase;
	/**
	 * ...
	 * @author ww
	 */
	public class ToolPanel extends Sprite
	{
		
		public function ToolPanel() 
		{
			Base64AtlasManager.base64.preLoad(Handler.create(this,showToolBar));
			ContextMenu.init();
			//createViews();
			DisResizer.init();
			var tipManager:TipManagerForDebug;
			tipManager = new TipManagerForDebug();
			//Laya.timer.once(1000, this, showToolBar);
		}
		private function showToolBar():void
		{
			//ToolBarView.I.show();
			//trace("showDebugPanel");
			DebugPanelView.I.show();
		}
		public static var I:ToolPanel;
		public static function init():void
		{
			if (!I) I = new ToolPanel();
		}
		public static var viewDic:Object = { };
		
		public static const Find:String = "Find";
		public static const Filter:String = "Filter";
		public static const TxtInfo:String = "TxtInfo";
		public static const Tree:String = "Tree";
		public static const typeClassDic:Object = 
		{
		};
		private function createViews():void
		{
			typeClassDic[Find] = FindView;
			typeClassDic[Filter] = FilterView;
			typeClassDic[TxtInfo] = TxtInfoView;
			typeClassDic[Tree] = NodeTreeView;
		}
		public function switchShow(type:String):void
		{
			var view:UIViewBase;
			view = getView(type);
			if (view)
			{
				view.switchShow();
			}
		}
		public function getView(type:String):UIViewBase
		{
			var view:UIViewBase;
			view = viewDic[type];
			if (!view && typeClassDic[type])
			{
				view = viewDic[type] = new typeClassDic[type]();
			}
			return view;
		}
		public function showTxtInfo(txt:String):void
		{
			OutPutView.I.showTxt(txt);
		}
		public function showNodeTree(node:Sprite):void
		{
			//var nodeTreeView:NodeTreeView;
			//nodeTreeView = getView(Tree) as NodeTreeView;
			//nodeTreeView.showByNode(node);
			
			NodeTree.I.setDis(node);
			DebugPanelView.I.switchToTree();
		}
		public function showSelectInStage(node:Sprite):void
		{
			//var nodeTreeView:NodeTreeView;
			//nodeTreeView = getView(Tree) as NodeTreeView;
			//nodeTreeView.showSelectInStage(node);
			NodeTree.I.showSelectInStage(node);
			DebugPanelView.I.switchToTree();
		}
		public function showSelectItems(selectList:Array):void
		{
			DebugPanelView.I.swichToSelect();
			SelectInfosView.I.setSelectList(selectList);
			
		}
	}

}
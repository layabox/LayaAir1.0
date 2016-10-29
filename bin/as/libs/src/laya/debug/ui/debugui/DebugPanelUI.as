/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.view.nodeInfo.nodetree.MinBtnComp;
	import laya.debug.view.nodeInfo.views.NodeTreeView;
	import laya.debug.view.nodeInfo.nodetree.Profile;
	import laya.debug.view.nodeInfo.views.SelectInfosView;

	public class DebugPanelUI extends View {
		public var bg:Image;
		public var minBtn:MinBtnComp;
		public var treePanel:NodeTreeView;
		public var selectWhenClick:CheckBox;
		public var profilePanel:Profile;
		public var resizeBtn:Button;
		public var mouseAnalyseBtn:Clip;
		public var dragIcon:Clip;
		public var clearBtn:Button;
		public var selectPanel:SelectInfosView;
		public var tab:Tab;

		public static var uiView:Object ={"type":"View","props":{"base64pic":true,"width":260,"height":400},"child":[{"type":"Image","props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Image","props":{"y":0,"skin":"view/bg_top.png","left":0,"right":0}},{"type":"MinBtnComp","props":{"y":-3,"var":"minBtn","runtime":"laya.debug.view.nodeInfo.nodetree.MinBtnComp","right":-3,"x":207}},{"type":"NodeTree","props":{"left":0,"right":0,"top":32,"bottom":0,"name":"节点树","var":"treePanel","runtime":"laya.debug.view.nodeInfo.views.NodeTreeView"}},{"type":"CheckBox","props":{"x":8,"y":9,"skin":"view/clickselect.png","toolTip":"点击选取","var":"selectWhenClick","mouseEnabled":true,"width":14,"height":14}},{"type":"Profile","props":{"name":"性能","top":32,"right":0,"left":0,"bottom":0,"var":"profilePanel","runtime":"laya.debug.view.nodeInfo.nodetree.Profile"}},{"type":"Button","props":{"x":169,"y":247,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","var":"resizeBtn","stateNum":3}},{"type":"Clip","props":{"y":9,"skin":"view/clickanalyse.png","var":"mouseAnalyseBtn","toolTip":"拖动选取","left":33,"x":33,"clipY":3}},{"type":"Clip","props":{"y":0,"skin":"view/clickanalyse.png","var":"dragIcon","x":33,"clipY":3}},{"type":"Button","props":{"y":7,"skin":"view/res.png","stateNum":2,"toolTip":"清除边框","var":"clearBtn","right":34,"x":184}},{"type":"SelectInfos","props":{"top":32,"left":0,"right":0,"bottom":0,"name":"选中","var":"selectPanel","runtime":"laya.debug.view.nodeInfo.views.SelectInfosView"}},{"type":"Tab","props":{"x":59,"y":0,"name":"tab","var":"tab","selectedIndex":0},"child":[{"type":"Button","props":{"skin":"view/tab_panel.png","label":"节点","width":42,"height":32,"name":"item0","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":42,"skin":"view/tab_panel.png","label":"查询","width":42,"height":32,"name":"item1","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":84,"skin":"view/tab_panel.png","label":"性能","width":42,"height":32,"name":"item2","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}}]}]};
		public function DebugPanelUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.view.nodeInfo.nodetree.MinBtnComp",MinBtnComp);
			View.regComponent("laya.debug.view.nodeInfo.views.NodeTreeView",NodeTreeView);
			View.regComponent("laya.debug.view.nodeInfo.nodetree.Profile",Profile);
			View.regComponent("laya.debug.view.nodeInfo.views.SelectInfosView",SelectInfosView);

		}
	}
}
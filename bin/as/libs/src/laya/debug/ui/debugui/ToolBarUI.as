/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.view.nodeInfo.nodetree.MinBtnComp;

	public class ToolBarUI extends View {
		public var bg:Image;
		public var treeBtn:Button;
		public var findBtn:Button;
		public var minBtn:MinBtnComp;
		public var selectWhenClick:CheckBox;
		public var clearBtn:Button;
		public var rankBtn:Button;
		public var nodeRankBtn:Button;
		public var cacheBtn:Button;

		public static var uiView:Object ={"type":"View","props":{"base64pic":true,"width":250,"height":30},"child":[{"type":"Image","props":{"x":195,"y":244,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Button","props":{"x":2,"y":6,"skin":"view/save.png","stateNum":2,"var":"treeBtn","toolTip":"节点树"}},{"type":"Button","props":{"x":25,"y":6,"skin":"view/save.png","stateNum":2,"var":"findBtn","toolTip":"查找面板"}},{"type":"MinBtnComp","props":{"x":218,"y":-3,"var":"minBtn","runtime":"laya.debug.view.nodeInfo.nodetree.MinBtnComp"}},{"type":"CheckBox","props":{"x":124,"y":8,"skin":"comp/checkbox.png","label":"点击选取","var":"selectWhenClick","labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"}},{"type":"Button","props":{"x":193,"y":5,"skin":"view/res.png","stateNum":2,"toolTip":"清除边框","var":"clearBtn"}},{"type":"Button","props":{"x":49,"y":6,"skin":"view/save.png","stateNum":2,"var":"rankBtn","toolTip":"渲染用时排行"}},{"type":"Button","props":{"x":72,"y":6,"skin":"view/save.png","stateNum":2,"var":"nodeRankBtn","toolTip":"创建对象排行"}},{"type":"Button","props":{"x":94,"y":6,"skin":"view/save.png","stateNum":2,"var":"cacheBtn","toolTip":"cache对象"}}]};
		public function ToolBarUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.view.nodeInfo.nodetree.MinBtnComp",MinBtnComp);

		}
	}
}
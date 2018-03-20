/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.RankListItem;

	public class NodeListPanelUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var title:Label;
		public var itemList:List;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":235,"y":284,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":204,"y":32,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":true},"type":"Button"},{"props":{"x":10,"y":6,"text":"节点信息","width":147,"height":16,"color":"#288edf","var":"title"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","left":2,"right":2,"top":26,"bottom":0,"repeatX":1,"x":20}}],"props":{"width":200,"height":300}};
		public function NodeListPanelUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.uicomps.RankListItem",RankListItem);

		}
	}
}
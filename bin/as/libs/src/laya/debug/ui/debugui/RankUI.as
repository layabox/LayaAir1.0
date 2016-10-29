/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.RankListItem;

	public class RankUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var title:Label;
		public var itemList:List;
		public var autoUpdate:CheckBox;
		public var freshBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":225,"y":274,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":194,"y":22,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":false},"type":"Button"},{"props":{"x":8,"y":5,"text":"渲染用时表(3000ms)","width":109,"height":16,"color":"#288edf","var":"title"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","left":2,"right":2,"top":26,"bottom":25,"repeatX":1,"x":10,"y":10}},{"props":{"skin":"comp/checkbox.png","label":"自动刷新属性","var":"autoUpdate","bottom":3,"selected":false,"visible":true,"left":2,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"},{"props":{"y":1,"skin":"view/refresh2.png","var":"freshBtn","toolTip":"刷新数据","right":1},"type":"Button"}],"props":{"width":200,"height":300}};
		public function RankUI(){}
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
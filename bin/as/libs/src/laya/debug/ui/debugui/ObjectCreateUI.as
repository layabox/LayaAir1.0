/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.RankListItem;

	public class ObjectCreateUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var itemList:List;
		public var freshBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":215,"y":264,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":184,"y":12,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":false},"type":"Button"},{"props":{"x":11,"y":5,"text":"对象创建统计","width":83,"height":16,"color":"#288edf"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"y":0,"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","top":26,"bottom":5,"left":5,"right":5,"repeatX":1}},{"props":{"y":1,"skin":"view/refresh2.png","var":"freshBtn","toolTip":"刷新数据","right":1,"x":178},"type":"Button"}],"props":{"width":200,"height":300,"base64pic":true}};
		public function ObjectCreateUI(){}
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
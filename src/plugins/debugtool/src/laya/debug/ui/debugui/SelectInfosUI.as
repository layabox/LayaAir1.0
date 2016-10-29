/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.RankListItem;

	public class SelectInfosUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var selectList:List;
		public var findBtn:Clip;
		public var fliterTxt:TextInput;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"skin":"view/btn_close.png","var":"closeBtn","top":32,"visible":false,"right":2},"type":"Button"},{"props":{"x":7,"y":36,"text":"当前选中列表","width":83,"height":16,"color":"#288edf"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"selectList","left":5,"right":5,"top":56,"bottom":25,"repeatX":1,"x":20}},{"props":{"x":6,"text":"Alt+V选取鼠标下的对象","width":189,"height":16,"color":"#a0a0a0","bottom":3},"type":"Label"},{"type":"Image","props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0}},{"type":"Clip","props":{"y":6,"skin":"view/search.png","clipY":2,"var":"findBtn","right":5,"toolTip":"查找","x":174}},{"type":"TextInput","props":{"y":6,"skin":"view/bg_top.png","height":22,"var":"fliterTxt","left":8,"right":45,"color":"#a0a0a0","x":8,"width":147}}],"props":{"width":200,"height":300,"base64pic":true}};
		public function SelectInfosUI(){}
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